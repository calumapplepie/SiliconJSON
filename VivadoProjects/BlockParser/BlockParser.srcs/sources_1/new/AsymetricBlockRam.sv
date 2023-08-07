// Dual-Port Block RAM with Two Write Ports
// File: rams_tdp_rf_rf.v

// 7 Series block rams are capable of all kinds of nonsense.  Each read and write port can be different bitwidths
// while I could use Xylinx libraries, I don't want to, for copyright and portability reasons.  Bad enough I carried the
// initial version of this file over.
// Also, IF inference works properly, then this model is more generalizable; i don't need to worry so much about
// how to divide this among block rams.  However, it does not work properly in the case of asymetric (read/write) TDP
// block rams.  As of Vivado 2023.1.1, there is a change request filed to at least make it not crash.
`ifdef SYNTHESIS
`define VIVADO_BROKEN 1
`endif

module AsymetricBlockRam #(
            WORDSIZE=8, WORDSIZE_IN=WORDSIZE, WORDSIZE_OUT=WORDSIZE, // default to symetric, but allow asymetric reading  
            NUMWORDS=64, ADDRWIDTH=$clog2(NUMWORDS), DO_REG=1) (
    input logic clk, ena, enb, wea,web, 
    input [ADDRWIDTH-1:0] addra,addrb, 
    input [WORDSIZE_IN-1:0] dia,dib,
    output wire [WORDSIZE_OUT-1:0] doa,dob // make output a net so we can do silly things with 'z
);


`ifdef VIVADO_BROKEN
// yay i get to do this stuff manually!!!! wooohoooooooo!!!!
generate 
parameter WORDSIZE_MIN = WORDSIZE_IN > WORDSIZE_OUT ? WORDSIZE_OUT : WORDSIZE_IN;
parameter WORDSIZE_MAX = WORDSIZE_IN < WORDSIZE_OUT ? WORDSIZE_OUT : WORDSIZE_IN;

parameter BRAM_DEPTH = WORDSIZE_MIN * NUMWORDS;
parameter BRAM_SIZE = (BRAM_DEPTH < 16384 && WORDSIZE_MAX <=18 ) ? "18Kb" : "36Kb"; // could in theory improve efficency, but thats AMD's job

parameter int WIDTH_CUTS = int'( $ceil((WORDSIZE_MAX) / (32.0)));//.0 makes this a REAL boy!
parameter int DEPTH_CUTS = int'( $ceil((BRAM_DEPTH) / (32768.0 * WIDTH_CUTS)));

parameter WIDTH_READ = WORDSIZE_OUT/WIDTH_CUTS; // if someone is using extra wide words, they can be reasonable for me.
parameter WIDTH_WRITE = WORDSIZE_IN/WIDTH_CUTS; // (ie, make sure that their width is divisible by the number of cuts i'll need to do)

// just do 4 bits, it'll truncate if that's too many    
wire [3:0] WEA = {4{wea}};
wire [3:0] WEB = {4{web}};


genvar depth_i, width_i;

for(depth_i = 0; depth_i < DEPTH_CUTS; depth_i++) begin
    for(width_i = 0; width_i < WIDTH_CUTS; width_i++) begin
        logic useThisOneA = '1;
        logic useThisOneB = '1;
        if (DEPTH_CUTS > 1) begin
        always_comb begin
            useThisOneA = (addra[ADDRWIDTH-1 -: $clog2(DEPTH_CUTS)] == depth_i)? '1 : '0;
            useThisOneB = (addrb[ADDRWIDTH-1 -: $clog2(DEPTH_CUTS)] == depth_i)? '1 : '0;
        end end
        logic [WIDTH_READ-1:0] thisDoa, thisDob;
        
        // only assign bits of output if it's our turn
        assign doa[WIDTH_READ * (width_i+1)-1 -: WIDTH_READ] = useThisOneA ? thisDoa : 'z;
        assign dob[WIDTH_READ * (width_i+1)-1 -: WIDTH_READ] = useThisOneB ? thisDob : 'z;
        
        // Xilinx HDL Language Template, version 2022.2
        BRAM_TDP_MACRO #(
           .BRAM_SIZE(BRAM_SIZE), // Target BRAM: "18Kb" or "36Kb"
           .DOA_REG(DO_REG), .DOB_REG(DO_REG),        // Optional port B output register (0 or 1) (yes i can disable this)
           .READ_WIDTH_A (WIDTH_READ), .READ_WIDTH_B (WIDTH_READ),   // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
           .SIM_COLLISION_CHECK ("ALL"), // Collision check enable "ALL", "WARNING_ONLY",
                                         //   "GENERATE_X_ONLY" or "NONE"
           .INIT_00({{8{4'h7}},{8{8'h6}},{8{4'h5}},{8{4'h4}},{8{4'h3}},{8{4'h2}},{8{4'h1}},{8{4'h0}}}),
           .INIT_01({{8{4'hF}},{8{4'hE}},{8{4'hD}},{8{4'hC}},{8{4'hB}},{8{4'hA}},{8{4'h9}},{8{4'h8}}}),           
           .INIT_A(36'hCDCDCDCD),
           .WRITE_MODE_A("WRITE_FIRST"), .WRITE_MODE_B("WRITE_FIRST"), // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE"
           .WRITE_WIDTH_A(WIDTH_WRITE), .WRITE_WIDTH_B(WIDTH_WRITE) // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
        ) BRAM_TDP_MACRO_inst (
           .DOA(thisDoa),       // Output port-A data, width defined by READ_WIDTH_A parameter
           .DOB(thisDob),       // Output port-B data, width defined by READ_WIDTH_B parameter
           .ADDRA({7'd0,addra}), .ADDRB({7'd0,addrb}),   // rely on auto truncation
           .CLKA(clk), .CLKB(clk),     // tik tock goes the clock 
           .DIA(dia[WIDTH_WRITE * (width_i+1)-1 -: WIDTH_WRITE]),       // Input port-A data, width defined by WRITE_WIDTH_A parameter
           .DIB(dib[WIDTH_WRITE * (width_i+1)-1 -: WIDTH_WRITE]),       // Input port-B data, width defined by WRITE_WIDTH_B parameter
           .ENA(ena & useThisOneA),       // 1-bit input port-A enable
           .ENB(enb & useThisOneB),       // 1-bit input port-B enable
           .REGCEA(ena & useThisOneA), .REGCEB(enb & useThisOneB), // register enabler? i hardley know her!
           .RSTA('0), .RSTB('0),     // resets are for chumps
           .WEA, .WEB    
        );
        
        // End of BRAM_TDP_MACRO_inst instantiation
    end
end
endgenerate

`else // ie, we aren't trying to do a synthesis in vivado

// maybe in is big, maybe out is big; user chooses
localparam WORDSIZE_RAM = WORDSIZE_IN > WORDSIZE_OUT ? WORDSIZE_OUT : WORDSIZE_IN;
logic [WORDSIZE_RAM-1:0] ram [0:NUMWORDS-1];

localparam READ_RATIO   =  WORDSIZE_OUT / WORDSIZE_RAM;
localparam WRITE_RATIO  =  WORDSIZE_IN  / WORDSIZE_RAM;


// canary-ify ram on initialization
// however, we assume the RAM is initialized to 0 in stack, so zero it in some places 
initial begin 
    foreach(ram[i]) ram[i] = {WORDSIZE_RAM/8{8'hBA}};
    ram[NUMWORDS-1] = '0;
    ram[0]          = '0; 
end

always_ff @(posedge clk) begin
    if (ena) begin
        if (wea) begin
            if (WRITE_RATIO == 1) ram[addra] <= dia;
            else for(integer i = 0; i < WRITE_RATIO; i++) begin
                automatic logic [ADDRWIDTH-1:0] address = addra +i;
                ram[address] <= dia[(i+1)*WORDSIZE_RAM-1 -: WORDSIZE_RAM]; // saw this in the xylinx docs and wondered what it was; now I know!
            end
        end
        
        if(READ_RATIO == 1) doa <= ram[addra];
        else for(integer i = 0; i < READ_RATIO; i++) begin
            automatic logic [ADDRWIDTH-1:0] address = addra+i;
            doa[(i+1)*WORDSIZE_RAM-1 -: WORDSIZE_RAM] <= ram[address]; // saw this in the docs and wondered what it was; now I know!
        end
        
    end
end

always_ff @(posedge clk) begin
    if (enb) begin
        if (web) begin
            if (WRITE_RATIO == 1) ram[addrb] <= dib;
            else for(integer i = 0; i < WRITE_RATIO; i++) begin
                automatic logic [ADDRWIDTH-1:0] address = addrb+i;
                ram[address] <= dib[(i+1)*WORDSIZE_RAM-1 -: WORDSIZE_RAM]; // saw this in the xylinx docs and wondered what it was; now I know!
            end
        end
        
        if(READ_RATIO == 1) dob <= ram[addrb];
        else for(integer i = 0; i < READ_RATIO; i++) begin
            automatic logic [ADDRWIDTH-1:0] address = addrb+i;
            dob[(i+1)*WORDSIZE_RAM-1 -: WORDSIZE_RAM] <= ram[address]; // saw this in the docs and wondered what it was; now I know!
        end
        
    end
end
`endif
endmodule
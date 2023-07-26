// Dual-Port Block RAM with Two Write Ports
// File: rams_tdp_rf_rf.v

// 7 Series block rams are capable of all kinds of nonsense.  Each read and write port can be different bitwidths
// while I could use Xylinx libraries, I don't want to, for copyright and portability reasons.  Bad enough I carried the
// initial version of this file over.
// Also, IF inference works properly, then this model is more generalizable; i don't need to worry so much about
// how to divide this among block rams.  However, it does not work properly in the case of asymetric (read/write) TDP
// block rams.  As of Vivado 2023.1.1, there is a change request filed to at least make it not crash.
`define VIVADO_BROKEN 1
module TapeBlockRam #(
            WORDSIZE=8, WORDSIZE_IN=WORDSIZE, WORDSIZE_OUT=WORDSIZE, // default to symetric, but allow asymetric reading  
            NUMWORDS=64, ADDRWIDTH=$clog2(NUMWORDS)) (
    input logic clk, ena, enb, wea,web, 
    input [ADDRWIDTH-1:0] addra,addrb, 
    input [WORDSIZE_IN-1:0] dia,dib,
    output logic [WORDSIZE_OUT-1:0] doa,dob
);


`ifdef VIVADO_BROKEN
// yay i get to do this stuff manually!!!! wooohoooooooo!!!!
generate 
parameter WORDSIZE_MIN = WORDSIZE_IN > WORDSIZE_OUT ? WORDSIZE_OUT : WORDSIZE_IN;
parameter WORDSIZE_MAX = WORDSIZE_IN < WORDSIZE_OUT ? WORDSIZE_OUT : WORDSIZE_IN;

parameter BRAM_DEPTH = WORDSIZE_MIN * NUMWORDS;
parameter BRAM_SIZE = BRAM_DEPTH < 16384 ? "18Kb" : "36Kb"; // could in theory improve efficency, but thats AMD's job

parameter WIDTH_CUTS = int'( $ceil(real'(WORDSIZE_MAX) / real'(32)));//.0 makes this a REAL boy!
parameter DEPTH_CUTS = int'( $ceil(real'(BRAM_DEPTH) / real'(32768)));

parameter WIDTH_READ = WORDSIZE_OUT/WIDTH_CUTS; // if someone is using extra wide words, they can be reasonable for me.
parameter WIDTH_WRITE = WORDSIZE_IN/WIDTH_CUTS;

genvar width_i, depth_i;
for(depth_i = 0; depth_i < DEPTH_CUTS; depth_i++) begin
for(width_i = 0; width_i < WIDTH_CUTS; width_i++) begin
logic useThisOneA = addra[ADDRWIDTH-1 -: $clog2(DEPTH_CUTS)] == depth_i;
logic useThisOneB = addrb[ADDRWIDTH-1 -: $clog2(DEPTH_CUTS)] == depth_i;

// Xilinx HDL Language Template, version 2022.2
BRAM_TDP_MACRO #(
   .BRAM_SIZE(BRAM_SIZE), // Target BRAM: "18Kb" or "36Kb"
   .DOA_REG(1), .DOB_REG(1),        // Optional port B output register (0 or 1) (yes i can disable this)
   .READ_WIDTH_A (WIDTH_READ), .READ_WIDTH_B (WIDTH_READ),   // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
   .SIM_COLLISION_CHECK ("ALL"), // Collision check enable "ALL", "WARNING_ONLY",
                                 //   "GENERATE_X_ONLY" or "NONE"
   .WRITE_MODE_A("WRITE_FIRST"), .WRITE_MODE_B("WRITE_FIRST"), // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE"
   .WRITE_WIDTH_A(WIDTH_WRITE), .WRITE_WIDTH_B(WIDTH_WRITE) // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
) BRAM_TDP_MACRO_inst (
   .DOA(doa[WIDTH_READ * (width_i+1)-1 -: WIDTH_READ]),       // Output port-A data, width defined by READ_WIDTH_A parameter
   .DOB(dob[WIDTH_READ * (width_i+1)-1 -: WIDTH_READ]),       // Output port-B data, width defined by READ_WIDTH_B parameter
   .ADDRA(addrb), .ADDRB(addra),   // rely on auto truncation
   .CLKA(clk), .CLKB(clk),     // tik tock goes the clock 
   .DIA(dia[WIDTH_WRITE * (width_i+1)-1 -: WIDTH_WRITE]),       // Input port-A data, width defined by WRITE_WIDTH_A parameter
   .DIB(dib[WIDTH_WRITE * (width_i+1)-1 -: WIDTH_WRITE]),       // Input port-B data, width defined by WRITE_WIDTH_B parameter
   .ENA(ena & useThisOneA),       // 1-bit input port-A enable
   .ENB(enb & useThisOneB),       // 1-bit input port-B enable
   .REGCEA('1), .REGCEB('1), // register enabler? i hardley know her!
   .RSTA('0), .RSTB('0),     // resets are for chumps
   .WEA({4{wea}}), .WEB({4{web}})  // just do 4 bits, it'll truncate if that's too many        
);

// End of BRAM_TDP_MACRO_inst instantiation
end
end
endgenerate
`else
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
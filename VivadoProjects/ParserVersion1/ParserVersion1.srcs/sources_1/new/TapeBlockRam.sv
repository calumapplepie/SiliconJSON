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
// Xilinx HDL Language Template, version 2022.2
BRAM_TDP_MACRO #(
   .BRAM_SIZE("36Kb"), // Target BRAM: "18Kb" or "36Kb"
   .DOA_REG(1),        // Optional port A output register (0 or 1)
   .DOB_REG(1),        // Optional port B output register (0 or 1)
   .READ_WIDTH_A (WORDSIZE_OUT),   // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
   .READ_WIDTH_B (WORDSIZE_OUT),   // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
   .SIM_COLLISION_CHECK ("ALL"), // Collision check enable "ALL", "WARNING_ONLY",
                                 //   "GENERATE_X_ONLY" or "NONE"
   .WRITE_MODE_A("WRITE_FIRST"), // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE"
   .WRITE_MODE_B("WRITE_FIRST"), // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE"
   .WRITE_WIDTH_A(WORDSIZE_IN), // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
   .WRITE_WIDTH_B(WORDSIZE_IN) // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
) BRAM_TDP_MACRO_inst (
   .DOA(doa),       // Output port-A data, width defined by READ_WIDTH_A parameter
   .DOB(dob),       // Output port-B data, width defined by READ_WIDTH_B parameter
   .ADDRA(addrb),   // Input port-A address, width defined by Port A depth
   .ADDRB(addra),   // Input port-B address, width defined by Port B depth
   .CLKA(clk),     // 1-bit input port-A clock
   .CLKB(clk),     // 1-bit input port-B clock
   .DIA(dia),       // Input port-A data, width defined by WRITE_WIDTH_A parameter
   .DIB(dib),       // Input port-B data, width defined by WRITE_WIDTH_B parameter
   .ENA(ena),       // 1-bit input port-A enable
   .ENB(enb),       // 1-bit input port-B enable
   .REGCEA('1), // 1-bit input port-A output register enable
   .REGCEB('1), // 1-bit input port-B output register enable
   .RSTA('0),     // 1-bit input port-A reset
   .RSTB('0),     // 1-bit input port-B reset
   .WEA({4{wea}}),       // Input port-A write enable, width defined by Port A depth
   .WEB({4{web}})        // Input port-B write enable, width defined by Port B depth
);

// End of BRAM_TDP_MACRO_inst instantiation

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
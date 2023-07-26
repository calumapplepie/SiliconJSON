// Dual-Port Block RAM with Two Write Ports
// File: rams_tdp_rf_rf.v

// 7 Series block rams are capable of all kinds of nonsense.  Each read and write port can be different bitwidths
// while I could use Xylinx libraries, I don't want to, for copyright and portability reasons.  Bad enough I carried the
// initial version of this file over.
// Also, IF inference works properly, then this model is more generalizable; i don't need to worry so much about
// how to divide this among block rams.  However, it does not work properly in the case of asymetric (read/write) TDP
// block rams.  As of Vivado 2023.1.1, there is a change request filed to at least make it not crash.
`define VIVADO_BROKEN
module TapeBlockRam #(
            WORDSIZE=8, WORDSIZE_IN=WORDSIZE, WORDSIZE_OUT=WORDSIZE, // default to symetric, but allow asymetric reading  
            NUMWORDS=64, ADDRWIDTH=$clog2(NUMWORDS)) (
    input logic clk, ena, enb, wea,web, 
    input [ADDRWIDTH-1:0] addra,addrb, 
    input [WORDSIZE_IN-1:0] dia,dib,
    output logic [WORDSIZE_OUT-1:0] doa,dob
);


`ifdef VIVADO_BROKEN
// xpm_memory_tdpram: True Dual Port RAM
// Xilinx Parameterized Macro, version 2023.1

xpm_memory_tdpram #(
   .ADDR_WIDTH_A(6),               // DECIMAL
   .ADDR_WIDTH_B(6),               // 
   .MEMORY_OPTIMIZATION("true"),   // String
   .MEMORY_PRIMITIVE("auto"),      // String
   .MEMORY_INIT_PARAM("BA"),
   .MEMORY_SIZE(2048),             // DECIMAL
   .MESSAGE_CONTROL(1),            // DECIMAL
   .READ_DATA_WIDTH_A(32),         // DECIMAL
   .READ_DATA_WIDTH_B(32),         // DECIMAL
   .READ_LATENCY_A(2),             // DECIMAL
   .READ_LATENCY_B(2),             // DECIMAL
   .SIM_ASSERT_CHK(1),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
   .WRITE_DATA_WIDTH_A(32),        // DECIMAL
   .WRITE_DATA_WIDTH_B(32)        // DECIMAL
)
xpm_memory_tdpram_inst (
   .douta(douta),                   // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
   .doutb(doutb),                   // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.

   .addra(addra),                   // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
   .addrb(addrb),                   // ADDR_WIDTH_B-bit input: Address for port B write and read operations.
   .clka(clka),                     // 1-bit input: Clock signal for port A. Also clocks port B when
                                    // parameter CLOCKING_MODE is "common_clock".

   .dina(dina),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
   .dinb(dinb),                     // WRITE_DATA_WIDTH_B-bit input: Data input for port B write operations.
   .ena(ena),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
                                    // cycles when read or write operations are initiated. Pipelined
                                    // internally.

   .enb(enb),                       // 1-bit input: Memory enable signal for port B. Must be high on clock
                                    // cycles when read or write operations are initiated. Pipelined
                                    // internally.
   .regcea(regcea),                 // 1-bit input: Clock Enable for the last register stage on the output
                                    // data path.

   .regceb(regceb),                 // 1-bit input: Clock Enable for the last register stage on the output
                                    // data path.

   .wea(wea),                       // WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector
                                    // for port A input data port dina. 1 bit wide when word-wide writes are
                                    // used. In byte-wide write configurations, each bit controls the
                                    // writing one byte of dina to address addra. For example, to
                                    // synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A
                                    // is 32, wea would be 4'b0010.

   .web(web)                        // WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B-bit input: Write enable vector
                                    // for port B input data port dinb. 1 bit wide when word-wide writes are
                                    // used. In byte-wide write configurations, each bit controls the
                                    // writing one byte of dinb to address addrb. For example, to
                                    // synchronously write only bits [15-8] of dinb when WRITE_DATA_WIDTH_B
                                    // is 32, web would be 4'b0010.

);

// End of xpm_memory_tdpram_inst instantiation

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
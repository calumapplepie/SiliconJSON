// Dual-Port Block RAM with Two Write Ports
// File: rams_tdp_rf_rf.v

module TapeBlockRam #(WORDSIZE=8, NUMWORDS=64, ADDRWIDTH=$clog2(NUMWORDS)) (
    input logic clk, ena, enb, wea,web, 
    input [ADDRWIDTH-1:0] addra,addrb, 
    input [WORDSIZE-1:0] dia,dib,
    output logic [WORDSIZE-1:0] doa,dob
);

logic [WORDSIZE-1:0] ram [0:NUMWORDS-1];

// canary-ify ram on initialization
// however, we assume the RAM is initialized to 0 in other code, so zero it in some places 
initial begin 
    foreach(ram[i]) ram[i] = {WORDSIZE/8{8'hBA}};
    ram[NUMWORDS-1] = '0;
    ram[0]       = '0; 
end

// docs say accesses ports can have different bitwidths.  todo: determine if they also support 
// unaligned access.
// would make block processing easier (read JSON into block ram -> process blocks -> send sub-blocks through
// purpose-built FPGA circuits)

always_ff @(posedge clk) begin
    if (ena) begin
        if (wea) ram[addra] <= dia;
        doa <= ram[addra];
    end
end

always_ff @(posedge clk) begin
    if (enb) begin
        if (web) ram[addrb] <= dib;
        dob <= ram[addrb];
    end
end

endmodule
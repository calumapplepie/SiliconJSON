// Dual-Port Block RAM with Two Write Ports
// File: rams_tdp_rf_rf.v

module TapeBlockRam #(
            WORDSIZE=8, WORDSIZE_IN=WORDSIZE, WORDSIZE_OUT=WORDSIZE, // default to symetric, but allow asymetric reading  
            NUMWORDS=64, ADDRWIDTH=$clog2(NUMWORDS)) (
    input logic clk, ena, enb, wea,web, 
    input [ADDRWIDTH-1:0] addra,addrb, 
    input [WORDSIZE_IN-1:0] dia,dib,
    output logic [WORDSIZE_OUT-1:0] doa,dob
);

// maybe in is big, maybe out is big; user chooses
localparam WORDSIZE_RAM = WORDSIZE_IN > WORDSIZE_OUT ? WORDSIZE_OUT : WORDSIZE_IN;
logic [WORDSIZE_RAM-1:0] ram [0:NUMWORDS-1];



// canary-ify ram on initialization
// however, we assume the RAM is initialized to 0 in stack, so zero it in some places 
initial begin 
    foreach(ram[i]) ram[i] = {WORDSIZE_RAM/8{8'hBA}};
    ram[NUMWORDS-1] = '0;
    ram[0]       = '0; 
end

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
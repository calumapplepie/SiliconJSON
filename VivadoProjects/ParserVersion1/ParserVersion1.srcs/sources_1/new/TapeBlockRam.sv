// Dual-Port Block RAM with Two Write Ports
// File: rams_tdp_rf_rf.v

module TapeBlockRam #(WORDSIZE=8, NUMWORDS=64) (
    input logic clk, ena, enb, wea,web, 
    input [9:0] addra,addrb, 
    input [WORDSIZE-1:0] dia,dib,
    output logic [WORDSIZE-1:0] doa,dob
);

(* dont_touch = "true" *) logic [WORDSIZE-1:0] ram [NUMWORDS-1:0];

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
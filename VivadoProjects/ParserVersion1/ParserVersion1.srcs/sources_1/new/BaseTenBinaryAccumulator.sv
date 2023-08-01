`timescale 1ns / 1ps
module BaseTenBinaryAccumulator(
        input [3:0] nextIn, 
        input clk, rst, enb,
        output logic [63:0] numberOut
        );
        
        logic [63:0] prevNumberOut;
        
        always_ff @(posedge clk)begin
            if(rst) begin
                prevNumberOut <= '0;
                numberOut     <= '0;
            end 
            if(enb) begin
                numberOut <= numberOut * 4'd10 + nextIn;
            end
        end
endmodule

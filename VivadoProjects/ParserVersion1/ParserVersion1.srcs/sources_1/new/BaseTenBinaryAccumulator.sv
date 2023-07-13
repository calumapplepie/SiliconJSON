`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2023 03:48:53 PM
// Design Name: 
// Module Name: BaseTenBinaryAccumulator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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

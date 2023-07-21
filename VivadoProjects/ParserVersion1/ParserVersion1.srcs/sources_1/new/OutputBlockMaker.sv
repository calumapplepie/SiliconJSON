`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2023 05:55:42 PM
// Design Name: 
// Module Name: OutputBlockMaker
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


module OutputBlockMaker(
        input clk, enable, rst, [7:0] curByte,
        output logic [31:0] byteBlock
    );
    logic [1:0] curBlock;
    
    always_ff @(posedge clk) byteBlock[(curBlock+1)*8-1 -: 8] <= curByte;
        
    always_ff @(posedge clk) begin  
        if(rst) curBlock <= '0;
        else if(enable) begin
            curBlock <= curBlock +1;
        end
        
    end;
    
endmodule

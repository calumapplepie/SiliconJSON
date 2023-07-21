`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2023 02:50:24 PM
// Design Name: 
// Module Name: InputBlockBreaker
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

// breaks a block of 4 characters into 4 cycles of 1 character blocks
module InputBlockBreaker(
        input logic [7:0] curCharBlock [3:0], logic clk, rst, enableIn,
        output logic enableOut, logic[7:0] curChar
    );
    logic [1:0] curBlock;
    logic lastEnableIn;
    
    always_ff @(posedge clk) curChar <= curCharBlock[curBlock];
    always_ff @(posedge clk) lastEnableIn <= enableIn;
    
    always_ff @(posedge clk) begin  
        enableOut <= '0; // default to disabled
        if(rst) curBlock <= '1;
        if(curBlock == 0 && lastEnableIn) begin end // do nothing if we've already read the block
        else if(enableIn) begin
            curBlock <= curBlock +1;
            enableOut <= '1;
        end
        
    end
       
endmodule

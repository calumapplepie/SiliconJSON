`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2023 09:09:24 PM
// Design Name: 
// Module Name: LengthOrchestrator
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


module LengthOrchestrator import Block::InputIndex;(
        input logic clk, web,
        input logic [3:0] selR1, selR2, selW,
        input InputIndex din,
        output InputIndex dout1, dout2
    );
    
    // this is basically a RAM, but it's tiny
    // lets hope it gets implemented as a DRAM
    
    InputIndex mem [15:0];
    
    always_ff @(posedge clk) begin
        if(web) mem[selW] <= din;
    end
    
    assign dout1 = mem[selR1];
    assign dout2 = mem[selR2];
    
endmodule

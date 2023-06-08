`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2023 05:16:29 PM
// Design Name: 
// Module Name: StringTapeAccumulator
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


module StringTapeAccumulator(
    input UTF8_Char nextStringByte,
    output [0:55] curIndex,
    output [0:31] strLen,
    input clk, rst, enable
    );
    reg [0:55] curIndex;
    // could store just string length instead, but flip-flops are cheap
    reg [0:55] startIndex;
    logic wasEnabled;

    



endmodule

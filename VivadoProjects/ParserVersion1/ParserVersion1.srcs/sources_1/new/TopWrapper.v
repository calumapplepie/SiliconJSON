`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2023 01:54:15 PM
// Design Name: 
// Module Name: TopWrapper
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


module TopWrapper (
    input wire [7:0] curChar,
    input GCLK, rst, enable, readSide,
    output wire [63:0] curStructBits,
    output wire [7:0]  curStringBits
);
    TopLevel topLevel (curChar, GCLK, rst, enable, readSide, curStructBits, curStringBits);
endmodule

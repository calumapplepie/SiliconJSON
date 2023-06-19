`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2023 03:58:15 PM
// Design Name: 
// Module Name: NumberBuilder
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


module NumberBuilder(
        input [63:0] numberSegments [2:0],
        input [4:0] numDigits [2:0],
        input numSign, expSign,
        output [63:0] tapeEntry
    );
endmodule

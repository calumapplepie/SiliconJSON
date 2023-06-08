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
    output TapeIndex curIndex,
    input clk, rst, enable
    );
    typedef logic [0:31] StringLength;
    StringLength strLen,
    // could store just string length instead, but flip-flops are cheap
    TapeIndex startIndex;
    logic wasEnabled;

    



endmodule

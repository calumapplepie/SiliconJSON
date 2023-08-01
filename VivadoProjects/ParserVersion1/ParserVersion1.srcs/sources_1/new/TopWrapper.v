`timescale 1ns / 1ps

module TopWrapper (
    input wire [7:0] curChar,
    input GCLK, rst, enable, readSide, parseEnable,
    output wire [63:0] curStructBits,
    output wire [31:0]  curStringBits
);    
    TopLevel topLevel (curChar, GCLK, rst, enable, readSide, parseEnable, curStructBits, curStringBits);
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2023 02:30:22 PM
// Design Name: 
// Module Name: TapeInstance
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

module TapeInstance import Ram::*; ( 
        input clk, enb, 
        input  StringBlockRamWrite stringRamW, StructBlockRamWrite structRamW,
        output StringBlockRamRead  stringRamR, StructBlockRamRead  structRamR 
    );
    
    wire [63:0] lookAtMe = structRamW.dia;

    
    BlockRamSharerString  
    stringTapeRam (
        .clk, .enb, .ramW(stringRamW), .ramR(stringRamR)
    );
    BlockRamSharerStruct 
    structTapeRam (
        .clk, .enb, .ramW(structRamW), .ramR(structRamR)
    );
    
endmodule


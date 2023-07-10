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

module TapeStorage import Ram::*; ( 
        input clk, enb, 
        input  StringBlockRamWrite stringRamW, StructBlockRamWrite structRamW,
        output StringBlockRamRead  stringRamR, StructBlockRamRead  structRamR 
    );
    
    BlockRamSharer #(.NUMWORDS(Core::StringTapeLength), .WORDSIZE(8))  stringTapeRam (
        .clk, .r(stringRam)
    );
    BlockRamSharer #(.NUMWORDS(Core::StructTapeLength), .WORDSIZE(64)) structTapeRam (
        .clk, .r(structRam)
    );
    
endmodule

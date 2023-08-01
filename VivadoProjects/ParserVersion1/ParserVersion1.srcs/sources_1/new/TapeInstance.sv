`timescale 1ns / 1ps
module TapeInstance import Ram::*; ( 
        input clk, enb, 
        input  StringBlockRamWrite stringRamW, StructBlockRamWrite structRamW,
        output StringBlockRamRead  stringRamR, StructBlockRamRead  structRamR 
    );
    
    
    BlockRamSharer #(.NUMWORDS(Core::StringTapeLength), .WORDSIZE(8), .ReadType(StringBlockRamRead), .WriteType(StringBlockRamWrite)) 
    stringTapeRam (
        .clk, .enb, .ramW(stringRamW), .ramR(stringRamR)
    );
    
    BlockRamSharer #(.NUMWORDS(Core::StructTapeLength), .WORDSIZE(64), .ReadType(StructBlockRamRead), .WriteType(StructBlockRamWrite)) 
    structTapeRam (
        .clk, .enb, .ramW(structRamW), .ramR(structRamR)
    );
    
endmodule


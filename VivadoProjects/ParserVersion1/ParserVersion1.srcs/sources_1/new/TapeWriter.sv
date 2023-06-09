`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2023 05:04:27 PM
// Design Name: 
// Module Name: TapeWriter
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


module TapeWriter(
        input UTF8_Char curChar,
        input JsonElementType curElementType,
        input writingString, writeStructure,
        input clk, rst,
        output logic [7:0] stringTape [32],
        output JsonTapeElement structureTape [32]
    );
    
    
    StringTapeAccumulator stringGoHere (
        .nextStringByte(curChar), .enable(writingString),
        .curIndex(curStringIndex),
        .clk(clk), .rst(rst)
    );
    
    JsonTapeElement nextElement;
    TapeIndex curStringIndex;

    // root handling currently elsewhere
    StructureTapeMaker elementBuilder (
        .elementType(curElementType), .nextElement(nextElement), .curStringIndex(curStringIndex),
        // not currently sequencial, may never be... we'll see
        .clk(clk), .rst(rst)
    );

    StructureTapeAccumulator structGoHere(
        .nextTapeEntry(nextElement), .enable(writeStructure),
        .clk(clk), .rst(rst)
    );
endmodule
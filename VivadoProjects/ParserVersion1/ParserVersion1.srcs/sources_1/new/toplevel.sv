`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2023 04:22:05 PM
// Design Name: 
// Module Name: toplevel
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


module toplevel(
    input UTF8_Char curChar,
    input clk, rst
    );
    JsonElementType curElementType;
    logic writingString, writeStructure;


    // our modules!
    
    ParserFSM parser (
        .curChar (curChar), .curElementType(curElementType),
        .writingString(writingString), .writeStructure(writeStructure)
        .clk(clk), .rst(rst)
    );
    
    // ideal spot for a pipeline stage right here
    // but that will add complexity that we don't really want right now
    // maybe toss all this stuff in its own module?  that would make a lot of sense....
    TapeIndex curStringIndex;

    StringTapeAccumulator stringGoHere (
        .nextStringByte(curChar), .enable(writingString),
        .curIndex(curStringIndex),
        .clk(clk), .rst(rst)
    );
    
    JsonTapeElement nextElement;

    // root handling currently elsewhere
    StructureTapeMaker elementBuilder (
        .elementType(curElementType), .nextElement(nextElement)
        // not currently sequencial, may never be... we'll see
        .clk(clk), .rst(rst)
    );

    StructureTapeAccumulator(
        .nextTapeEntry(nextElement), .enable(writeStructure),
        .clk(clk), .rst(rst)
    );

    
endmodule

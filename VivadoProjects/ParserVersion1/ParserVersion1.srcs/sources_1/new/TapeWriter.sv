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


module TapeWriter
    import Core::UTF8_Char, Core::ElementType, Core::TapeIndex, Core::JsonTapeElement;
    (
        input UTF8_Char curChar,
        input ElementType curElementType,
        input writingString, writeStructure,
        input logic [23:0] keyValuePairs,
        input JsonTapeElement numberSecondElement,
        input clk, rst,
        output hash
    );
    wire hashStr, hashStruct;
    
    TapeIndex curStringIndex;
    assign hash = hashStr ^ hashStruct;
    
    StringTapeAccumulator stringGoHere (
        .nextStringByte(curChar), .enable(writingString),
        .startIndex(curStringIndex),
        .clk(clk), .rst(rst), .hash(hashStr)
    );
    
    JsonTapeElement nextElement;
   
    // root handling currently elsewhere
    StructureTapeMaker elementBuilder (
        .elementType(curElementType), .nextElement(nextElement), .stringTapeIndex(curStringIndex)
    );

    StructureTapeAccumulator structGoHere(
        .nextTapeEntry(nextElement), .enable(writeStructure), 
        .keyValuePairs(keyValuePairs), .numberSecondElement,
        .clk(clk), .rst(rst), .hash(hashStruct)
    );
endmodule

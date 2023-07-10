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
        input writeString, writeStructure, characterEscaped,
        input logic [23:0] keyValuePairs,
        input JsonTapeElement numberSecondElement,
        input clk, rst, enable,
        output Ram::StringBlockRamWrite stringRam, 
        output Ram::StructBlockRamWrite structRam
    );
    wire hashStr, hashStruct;
    
    TapeIndex curStringIndex;
    UTF8_Char nextStringByte;
    assign hash = hashStr ^ hashStruct;
    
    assign nextStringByte = characterEscaped ? Core::unescapeCharacter(curChar) : curChar;

    StringTapeAccumulator stringGoHere (
        .nextStringByte, .enable, .active(writeString),
        .startIndex(curStringIndex), .characterEscaped,
        .clk(clk), .rst(rst), .hash(hashStr), .ramConnection(stringRam)
    );
    
    JsonTapeElement nextElement;
   
    // root handling currently elsewhere
    StructureTapeMaker elementBuilder (
        .elementType(curElementType), .nextElement(nextElement), .stringTapeIndex(curStringIndex)
    );

    StructureTapeAccumulator structGoHere(
        .nextTapeEntry(nextElement), .enable,  .active(writeStructure), 
        .keyValuePairs(keyValuePairs), .numberSecondElement,
        .clk(clk), .rst(rst), .hash(hashStruct), .ramConnection(structRam)
    );
endmodule

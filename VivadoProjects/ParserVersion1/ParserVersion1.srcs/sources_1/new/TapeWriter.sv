`timescale 1ns / 1ps

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
        output Ram::StructBlockRamWrite structRam,
        output Core::TapeIndex strTapeLen, layTapeLen
    );
    
    TapeIndex curStringIndex;
    UTF8_Char nextStringByte;
    
    assign nextStringByte = characterEscaped ? Core::unescapeCharacter(curChar) : curChar;

    StringTapeAccumulator stringGoHere (
        .nextStringByte, .enable, .active(writeString),
        .startIndex(curStringIndex), .characterEscaped,
        .clk(clk), .rst(rst), .ramConnection(stringRam),
        .length(strTapeLen)
    );
    
    JsonTapeElement nextElement;
   
    // root handling currently elsewhere
    StructureTapeMaker elementBuilder (
        .elementType(curElementType), .nextElement(nextElement), .stringTapeIndex(curStringIndex)
    );

    StructureTapeAccumulator structGoHere(
        .nextTapeEntry(nextElement), .enable,  .active(writeStructure), 
        .keyValuePairs(keyValuePairs), .numberSecondElement,
        .clk(clk), .rst(rst), .ramConnection(structRam), .length(layTapeLen)
    );
endmodule

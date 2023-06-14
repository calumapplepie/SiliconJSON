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
        input clk, rst,
        output logic [7:0] stringTape [Core::StringTapeLength],
        output Core::JsonTapeElement structTape [Core::StructTapeLength]
    );
    
    TapeIndex curStringIndex;
    
    StringTapeAccumulator stringGoHere (
        .nextStringByte(curChar), .enable(writingString),
        .startIndex(curStringIndex), .tape(stringTape),
        .clk(clk), .rst(rst)
    );
    
    JsonTapeElement nextElement;
   
    // root handling currently elsewhere
    StructureTapeMaker elementBuilder (
        .elementType(curElementType), .nextElement(nextElement), .stringTapeIndex(curStringIndex)
    );

    StructureTapeAccumulator structGoHere(
        .nextTapeEntry(nextElement), .enable(writeStructure), .tape(structTape),
        .keyValuePairs(keyValuePairs),
        .clk(clk), .rst(rst)
    );
endmodule

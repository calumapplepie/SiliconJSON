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
        input Core::UTF8_Char curChar,
        input Core::ElementType curElementType,
        input writingString, writeStructure,
        input logic [23:0] keyValuePairs,
        input clk, rst,
        output logic [7:0] stringTape [Core::StringTapeLength],
        output Core::JsonTapeElement structTape [Core::StructTapeLength]
    );
    
    
    StringTapeAccumulator stringGoHere (
        .nextStringByte(curChar), .enable(writingString),
        .startIndex(curStringIndex), .tape(stringTape),
        .clk(clk), .rst(rst)
    );
    
    JsonTapeElement nextElement;
    TapeIndex curStringIndex;

    // root handling currently elsewhere
    StructureTapeMaker elementBuilder (
        .elementType(curElementType), .nextElement(nextElement), .stringTapeIndex(curStringIndex),
        // not currently sequencial, may never be... we'll see
        .clk(clk), .rst(rst)
    );

    StructureTapeAccumulator structGoHere(
        .nextTapeEntry(nextElement), .enable(writeStructure), .tape(structTape),
        .keyValuePairs(keyValuePairs),
        .clk(clk), .rst(rst)
    );
endmodule

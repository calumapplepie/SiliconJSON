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


module TopLevel(
    input UTF8_Char curChar,
    input GCLK, rst, enable,
    output JsonTapeElement structTape[StructTapeLength],
    output logic [7:0] stringTape[StringTapeLength]
    );
    JsonElementType curElementType;
    logic writingString, writeStructure, clk;
    
    assign clk = (enable || rst) ? GCLK : '0;
    
    // our modules!
    
    ParserFSM parser (
        .curChar (curChar), .curElementType(curElementType),
        .writingString(writingString), .writeStructure(writeStructure),
        .clk(clk), .rst(rst)
    );
    
    // ideal spot for a pipeline stage right here
    // but that will add complexity that we don't really want right now
    // maybe toss all this stuff in its own module?  that would make a lot of sense....
    
    
    TapeWriter writer (
        .curChar(curChar), .curElementType(curElementType),
        .writingString(writingString), .writeStructure(writeStructure),
        .stringTape(stringTape), .structTape(structTape),
        .clk(clk),.rst(rst)
    );

    
endmodule

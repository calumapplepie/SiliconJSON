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


module ParserTop
    import Core::UTF8_Char, Core::StructTapeLength, Core::StringTapeLength, Core::JsonTapeElement, Core::ElementType;
    (
        input UTF8_Char curChar,
        input clk, rst, enable,
        output Ram::StringBlockRamWrite stringRam, 
        output Ram::StructBlockRamWrite structRam
    );
    ElementType curElementType;
    JsonTapeElement numberSecondElement;
    wire writeString, writeStructure, characterEscaped;
    wire [23:0] keyValuePairs;
    
    
    // our modules!
    
    ParserFSM parser (
        .curChar (curChar), .curElementType(curElementType), .keyValuePairsSoFar(keyValuePairs),
        .writeString, .writeStructure, .numberSecondElement, .characterEscaped,
        .clk(clk), .rst(rst), .enb(enable)
    );
    
    // this needs to be a pipeline for proper functionality
    // FSM's current state describes what should be done with previous character
    UTF8_Char lastChar;
    logic lastCharacterEscaped;
    ElementType lastElementType;
    JsonTapeElement lastSecondElement;
    always_ff @(posedge clk ) begin
        if(rst) begin
            lastChar             <= "{";
            lastCharacterEscaped <= '0;
            lastElementType      <= Core::objOpen;
            lastSecondElement    <= '0;
        end
        else if(enable) begin
            lastChar             <= curChar;
            lastCharacterEscaped <= characterEscaped;
            lastElementType      <= curElementType;
            lastSecondElement    <= numberSecondElement;
        end 
    end
    
    TapeWriter writer (
        .curChar(lastChar), .curElementType(lastElementType),
        .writeString(writeString), .writeStructure(writeStructure), 
        .keyValuePairs(keyValuePairs), .numberSecondElement(lastSecondElement),
        .clk(clk),.rst(rst), .characterEscaped(lastCharacterEscaped),
        .stringRam, .structRam, .enable
    );
    
    wire [63:0] lookAtMe = structRam.dia; 
endmodule

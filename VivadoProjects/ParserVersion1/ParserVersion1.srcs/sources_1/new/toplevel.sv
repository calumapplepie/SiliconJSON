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


(* keep_hierarchy = "yes" *) module TopLevel
    import Core::UTF8_Char, Core::StructTapeLength, Core::StringTapeLength, Core::JsonTapeElement, Core::ElementType;
    (
    input UTF8_Char curChar,
    input GCLK, rst, enable,
    output logic LD0, LD1
    );
    ElementType curElementType;
    JsonTapeElement numberSecondElement;
    wire writeString, writeStructure, clk, characterEscaped;
    wire [23:0] keyValuePairs;
    
    assign clk = GCLK;
    
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
        .clk(clk),.rst(rst), .hash(LD0), .characterEscaped(lastCharacterEscaped)
    );
endmodule

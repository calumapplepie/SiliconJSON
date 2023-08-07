`timescale 1ns / 1ps



module ParserTop
    import Core::UTF8_Char, Core::StructTapeLength, Core::StringTapeLength, Core::JsonTapeElement, Core::ElementType;
    (
        input UTF8_Char curChar,
        input clk, rst, enable,
        output Ram::StringBlockRamWrite stringRam, 
        output Ram::StructBlockRamWrite structRam,
        output Core::InputIndex strTapeLen, layTapeLen
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
    always_ff @(posedge clk ) begin
        if(rst) begin
            lastChar             <= "{";
            lastCharacterEscaped <= '0;
            lastElementType      <= Core::objOpen;
        end
        else if(enable) begin
            lastChar             <= curChar;
            lastCharacterEscaped <= characterEscaped;
            lastElementType      <= curElementType;
        end 
    end
    
    TapeWriter writer (
        .curChar(lastChar), .curElementType(lastElementType),
        .writeString(writeString), .writeStructure(writeStructure), 
        .keyValuePairs(keyValuePairs), .numberSecondElement(numberSecondElement),
        .clk(clk),.rst(rst), .characterEscaped(lastCharacterEscaped),
        .stringRam, .structRam, .enable, .strTapeLen, .layTapeLen
    );
    
endmodule

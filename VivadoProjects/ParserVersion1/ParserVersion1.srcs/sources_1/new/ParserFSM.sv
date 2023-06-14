`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2023 04:22:05 PM
// Design Name: 
// Module Name: ParserFSM
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


module ParserFSM import Core::*; (
    input Core::UTF8_Char curChar,
    input clk, rst,
    output Core::ElementType curElementType,
    output logic writingString, writeStructure,
    output logic [23:0] keyValuePairsSoFar
    );

    typedef enum logic[3:0] {
        StartObject, // the first, starting state: we just found the document root, or some other object
        FindKey,     // waiting for the first quote of a key
        StartKey,    // Found the key's start
        ReadKey,     // Read the key
        FindValue,   // Find the value
        StartString, // Found the first quote of a string
        ReadString,  // Read the string
        EndObject,   // finish off the object we just found
        Error} state_t;
    state_t curState;
    state_t nextState;

    
    CharType curCharType;

    assign curCharType = classifyChar(curChar);
    
    always @(posedge clk ) begin
        if(rst) curState <= StartObject;
        else curState <= nextState;
        
        // we assume nobody goes over 2^24 key value pairs with our parser
        // that saves us saturating logic
        if (curState == StartKey) keyValuePairsSoFar <= keyValuePairsSoFar+1;
    end

    // next state determiner
    always_comb begin
        logic isQuote = curCharType == quote;
        case(curState)    
            StartObject : nextState = FindKey;
            FindKey     : case(curCharType)
                quote     : nextState = StartKey;
                braceClose: nextState = EndObject;
                default   : nextState = FindKey;
            endcase
            StartKey    : nextState = ReadKey; //NOTE: Breaks on empty key
            ReadKey     : nextState = isQuote ? FindValue : ReadKey; // todo: escaped quotes
            FindValue   : nextState = isQuote ? StartString : FindValue; // todo: check for colon
            StartString : nextState = ReadString; // NOTE: breaks on empty value
            ReadString  : nextState = isQuote ? FindKey: ReadString;
            default     : nextState = Error;
        endcase
    end


    // our outputs
    always_comb begin
        writingString  = 1'b0;
        writeStructure = 1'b0;
        curElementType = charToElementType(curCharType);
        case(curState)
            StartObject, EndObject  : writeStructure = 1'b1;
            StartKey, StartString   : begin 
                writeStructure = 1'b1;
                curElementType = str; 
            end
            ReadKey, ReadString     : begin
                writingString  = 1'b1;
                curElementType = str;
            end
            default: 
            // some states have no output besides those default ones
            ;
        endcase
    end


endmodule

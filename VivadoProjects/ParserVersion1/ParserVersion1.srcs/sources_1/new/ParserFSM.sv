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
        ReadSimple,  // read one of the simple JSON values
        EndSimple,   // write out read JSON value
        StartString, // Found the first quote of a string
        ReadString,  // Read the string
        EndObject,   // finish off the object we just found
        Error} state_t;
    state_t curState;
    state_t nextState;
    
    logic simpleValScanComplete;
    ElementType simpleValElement;
    SimpleValueFSM simpleValue (.curChar(curChar), .scanComplete(simpleValScanComplete),
                                    .scannedElement(simpleValElement), .enb(curState==ReadSimple),
                                    .clk(clk),.rst(rst));
    
    CharType curCharType;

    assign curCharType = classifyChar(curChar);
    
    
    
    always_ff @(posedge clk ) begin
        if(rst) begin
            curState <= StartObject;
            keyValuePairsSoFar <= '0;
        end
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
            StartKey    : nextState = ReadKey; //NOTE: Breaks on empty key
            StartString : nextState = ReadString; // NOTE: breaks on empty value
            EndSimple   : nextState = FindKey;

            FindKey     : case(curCharType)
                quote     : nextState = StartKey;
                braceClose: nextState = EndObject;
                default   : nextState = FindKey;
            endcase
            FindValue   : case(curCharType) // todo: check for colon
                quote:             nextState = StartString;
                asciiAlphabetical: nextState = ReadSimple; 
                default:           nextState = FindValue;
            endcase


            ReadKey     : nextState = isQuote ? FindValue : ReadKey; // todo: escaped quotes
            ReadString  : nextState = isQuote ? FindKey: ReadString;
            
            ReadSimple  : nextState = simpleValScanComplete ? EndSimple : ReadSimple; 
            
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
            StartKey, StartString   : writeStructure = 1'b1;
            ReadKey, ReadString     : writingString  = 1'b1;
            ReadSimple: curElementType = simpleValElement;
            EndSimple: writeStructure = 1'b1;
            default: 
            // some states have no output besides those default ones
            ;
        endcase
    end


endmodule

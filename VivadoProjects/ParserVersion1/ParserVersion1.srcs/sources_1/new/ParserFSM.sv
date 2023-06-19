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
    input UTF8_Char curChar,
    input clk, rst,
    output ElementType curElementType,
    output logic writingString, writeStructure,
    output logic [23:0] keyValuePairsSoFar,
    output JsonTapeElement numberSecondElement
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
        ReadNumber,  // read the number
        EndNumber,   // end the number
        EndObject,   // finish off the object we just found
        EndDocument, // close the document up
        Error} state_t;
    state_t curState;
    state_t nextState;
    
    // TODO: Sub parsers won't work properly with disabled main parser!!!!
    
    logic simpleValScanComplete;
    ElementType simpleValElement;
    
    SimpleValueFSM simpleValue (.curChar(curChar), .scanComplete(simpleValScanComplete),
                                    .scannedElement(simpleValElement), .enb(curState==ReadSimple),
                                    .clk(clk),.rst(rst));
    
    logic numberParserReset;
    ElementType numberFirstElement; 
    assign numberParserReset = rst || nextState != ReadNumber;
                                       
    NumberParsingFSM numberParser (
        //note: see commit that introduced the enable logic for a long commit-message reflection
        .clk, .rst(numberParserReset), .curChar, .enb(nextState == ReadNumber), 
        .number(numberSecondElement), .numberType(numberFirstElement)
    );
    
    
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

            FindKey, EndSimple, EndNumber : case(curCharType)
                quote     : nextState = StartKey;
                braceClose: nextState = EndObject;
                default   : nextState = FindKey;
            endcase
            FindValue   : case(curCharType) // todo: check for colon
                quote:             nextState = StartString;
                asciiAlphabetical: nextState = ReadSimple; 
                numeric, minusSign:nextState = ReadNumber;
                default:           nextState = FindValue;
            endcase


            ReadKey     : nextState = isQuote ? FindValue : ReadKey; // todo: escaped quotes
            ReadString  : nextState = isQuote ? FindKey: ReadString;
            
            ReadSimple  : nextState = simpleValScanComplete ? EndSimple : ReadSimple; 
            
            ReadNumber  : case(curCharType)
                whitespace, comma, braceClose, bracketClose : nextState = EndNumber;
                default : nextState = ReadNumber;
            endcase 
            
            // no sub-objects supported yet
            EndObject   : nextState = EndDocument;
            
            default     : nextState = Error;
        endcase
    end


    // our outputs
    always_comb begin
        writingString  = 1'b0;
        writeStructure = 1'b0;
        curElementType = charToElementType(curCharType);
        case(curState)
            StartObject  : writeStructure = 1'b1;
            StartKey, StartString   : writeStructure = 1'b1;
            ReadKey, ReadString     : writingString  = 1'b1;
            ReadSimple: curElementType = simpleValElement;
            ReadNumber: curElementType = numberFirstElement;
            EndSimple, EndNumber: writeStructure = 1'b1;
            EndObject, EndDocument: begin
                writeStructure = 1'b1;
                curElementType = objClose;// root handling is automated
            end 
            default: 
            // some states have no output besides those default ones
            ;
        endcase
    end


endmodule

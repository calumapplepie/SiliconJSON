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

module ParserFSM import Core::*, ParserPkg::*; (
    input UTF8_Char curChar,
    input clk, rst, enb,
    output ElementType curElementType,
    output logic writeString, writeStructure, characterEscaped,
    output logic [23:0] keyValuePairsSoFar,
    output JsonTapeElement numberSecondElement
    );

    ParserState curState;
    ParserState nextState;
        
    logic simpleValScanComplete;
    ElementType simpleValElement;
    assign simpleValueRst = rst || curState!=ReadSimple;
    
    SimpleValueFSM simpleValue (.curChar(curChar), .scanComplete(simpleValScanComplete),
                                    .scannedElement(simpleValElement), .enb(curState==ReadSimple&& enb),
                                    .clk(clk),.rst(simpleValueRst));
    
    logic numberParserReset;
    ElementType numberFirstElement; 
    assign numberParserReset = rst || nextState != ReadNumber;
                                       
    NumberParsingFSM numberParser (
        //note: see commit that introduced the enable logic for a long commit-message reflection
        .clk, .rst(numberParserReset), .curChar, .enb(nextState == ReadNumber && enb), 
        .number(numberSecondElement), .numberType(numberFirstElement)
    );
    
    
    CharType curCharType;
    assign curCharType = classifyChar(curChar);
    
    logic inArray, prevArrayStatus;
    
    NestingObjectTracker nestingObjects (
        .clk, .rst, .enb, .curState, .curCharType,
        .inArray, .prevArrayStatus, .keyValuePairsSoFar
    );
    
    // state machine sequencial code
    always_ff @(posedge clk ) begin
        if(rst) begin
            curState <= StartObject;
        end else if (enb) begin
            curState <= nextState;
        end
    end

    // backslash logic
    always_ff @(posedge clk) begin
        if(rst)                    characterEscaped <= '0;
        else if(!enb) ;
        else if (characterEscaped) characterEscaped <= '0;
        else if (curCharType == backslash) characterEscaped <= '1;
    end

    
    // whether we're finding a key or finding a value turns out to be kinda... tough to say.
    // theres several states that need to find keys or values depending on whether we're in
    // an array or not.  Factor out that logic into two functions
    function findKeyNextState ();
        case(curCharType)
                quote     : nextState = StartKey;
                braceClose: nextState = EndObject;
                default   : nextState = FindKey;
            endcase
    endfunction
    
    function findValueNextState();
        case(curCharType) // todo: check for colon
                braceOpen :        nextState = StartObject;
                bracketClose :     nextState = EndArray;
                bracketOpen:       nextState = StartArray;
                quote:             nextState = StartString;
                asciiAlphabetical: nextState = ReadSimple; 
                numeric, minusSign:nextState = ReadNumber;
                default:           nextState = FindValue;
            endcase
    endfunction

    // next state determiner
    always_comb begin
        logic isQuote = curCharType == quote && !characterEscaped;
        case(curState)    
            EndObject, EndArray : begin
                if(prevArrayStatus)    findValueNextState();
                else                   findKeyNextState();
            end             
            
            EndSimple, EndNumber : begin
                if(inArray) findValueNextState();
                else        findKeyNextState();
            end 

            FindKey, StartObject    : findKeyNextState();
            FindValue, StartArray   : findValueNextState();

            StartKey, ReadKey       : nextState = isQuote ? FindValue : ReadKey;    
            StartString,ReadString  : nextState = isQuote ? (inArray ? FindValue : FindKey): ReadString;
            
            ReadSimple  : nextState = simpleValScanComplete ? EndSimple : ReadSimple; 
            
            ReadNumber  : case(curCharType)
                whitespace, comma, braceClose, bracketClose : nextState = (inArray ? FindValue : FindKey);
                default : nextState = ReadNumber;
            endcase 
            
            default     : nextState = Error;
        endcase
    end

    // our outputs
    always_comb begin
        writeString  = 1'b0;
        writeStructure = 1'b0;
        curElementType = charToElementType(curCharType);
        
        case(curState)
            StartObject  : writeStructure = 1'b1;
            StartKey, StartString   : begin
                if(curCharType == quote) writeString = 1'b1;
                writeStructure = 1'b1;
            end
            ReadKey, ReadString     : writeString  = 1'b1;
            ReadSimple              : curElementType = simpleValElement;
            ReadNumber              : begin
                writeStructure = curCharType inside {whitespace, comma, braceClose, bracketClose};
                curElementType = numberFirstElement;
            end
            EndSimple, EndNumber    : writeStructure = 1'b1;
            StartArray, EndArray    : writeStructure = 1'b1;
            EndObject, EndDocument  : begin
                writeStructure = 1'b1;
                curElementType = objClose;// root handling requires this
            end 
            // some numbers are 1 char long; I think this is the best way to handle that
            default: 
            // some states have no output besides those default ones
            ;
        endcase
    end


endmodule

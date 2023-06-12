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


module ParserFSM(
    input UTF8_Char curChar,
    input clk, rst,
    output JsonElementType curElementType,
    output logic writingString, writeStructure
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

    logic [8:0] bracketDepth;
    JsonCharType curCharType;

    CharTypeFinder charReader (
        .curChar (curChar), .charType(curCharType) 
    );
    
    always @(posedge clk ) begin
        if(rst) curState <= StartObject;
        else curState <= nextState;
    end

    // next state determiner
    always_comb begin
        case(curState) 
            StartObject : nextState = FindKey;
            FindKey     : nextState = (curChar == "\"") ? StartKey  : FindKey;
            StartKey    : nextState = ReadKey; //NOTE: Breaks on empty key
            ReadKey     : nextState = (curChar == "\"") ? FindValue : ReadKey; // todo: escaped quotes
            FindValue   : nextState = (curChar == "\"") ? StartString : FindValue; // todo: check for colon
            StartString : nextState = ReadString; // NOTE: breaks on empty value
            ReadString  : nextState = (curChar == "\"") ? FindKey: ReadString;
            default     : nextState = Error;
        endcase
    end


    // our outputs
    always_comb begin
        writingString  = 1'b0;
        writeStructure = 1'b0;
        curElementType = curCharType;
        case(curState)
            StartObject, EndObject  : writeStructure = 1'b1;
            StartKey, StartString   : writeStructure = 1'b1;
            ReadKey, ReadString     : writingString  = 1'b1;
            default: 
            // some states have no output besides those default ones
            ;
        endcase
    end


endmodule

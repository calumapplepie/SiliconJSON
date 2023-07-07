`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2023 03:56:47 PM
// Design Name: 
// Module Name: ParserPkg
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


package ParserPkg;
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
        StartArray,
        EndArray,
        EndObject,   // finish off the object we just found
        EndDocument, // close the document up: not currently used
        Error} ParserState;
endpackage

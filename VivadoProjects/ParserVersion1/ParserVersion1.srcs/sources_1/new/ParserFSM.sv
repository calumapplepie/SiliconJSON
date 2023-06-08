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
    output writingString, writeStructure
    );

    logic lookForValue;
    logic [8:0] bracketDepth;
    JsonCharType curCharType,

    CharTypeFinder charReader (
        .curChar (curChar), .charType(curCharType) 
    );

    always @(posedge clk ) begin
        if(rst){
            writingString = 1'b0;
            writeStructure = 1'b0;
            lookForValue = 1'b0;
            curElementType = root;
        }

    end

endmodule

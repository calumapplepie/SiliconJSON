`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2023 05:16:29 PM
// Design Name: 
// Module Name: StructureTapeMaker
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


module StructureTapeMaker(
        input JsonElementType elementType, input TapeIndex stringTapeIndex,
        input clk, rst,
        output JsonTapeElement nextElement
    );
    // we literally only handle strings right now
    ElementTypeToTapeType transformer (.target(elementType), .out(nextElement[63:56]));
    always_comb begin
        if(elementType == str)begin
            nextElement[56:0] <= stringTapeIndex;
        end
    end
endmodule

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
        // currently unused
        input clk, rst,
        output JsonTapeElement nextElement
    );
    logic [55:0] payload;
    wire [7:0]  prefix;
    
    assign nextElement = {prefix, payload};
    
    // we literally only handle strings right now
    ElementTypeToTapeType transformer (.target(elementType), .out(prefix));
    always_comb begin
        case (elementType)
            str :    payload <= stringTapeIndex;
            root:    payload <= '0;
            default: payload <= 56'hBADBADBADBADD;
        endcase
    end
endmodule

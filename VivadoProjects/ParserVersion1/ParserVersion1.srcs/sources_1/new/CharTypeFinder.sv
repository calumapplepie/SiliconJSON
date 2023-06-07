`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2023 04:22:05 PM
// Design Name: 
// Module Name: CharTypeFinder
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

module CharTypeFinder(
    input logic [0:7] curChar,
    output JsonElementType charType
    );
    always_comb begin
        case (char)
            "{" : charType <= objOpen;
            "}" : charType <= objClose;
            default: charType <= noType;
        endcase
    end
endmodule

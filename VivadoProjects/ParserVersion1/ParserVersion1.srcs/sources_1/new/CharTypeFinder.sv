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
    input UTF8_Char curChar,
    output JsonElementType charType
    );
    always_comb begin
        case (curChar)
            "{" : charType <= objOpen;
            "}" : charType <= objClose;
            "[" : charType <= arrayOpen;
            "]" : charType <= arrayClose;
            "\"": charType <= str;
            default: charType <= noType;
        endcase
    end
endmodule

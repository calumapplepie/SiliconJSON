`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2023 03:58:15 PM
// Design Name: 
// Module Name: NumberBuilder
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


module NumberBuilder(
        input [63:0] numberSegments [2:0],
        input [4:0] numDigits [2:0],
        input numSign, exponentSign, isFloat,
        output logic [63:0] tapeEntry
    );
    
    wire [63:0] intPart     = numberSegments[0];
    wire [63:0] decimalPart = numberSegments[1];
    wire [63:0] powerPart   = numberSegments[2];
    
    always_comb begin
        tapeEntry = intPart;
        if(!numSign) begin
            tapeEntry = ~tapeEntry + 1;
        end
        
        //floats are scary
    end
    
endmodule

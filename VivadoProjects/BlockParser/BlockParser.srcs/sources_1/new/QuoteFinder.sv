`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2023 01:21:33 PM
// Design Name: 
// Module Name: QuoteFinder
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


module QuoteFinder import Block::*; (
        input TextBlock chars, output BitBlock quotes, backslashes
    );
    // TODO: combine this module in with other input-scanning bitmap-building modules
    // Can optimize that module to *hopefully* have a minumum of LUTs per byte
    always_comb begin
        for(int i = 0; i < BlockSizeChars; i++) begin
            quotes[i]      = chars[i] == "\"";
            backslashes[i] = chars[i] == "\\";
        end
    end
    
endmodule

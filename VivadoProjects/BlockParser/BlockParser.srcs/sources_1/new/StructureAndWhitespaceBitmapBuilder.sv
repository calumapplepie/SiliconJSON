`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2023 05:28:19 PM
// Design Name: 
// Module Name: StructureAndWhitespaceBitmapBuilder
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


module StructureAndWhitespaceBitmapBuilder import Block::*; (
        input TextBlock chars, output BitBlock structureChars, whitespace
    );
    // TODO: combine this module in with other input-scanning bitmap-building modules
    // Can optimize that module to *hopefully* have a minumum of LUTs per byte
    always_comb begin
        for(int i = 0; i < BlockSizeChars; i++) begin
            structureChars[i] = chars[i] inside {",",":","{","}","[","]"};
            whitespace[i]     = chars[i] inside {8'h9, 8'ha, 8'hd, 8'h20};
        end
    end
    
endmodule

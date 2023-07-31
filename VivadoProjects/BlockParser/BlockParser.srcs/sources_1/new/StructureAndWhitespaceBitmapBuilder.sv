`timescale 1ns / 1ps

module StructureAndWhitespaceBitmapBuilder import Block::*; (
        input TextBlock chars, output BitBlock layoutChars, whitespace
    );
    // TODO: combine this module in with other input-scanning bitmap-building modules
    // Can optimize that module to *hopefully* have a minumum of LUTs per byte
    always_comb begin
        for(int i = 0; i < BlockSizeChars; i++) begin
            layoutChars[i] = chars[i] inside {",",":","{","}","[","]"};
            whitespace[i]     = chars[i] inside {8'h9, 8'ha, 8'hd, 8'h20};
        end
    end
    
endmodule

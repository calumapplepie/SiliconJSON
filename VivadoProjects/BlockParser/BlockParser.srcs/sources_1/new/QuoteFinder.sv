`timescale 1ns / 1ps

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

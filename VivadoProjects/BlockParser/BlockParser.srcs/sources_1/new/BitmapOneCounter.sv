`timescale 1ns / 1ps

module BitmapOneCounter import Block::*; (input BitBlock in, output BitBlockIndex numOnes  );
    always_comb begin
        numOnes = '0;
        for(int i = 0; i < BlockSizeChars; i++) begin
            numOnes += in[i];
        end
    end
    
endmodule

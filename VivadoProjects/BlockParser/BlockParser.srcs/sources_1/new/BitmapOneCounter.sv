`timescale 1ns / 1ps

module BitmapOneCounter    import Block::*; #(InputWidth=BlockSizeChars)
        (logic [InputWidth-1:0] in, output logic[$clog2(InputWidth):0] numOnes  );

    // how many ones are in a bitmap?
    always_comb begin
        numOnes = '0;
        for(int i = 0; i < InputWidth; i++) begin
            numOnes += in[i];
        end
    end
    
endmodule

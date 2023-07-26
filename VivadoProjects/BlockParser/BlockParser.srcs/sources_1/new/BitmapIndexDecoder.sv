`timescale 1ns / 1ps

module BitmapIndexDecoder import Block::*; (input BitBlock in, output BitBlockIndex [3:0] dexes);

    always_comb begin
        foreach(dexes[i]) dexes[i] = '1;
        for(int i = 0; i < BlockSizeChars; i++) begin
            if(in[i]) begin // we have a one! announce to the world that this is an in to dex!
                for(int j = 0; j < 4; j++) begin
                    if(dexes[j] == '1) begin
                        dexes[j] = i;
                        break;
                    end
                end
                
            end
        end
    end
    
endmodule
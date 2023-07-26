`timescale 1ns / 1ps

module BitmapIndexDecoder import Block::*; (input BitBlock in, output BitBlockIndex [3:0] dexes, output logic [3:0] valids);

    always_comb begin
        foreach(dexes[i]) dexes[i] = 'x;    // we don't care about the invalid dexes, vivado
        foreach(valids[i]) valids[i] = '0;  // have a dedicated list of valid indexes
        for(int i = 0; i < BlockSizeChars; i++) begin
            if(in[i]) begin // we have a one! announce to the world that this is an in to dex!
                for(int j = 0; j < 4; j++) begin
                    if(valids[j] == '0) begin
                        valids[j] = '1;
                        dexes [j] = i;
                        break;
                    end
                end
                
            end
        end
    end
    
endmodule
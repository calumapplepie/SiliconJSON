`timescale 1ns / 1ps

module BitmapIndexDecoder import Block::*; (input BitBlock in, output BitBlockIndex [3:0] dexes, output logic [3:0] valids);

    always_comb begin
        //init vals
        foreach(dexes[i]) dexes[i] = 'x;    // we don't care about the invalid dexes, vivado
        foreach(valids[i]) valids[i] = 1'd0;  // have a dedicated bitmap of valid indexes

        for(int i = 0; i < BlockSizeChars; i++) begin
            if(in[i]) begin // we have a one! announce to the world that this is an in to dex!
                for(int j = 0; j < 4; j++) begin 
                    if(valids[j] == '0) begin // find the first empty slot in out list of indexes
                        valids[j] = 1'd1;
                        dexes [j] = i;
                        break;
                    end
                end
                
            end
        end
    end
    
endmodule
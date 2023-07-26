`timescale 1ns / 1ps

module BitmapToIndicies import Block::*; (
        input BitBlock bitmap, input InputIndex startingIndex, 
        input clk, rst, enb, 
        output logic holdPipeline, output InputIndex[3:0] oneIndexes, output logic[3:0] valids );
        
        BitBlockIndex [3:0] dexes;
        
        BitBlockIndex offset;
        BitBlock bitmap_cur;
        logic [$clog2(BlockSizeChars):0] numOnes; // must be extra wide to avoid Problems in all-bits-are-one case
        
        assign holdPipeline = numOnes > 4;
        
        always_ff @(posedge clk) begin // handle re-running in case of pipeline stall
            if(rst) begin
                offset <= '0;
                bitmap_cur <= '0;            
            end
            else if (enb) begin
                if(!holdPipeline) begin
                    bitmap_cur <= bitmap;
                    offset     <= '0;
                end else begin
                    bitmap_cur <= bitmap_cur >> dexes[3]; // TODO: determine if shift-and-offset is more efficent than masking logic... boy thats a silly question isn't it
                    offset <= dexes[3] + offset; 
                end
            end
        end
        
        BitmapIndexDecoder DECODEY (.in(bitmap_cur), .dexes, .valids);
        BitmapOneCounter   ONESEY  (.in(bitmap_cur), .numOnes);
        
        // transform bitmap indexes to block indexes
        always_comb begin
            for(int i = 0; i < 4; i++) begin
                oneIndexes[i] = dexes[i] + startingIndex + offset;
            end
        end
        
endmodule

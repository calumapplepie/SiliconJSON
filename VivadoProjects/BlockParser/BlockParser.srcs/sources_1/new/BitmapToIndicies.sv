`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2023 02:33:05 PM
// Design Name: 
// Module Name: BitmapToIndicies
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


module BitmapToIndicies import Block::*; (
        input BitBlock bitmap, input InputIndex startingIndex, 
        input clk, rst, enb, 
        output logic holdPipeline, output InputIndex[3:0] oneIndexes, output BitBlockIndex numOnes );
        
        BitBlockIndex [3:0] dexes;
        
        BitmapIndexDecoder DECODEY (.in(bitmap), .dexes);
        BitmapOneCounter   ONESEY  (.in(bitmap), .numOnes);
        
        always_comb begin
            for(int i = 0; i < 4; i++) begin
                oneIndexes[i] = dexes[i] + startingIndex;
            end
        end
        
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2023 02:42:46 PM
// Design Name: 
// Module Name: BitmapIndexDecoder
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

module BitmapIndexDecoder import Block::*; (input BitBlock in, output BitBlockIndex [3:0] dexes);

    always_comb begin
        foreach(dexes[i]) dexes[i] = '0;
        for(int i = 0; i < BlockSizeChars; i++) begin
            if(in[i]) begin // we have a one! announce to the world that this is an in to dex!
                for(int j = 0; j < 4; j++) begin
                    if(dexes[j] == 0) begin
                        dexes[j] = i;
                        break;
                    end
                end
                
            end
        end
    end
    
endmodule
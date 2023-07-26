`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2023 02:33:05 PM
// Design Name: 
// Module Name: BitmapOneCounter
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


module BitmapOneCounter import Block::*; (input BitBlock in, output BitBlockIndex numOnes  );
    always_comb begin
        numOnes = '0;
        for(int i = 0; i < BlockSizeChars; i++) begin
            numOnes += in[i];
        end
    end
    
endmodule

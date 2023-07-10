`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/05/2023 06:09:09 PM
// Design Name: 
// Module Name: BlockRamSharer
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

module BlockRamSharer import Ram::*; #(NUMWORDS=64, WORDSIZE=8)(
        input clk, input BlockRamWrite ramWrite, output BlockRamRead ramRead
    );
    
    DualTapeUnionUnpacker(WORDSIZE);    
    
    TapeBlockRam #(.WORDSIZE(WORDSIZE), .NUMWORDS(NUMWORDS)) blockRam (
       // use ordered to avoid headache
       clk, ramW.ena, ramW.enb, ramW.wea, ramW.web, ramW.addra, ramW.addrb, ramW.dia, ramW.dib, ramR.doa, ramR.dob  
    );
    
endmodule

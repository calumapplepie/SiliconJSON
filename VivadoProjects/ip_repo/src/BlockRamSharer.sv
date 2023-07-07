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

module BlockRamSharer #(NUMWORDS=64)(
        input clk, BlockRamConnection.owner r
    );
    TapeBlockRam #(.WORDSIZE(r.WORDSIZE), .ADDRWIDTH(r.ADDRWIDTH),.NUMWORDS(NUMWORDS)) blockRam (
       // use ordered to avoid headache
       clk, r.ena, r.enb, r.wea, r.web, r.addra, r.addrb, r.dia, r.dib, r.doa, r.dob, r.hash  
    );
endmodule

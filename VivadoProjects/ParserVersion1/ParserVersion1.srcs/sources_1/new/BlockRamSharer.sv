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

module BlockRamSharer import Ram::*; #(NUMWORDS=64, WORDSIZE=8, type ReadType, type WriteType)(
        input clk, enb, input WriteType ramW, output ReadType ramR
    );
      
    TapeBlockRam #(.WORDSIZE(WORDSIZE), .NUMWORDS(NUMWORDS)) blockRam (
       .clk(clk), .ena(ramW.ena && enb), .enb(ramW.enb && enb), 
       .wea(ramW.wea), .web(ramW.web), .addra(ramW.addra), .addrb(ramW.addrb), 
       .dia(ramW.dia), .dib(ramW.dib), .doa(ramR.doa), .dob(ramR.dob)  
    );
    
endmodule

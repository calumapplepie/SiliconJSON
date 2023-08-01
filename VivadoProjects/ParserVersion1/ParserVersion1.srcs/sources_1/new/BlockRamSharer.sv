`timescale 1ns / 1ps

module BlockRamSharer import Ram::*; #(NUMWORDS=64, WORDSIZE=8, type ReadType, type WriteType)  (
        input clk, enb, input WriteType ramW, output ReadType ramR
    );
      
    TapeBlockRam #(.WORDSIZE(WORDSIZE), .NUMWORDS(NUMWORDS)) blockRam (
       .clk(clk), .ena(ramW.ena && enb), .enb(ramW.enb && enb), 
       .wea(ramW.wea), .web(ramW.web), .addra(ramW.addra), .addrb(ramW.addrb), 
        .dib(ramW.dib), .dia(ramW.dia), .doa(ramR.doa), .dob(ramR.dob)  
    );
    
endmodule
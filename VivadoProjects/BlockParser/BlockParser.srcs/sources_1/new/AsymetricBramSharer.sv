`timescale 1ns / 1ps

// note: infers data widths from passed args
module AsymetricBramSharer import Ram::*; #(NUMWORDS=64, DO_REG=1, type ReadType=StructBlockRamRead, type WriteType=StringBlockRamWrite)  (
        input clk, enb, input WriteType ramW, output ReadType ramR
    );
      
    AsymetricBlockRam #(.WORDSIZE_IN($bits(ramW.dia)), .WORDSIZE_OUT($bits(ramR.doa)), .NUMWORDS(NUMWORDS), .DO_REG(DO_REG)) 
    blockRam (
       .clk(clk), .ena(ramW.ena && enb), .enb(ramW.enb && enb), 
       .wea(ramW.wea), .web(ramW.web), .addra(ramW.addra), .addrb(ramW.addrb), 
        .dib(ramW.dib), .dia(ramW.dia), .doa(ramR.doa), .dob(ramR.dob)  
    );
    
endmodule

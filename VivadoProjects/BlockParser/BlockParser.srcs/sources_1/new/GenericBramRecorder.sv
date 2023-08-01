`timescale 1ns / 1ps

module GenericBramRecorder import Ram::*;  #(WORDSIZE=8, NUMWORDS=1, USEPORTS=2, type WriteType) (
        output WriteType ramWrite, 
        input logic clk, enable, rst, 
        input logic [NUMWORDS-1:0] [WORDSIZE-1:0] data 
    );
    
    (* mark_debug = "true" *) logic [$bits(ramWrite.addra)-1:0] curAddr;
    
    always_comb begin
        ramWrite.ena = enable;
        ramWrite.wea = '1; ramWrite.web = '1;
        
        ramWrite.addra = curAddr;
        
        
        if(USEPORTS ==1) begin
            ramWrite.dia = data;
            ramWrite.addrb = 'x;
            ramWrite.enb = '0;
            ramWrite.dib = 'x;
        end else begin
            ramWrite.addrb = curAddr + NUMWORDS/2;
            ramWrite.enb = enable;
            ramWrite.dia = data[NUMWORDS/2-1:0];
            ramWrite.dib = data[NUMWORDS-1:NUMWORDS/2];
        end
        
    end
    
    always_ff @(posedge clk) begin
        if(rst)         curAddr <= 0;
        else if(enable) curAddr <= curAddr + NUMWORDS;
    end
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/27/2023 11:57:24 AM
// Design Name: 
// Module Name: GenericBramRecorder
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


module GenericBramRecorder import Ram::*;  #(WORDSIZE=8, NUMWORDS=1, USEPORTS=2, type WriteType) (
        output WriteType ramWrite, 
        input logic clk, enable, rst, 
        input logic [NUMWORDS-1:0] [WORDSIZE-1:0] data 
    );
    
    (* mark_debug = "true" *) logic [$bits(ramWrite.addra)-1:0] curAddr;
    
    always_comb begin
        // Disable port b and all writes.  Tie enable to the input to avoid ram output updating to the next address until the next
        // enable cycle (curAddr is IntendedOutAddr(t)+1 during cycle t regardless of if the enable was dropped to low during the cycle)  
        
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2023 02:45:05 PM
// Design Name: 
// Module Name: BlockReader
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

// Reads a possibly-asymetric BRAM.  ReadType and WriteType should be structs of the form typical in RamPkg.sv , NUMWORDS is the number
// of words that are read at once (if RAM is asymetric), and WORDSIZE is the bitwidth of each word
// Verilog's weak typing system makes the fact that the 'data' output is an array not really matter
module GenericBramReader import Ram::*;  #(WORDSIZE=8, NUMWORDS=1, type WriteType, type ReadType) (
        output WriteType ramWrite, 
        input ReadType ramRead,
        input logic clk, enable, rst, 
        output logic [WORDSIZE-1:0] [NUMWORDS-1:0] data 
    );
    
    (* mark_debug = "true" *) logic [$bits(ramWrite.addra)-1:0] curAddr;
    
    always_comb begin
        // Disable port b and all writes.  Tie enable to the input to avoid ram output updating to the next address until the next
        // enable cycle (curAddr is IntendedOutAddr(t)+1 during cycle t regardless of if the enable was dropped to low during the cycle)  
        ramWrite.enb = '0;
        ramWrite.ena = enable;
        ramWrite.wea = '0; ramWrite.web = '0;
        
        ramWrite.addra = rst ? '0 : curAddr;
        data = ramRead.doa;
        
        // set others to 'x to make the compiler not complain about unassigned vars, and maybe do a bit of optimization
        ramWrite.dia = 8'hBA; ramWrite.dib = 8'hBA;
        ramWrite.addrb = '0;
    end
    
    always_ff @(posedge clk) begin
        if(rst)         curAddr <= '0;
        else if(enable) curAddr <= curAddr + NUMWORDS;
    end
    
endmodule

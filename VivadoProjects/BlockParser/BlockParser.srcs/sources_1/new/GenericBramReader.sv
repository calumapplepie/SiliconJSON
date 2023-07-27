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

// Yes, this module has a ton of parameters and only two ways we combine them all.
// Since I am open sourcing this, I should maximize the reusable details for others.
// Perhaps I could even build a separate Block Ram Library, because of the amount of tomfoolery
// I do with them.
// This would be easier if SystemVerilog and Vivado included just a few more features (eg, virtual classes

module GenericBramReader import Ram::*;  #(WORDSIZE=8, JUMPSIZE=1, type WriteType, type ReadType) (
        output WriteType ramWrite, 
        input ReadType ramRead,
        input logic clk, enable, rst,
        output logic [WORDSIZE-1:0] data 
    );
    // get an actual number for this later
    (* mark_debug = "true" *) logic [16:0] curAddr;
    
    always_comb begin
        ramWrite.enb = '0;
        ramWrite.ena = enable;
        ramWrite.wea = '0; ramWrite.web = '0;
        
        ramWrite.addra = curAddr;
        data = ramRead.doa;
    end
    
    always_ff @(posedge clk) begin
        if(rst)      curAddr <= '0;
        else if(enable) curAddr <= curAddr + JUMPSIZE;
    end
    
endmodule

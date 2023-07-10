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


module BlockReader import Ram::*;  #(WORDSIZE=8) (
        input BlockRamWrite ramWrite, BlockRamRead ramRead,
        input logic clk, enable, rst,
        output logic [WORDSIZE-1:0] data 
    );
    logic [ram.ADDRWIDTH -1 :0] curAddr;
    
    DualTapeUnionUnpacker(WORDSIZE);
    
    always_comb begin
        ramW.enb = '0;
        ramW.ena = enable;
        ramW.wea = '0; ram.web = '0;
        
        ramW.addra = curAddr;
        ramR.doa = data;
    end
    
    always_ff @(posedge clk) begin
        if(rst)      curAddr <= '0;
        else if(enable) curAddr <= curAddr + 1;
    end
    
endmodule

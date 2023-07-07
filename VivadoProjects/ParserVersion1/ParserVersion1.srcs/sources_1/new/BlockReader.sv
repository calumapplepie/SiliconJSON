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


module BlockReader #(WORDSIZE=8)(
        BlockRamConnection.user ram,
        input logic clk, enable, rst,
        output logic [WORDSIZE-1:0] data 
    );
    logic [ram.ADDRWIDTH -1 :0] curAddr;
    
    
    always_comb begin
        ram.enb = '0;
        ram.ena = enable;
        ram.wea = '0; ram.web = '0;
        
        ram.addra = curAddr;
        ram.doa = data;
    end
    
    always_ff @(posedge clk) begin
        if(rst)      curAddr <= '0;
        else if(enable) curAddr <= curAddr + 1;
    end
    
endmodule

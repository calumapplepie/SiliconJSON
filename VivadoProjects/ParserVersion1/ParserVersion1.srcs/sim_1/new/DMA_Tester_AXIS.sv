`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2023 02:24:11 PM
// Design Name: 
// Module Name: DMA_Tester_AXIS
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


module DMA_Tester_AXIS import axi4stream_vip_pkg::*; ();
    
    
    logic clk, rst;
    
    AXIS_Tester_wrapper dut (.sys_clk(clk), .reset_rtl(!rst));
    
    initial forever begin
        clk <= '0; #5;
        clk <= '1; #5;
    end

endmodule

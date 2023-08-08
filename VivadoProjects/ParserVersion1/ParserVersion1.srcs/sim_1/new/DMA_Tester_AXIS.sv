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


module DMA_Tester_AXIS import axi4stream_vip_pkg::*, AXIS_Tester_axi4stream_vip_1_0_pkg::*, AXIS_Tester_axi4stream_vip_0_0_pkg::*; ();
    AXIS_Tester_axi4stream_vip_1_0_mst_t                              mst_agent;
    AXIS_Tester_axi4stream_vip_0_0_slv_t                              slv_agent;
    
    logic clk, rst;
    
    AXIS_Tester_wrapper DUT (.sys_clock(clk), .reset_rtl(!rst));
    
    initial begin
        rst <= '1;
        mst_agent = new("master vip agent", DUT.AXIS_Tester_i.axis_vip_mst.inst.IF);
        slv_agent = new("slave vip agent",DUT.AXIS_Tester_i.axis_vip_slv.inst.IF);
        
        #10; rst <= '0;
        
        
        
    end
    
    
    
    initial forever begin
        clk <= '0; #5;
        clk <= '1; #5;
    end

endmodule

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
    
    // write transaction created by master VIP     
    axi4stream_transaction    wr_transaction;                      
    // Ready signal created by slave VIP when TREADY is High    
    axi4stream_ready_gen      ready_gen;   
    
    logic clk, rst;
    
    AXIS_Tester_wrapper DUT (.sys_clock(clk), .reset_rtl(!rst));
    logic [63:0] testData = "{\"H\":\"I\"}";
    initial begin
        rst <= '1;
        // init our agents
        mst_agent = new("master vip agent", DUT.AXIS_Tester_i.axis_vip_mst.inst.IF);
        slv_agent = new("slave vip agent",DUT.AXIS_Tester_i.axis_vip_slv.inst.IF);
        
        /* disables driving 'x : may be needed, but docs may be wrong
        mst_agent.vif_proxy.set_dummy_drive_type(XIL_AXI_VIF_DRIVE_NONE);    
        slv_agent.vif_proxy.set_dummy_drive_type(XIL_AXI_VIF_DRIVE_NONE);
        */
        
        // init our ready signal
        ready_gen = slv_agent.driver.create_ready("ready_gen");    
        ready_gen.set_ready_policy(XIL_AXI4STREAM_READY_GEN_RANDOM);
        
        mst_agent.start_master();
        slv_agent.start_slave();
        #10; rst <= '0;
        #40;
        wr_transaction = mst_agent.driver.create_transaction("write transaction");
        wr_transaction.set_id('0);
        
        wr_transaction.set_data_beat(testData);
        wr_transaction.set_dest(1'b0);
        wr_transaction.set_last(1'd0);
        mst_agent.driver.send(wr_transaction);
        #60;
        wr_transaction.set_data_beat('0);
        wr_transaction.set_last(1'b1);
        mst_agent.driver.send(wr_transaction);
        
        #30;
        #50;

        
        
        
    end
    
    
    
    initial forever begin
        clk <= '0; #5;
        clk <= '1; #5;
    end

endmodule

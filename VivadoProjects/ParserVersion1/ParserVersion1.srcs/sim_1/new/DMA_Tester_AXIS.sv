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
    string testData1 = "{\"H\":1}";
    string testData2 = "{\"Hello\":[\"I'm\",20]}";
    
    task stringToBytes(input int dex, input string s, output logic [7:0][7:0] data);
        for(int i = 0; i < 8; i++) begin
            data[i] = s[dex+i];
        end
    endtask
    
    task sendDataPacket(input string s);
        int i;
        logic [63:0] testData;
        string selection;
        for(i = 0; i < s.len(); i+= 8) begin
            wr_transaction  = mst_agent.driver.create_transaction("write transaction");
            assert(wr_transaction.randomize());
            stringToBytes(i, s, testData);
            
            wr_transaction.set_data_beat(testData);
            wr_transaction.set_dest(1'b0);
            wr_transaction.set_last(1'd0);
            mst_agent.driver.send(wr_transaction);
            #40;
        end
        
        // send close transatction
        wr_transaction  = mst_agent.driver.create_transaction("write transaction");
        assert(wr_transaction.randomize());
        stringToBytes(i, s, testData);
        wr_transaction.set_data_beat(testData);
        wr_transaction.set_dest(1'b0);
        wr_transaction.set_last(1'd1);
        mst_agent.driver.send(wr_transaction);
        #40;

    endtask
        
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
        ready_gen.set_use_variable_ranges();
        slv_agent.driver.seq_item_port.put_item(ready_gen);
        
        mst_agent.start_master();
        slv_agent.start_slave();
        
        #10; rst <= '0;
        #40;
        sendDataPacket(testData1);
        
        #30;
        #50;
        #90;
        sendDataPacket(testData2);

        
        
        
    end
    
    
    
    initial forever begin
        clk <= '0; #5;
        clk <= '1; #5;
    end

endmodule

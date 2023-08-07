`timescale 1ns / 1ps

module DMATopWrapper(
        // vivado requires specific naming conventins for ports to be detected as being part of an AXI interface
        // we want vivido to detect that so we can make it work with the block device better
        input  wire axis_aclk,
        input  wire [63:0] s_axis_tdata, wire [3:0] s_axis_tdest,
        input  wire s_axis_tvalid, s_axis_tlast, s_axis_resetn, 
        output wire s_axis_tready,
        input  wire m_axis_resetn, m_axis_tready,
        output wire [63:0] m_axis_tdata, wire [3:0] m_axis_tdest,
        output  wire m_axis_tvalid, m_axis_tlast
    );
    DMATop TOP (
        // this may be the ugliest thing ever but its what we've gotta do
        .clk(axis_aclk), .enb(1'd1), .rst(1'd0),
        .inputStreamData(s_axis_tdata), .inputStreamDest(s_axis_tdest),
        .inputStreamValid(s_axis_tvalid), .inputStreamLast(s_axis_tlast), .inputStreamReset(s_axis_resetn),
        .inputStreamReady(s_axis_tready),
        .outputStreamReset(m_axis_resetn), .outputStreamReady(m_axis_tready),
        .outputStreamData(m_axis_tdata), .outputStreamDest(m_axis_tdest), 
        .outputStreamValid(m_axis_tvalid), .outputStreamLast(m_axis_tlast)
    );
    
    
endmodule

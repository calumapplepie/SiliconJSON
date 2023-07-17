`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2023 06:56:43 PM
// Design Name: 
// Module Name: BlockRamStack
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


// values picked to use a single RAMB18E1 ; ie, half of a block ram element
// see UG473.
module BlockRamStack #(WIDTH=18, DEPTH=512)(
        input clk, rst, enb,
        input pushEnable, popTrigger,
        input [WIDTH-1:0] pushData,
        output logic [WIDTH-1:0] popData,
        output logic [9:0] curDepth
    );
    
    // note: we never write to the lowest index of the stack.  
    logic[9:0] curTop = 0;
    logic[9:0] nextAddress;
    assign curDepth = curTop;
    
    always_comb begin
        nextAddress = curTop;
        if(pushEnable) nextAddress = curTop+1;
        if(popTrigger) nextAddress = curTop-1;
    end
    
    // Sadly, the internal FIFO logic controlers do not allow for FILO logic.  I checked :(
    TapeBlockRam #(.WORDSIZE(WIDTH), .NUMWORDS(DEPTH)) ram (
        .clk, .enb('0), .ena(enb), .wea(pushEnable),
        .dia(pushData), .doa(popData), .addra(nextAddress)
    );
    
    always_ff @(posedge clk) begin
        if(rst)      curTop <= '0;
        else if(enb) curTop <= nextAddress;
    end
endmodule

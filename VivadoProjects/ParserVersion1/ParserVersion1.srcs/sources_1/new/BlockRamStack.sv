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
    logic[9:0] nextTop;
    assign nextTop = curTop + 1'd1;
    assign curDepth = curTop;
    
    // Sadly, the internal FIFO logic controlers do not allow for FILO logic.  I checked :(
    TapeBlockRam #(.WORDSIZE(WIDTH), .NUMWORDS(DEPTH)) ram (
        .clk, .enb(enb), .ena(enb), .wea(pushEnable), .web('0),
        .dia(pushData), .dob(popData), .addra(nextTop), .addrb(curTop)
    );
    
    always_ff @(posedge clk) begin
        if(rst)              curTop <= '0;
        else if(!enb)        ; //only run below statements if enabled
        else if(pushEnable)  curTop <= nextTop;
        else if(popTrigger)  curTop <= curTop -1;
    end
    
endmodule

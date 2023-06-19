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


module BlockRamStack(

    );
    // values picked to use a single RAMB18E1 ; ie, half of a block ram element
    // see UG473.
    // Sadly, the internal FIFO logic controlers do not allow for FILO logic.  I checked :(
    TapeBlockRam ram #(.WORDSIZE(18), .NUMWORDS(512)) (
        
    );
    
endmodule

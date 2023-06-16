`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2023 05:10:37 PM
// Design Name: 
// Module Name: ShiftRegister
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

// yes I, Calum McConnell, am writing this specfically for a function that does not 
// use those paramaterized defaults.  I'm not even looking at a reference and copying
// it, I'm just choosing defaults that I'll have to override because that's what
// my design principles say.
module ShiftRegister #(WORDSIZE=8, NUMWORDS=16)(
        input [WORDSIZE-1:0] nextIn, 
        input clk, rst, enb,
        output logic [WORDSIZE-1:0] arrayOut [NUMWORDS-1:0]
    );
    
    always_ff @(posedge clk) begin
        if(rst) foreach(arrayOut[i]) arrayOut[i] <= '0;
        else if(enb) begin
            for(int i = 1; i<NUMWORDS; i++) begin
                arrayOut[i] <= arrayOut[i-1];
            end
            arrayOut[0] <= nextIn;
        end
    end
endmodule

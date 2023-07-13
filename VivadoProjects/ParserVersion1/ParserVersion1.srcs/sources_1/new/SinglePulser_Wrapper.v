`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2023 01:37:17 PM
// Design Name: 
// Module Name: SinglePulser_Wrapper
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


module SinglePulser_Wrapper(
        input wire clk, din, output wire d_pulse
    );
    SinglePulser Pulsey (clk, din, d_pulse);
endmodule

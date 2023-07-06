`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2023 11:16:13 AM
// Design Name: 
// Module Name: VivadoPulseWrap
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


module VivadoPulseWrap(input clk, din, output reg d_pulse);
    SinglePulser PULSEY (clk, din, d_pulse);
endmodule

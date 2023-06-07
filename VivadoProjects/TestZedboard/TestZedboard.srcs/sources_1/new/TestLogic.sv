`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2023 12:14:40 PM
// Design Name: 
// Module Name: TestLogic
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


module TestLogic(
        input GCLK, BTNC,
        output LD0, LD1
);
        reg [24:0] count = 0;
        assign LD0 = count[24];
        assign LD1 = BTNC;
        always @ (posedge(GCLK)) count <= count + 1;
    
endmodule

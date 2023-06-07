`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2023 04:22:05 PM
// Design Name: 
// Module Name: toplevel
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

typedef logic[0:7] UTF8_Char;
typedef enum {root, objOpen, objClose, arrayOpen, arrayClose, str} JsonElementType;

module toplevel(
    input UTF8_Char curChar,
    input clk
    );
    
    
endmodule

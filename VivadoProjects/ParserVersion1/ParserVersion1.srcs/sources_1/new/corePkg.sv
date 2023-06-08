`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2023 06:05:57 PM
// Design Name: 
// Module Name: corePkg
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

// global include: added to all files
// why? because i couldnt get packages to work
// note: maybe they didn't work due to an unrelated problem
typedef bit [0:7] UTF8_Char;
typedef enum {root, objOpen, objClose, arrayOpen, arrayClose, str, noType} JsonElementType;


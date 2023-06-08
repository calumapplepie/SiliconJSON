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
// reconsider that.  also, lets look at making these classes
typedef bit [0:7] UTF8_Char;
typedef enum {root, objOpen, objClose, arrayOpen, arrayClose, str, noType} JsonElementType;
typedef bit [0:63] JsonTapeElement;


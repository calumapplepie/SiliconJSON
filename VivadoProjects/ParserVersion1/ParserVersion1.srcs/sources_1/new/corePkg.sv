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
typedef logic [7:0] UTF8_Char;
typedef enum logic [3:0] {root, objOpen, objClose, arrayOpen, arrayClose, str, noType} JsonElementType;
// for now make these synonyms: will split apart later though
typedef JsonElementType JsonCharType;
typedef logic [63:0] JsonTapeElement;
typedef logic [55:0] TapeIndex;


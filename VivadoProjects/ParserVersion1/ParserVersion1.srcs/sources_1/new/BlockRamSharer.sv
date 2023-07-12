`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/05/2023 06:09:09 PM
// Design Name: 
// Module Name: BlockRamSharer
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

module BlockRamSharerString import Ram::*; (
        input clk, enb, input StringBlockRamWrite ramW, output StringBlockRamRead ramR
    );
      
    TapeBlockRam #(.WORDSIZE(8), .NUMWORDS(Core::StringTapeLength)) blockRam (
       .clk(clk), .ena(ramW.ena && enb), .enb(ramW.enb && enb), 
       .wea(ramW.wea), .web(ramW.web), .addra(ramW.addra), .addrb(ramW.addrb), 
        .dib(ramW.dib), .dia(ramW.dia), .doa(ramR.doa), .dob(ramR.dob)  
    );
    
endmodule
module BlockRamSharerStruct import Ram::*; (
        input clk, enb, input StructBlockRamWrite ramW, output StructBlockRamRead ramR
    );
    
    wire [63:0] lookAtMe;
    assign lookAtMe = ramW.dia[63:0]; 
    
    TapeBlockRam #(.WORDSIZE(64), .NUMWORDS(Core::StructTapeLength)) blockRam (
       .clk(clk), .ena(ramW.ena && enb), .enb(ramW.enb && enb), 
       .wea(ramW.wea), .web(ramW.web), .addra(ramW.addra), .addrb(ramW.addrb), 
        .dib(ramW.dib), .dia(lookAtMe), .doa(ramR.doa), .dob(ramR.dob)  
    );
    

    
endmodule
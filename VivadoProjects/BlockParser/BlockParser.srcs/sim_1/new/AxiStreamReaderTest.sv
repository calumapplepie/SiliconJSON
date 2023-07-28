`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2023 03:18:31 PM
// Design Name: 
// Module Name: AxiStreamReaderTest
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


module AxiStreamReaderTest import Ram::*; (

    );
    logic clk, enb, rst, TREADY;
    
    // simulate 8-char string reader with the struct data types
    AxiStreamReader #(.WORDSIZE(8), .NUMWORDS(4), .ReadType(StructBlockRamRead), .WriteType(StringBlockRamWrite)) DUV (
        .clk, .enable(enb), .rst, .TREADY, .ramWrite, .ramRead
    );
    
    // give 'er a BRAM
    AsymetricBramSharer #(.NUMWORDS(64), .ReadType(StructBlockRamRead), .WriteType(StringBlockRamWrite)) bob (
        .clk, .enb('1), .ramW(ramWrite), .ramR(ramRead)
    );
    
    initial begin
        rst<='1;
        enb <='0; #10;
        // now lets run it a bit
        enb <= '1; rst <= '0; TREADY <= '1;
        #40; // check the outputs, calum!
        enb <='0; #20; enb <='1; #10;                        // pulse enable
        TREADY <= '0; #20; TREADY <='1; #10;                 // pulse TREADY
        // pulse both TREADY and enable
        enb <='0; TREADY <= '0; #20; TREADY <='1; #10; enb <='1;
        rst <='1; #10; rst <= '0; #50;                      // confirm reset works
        TREADY <= '0; rst <= '1; #10; rst <= '0;            // confirm reset with TREADY off works
        #40; TREADY <= '1; #20; enb <= '0; #20;             // disable, confirm bits
        
        #50;
    end
    
    initial forever begin
        clk <= '0; #5;
        clk <= '1; #5;
    end
endmodule

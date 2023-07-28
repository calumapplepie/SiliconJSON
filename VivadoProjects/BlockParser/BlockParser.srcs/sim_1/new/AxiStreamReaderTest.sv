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
    StructBlockRamRead  ramRead;
    StringBlockRamWrite ramWrite;
    
    // simulate 8-char string reader with the struct data types
    AxiStreamReader #(.WORDSIZE(8), .NUMWORDS(4), .ReadType(StructBlockRamRead), .WriteType(StringBlockRamWrite)) DUV (
        .clk, .enable(enb), .rst, .TREADY, .ramWrite, .ramRead, .TRESET('0)
    );
    
    // give 'er a BRAM
    AsymetricBramSharer #(.NUMWORDS(64), .ReadType(StructBlockRamRead), .WriteType(StringBlockRamWrite)) bob (
        .clk, .enb('1), .ramW(ramWrite), .ramR(ramRead)
    );
    
    task runTest();
        rst<='1;TREADY <= '1;
        enb <='0; #10;
                                        // now lets run it a bit
        enb <= '1; rst <= '0;   #40;    // check the outputs, calum!
        enb <='0;               #20; 
        enb <='1;               #10;    // pulse enable
        TREADY <= '0;           #20; 
        TREADY <='1;            #10;    // pulse TREADY
        enb <='0; TREADY <= '0; #20;    // pulse both TREADY and enable
        TREADY <='1;            #10; 
        enb <='1; rst <='1;     #10; 
        rst <= '0;              #50;    // confirm reset works
        TREADY <= '0;rst <= '1; #10; 
        rst <= '0;              #40;    // confirm reset with TREADY off works
        TREADY <= '1;           #20;
        enb <= '0;              #20;    // disable, confirm bits
        rst <= '1;              #10;    // how about rst with enable off?
        rst <= '0; enb <= '1;   #50;
    endtask
    
    
    initial begin
        // run the test twice, for Surety
        runTest(); 
        runTest();
    end;
    
    initial forever begin
        clk <= '0; #5;
        clk <= '1; #5;
    end
endmodule

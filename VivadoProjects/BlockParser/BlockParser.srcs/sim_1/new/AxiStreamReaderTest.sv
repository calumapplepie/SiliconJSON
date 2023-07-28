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


module AxiStreamReaderTest(

    );
    logic clk, enb, rst, TREADY;
    
    // simulate 8-char string reader with the struct data types
    AxiStreamReader #(.WORDSIZE(8), .NUMWORDS(4), .ReadType(Ram::StructBlockRamRead), .WriteType(Ram::StringBlockRamWrite)) DUV (
        .clk, .enable(enb), .rst, .TREADY
    );
    
    // give 'er a BRAM
    
    initial begin
        rst<='1;
        enb <='0; #10;
        // now lets run it a bit
        enb <= '1; rst <= '0; TREADY <= '1;
    end
    
    initial forever begin
        clk <= '0; #5;
        clk <= '1; #5;
    end
endmodule

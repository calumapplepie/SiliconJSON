`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2023 01:57:00 PM
// Design Name: 
// Module Name: GPIO_Interface_Test
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


module GPIO_Interface_Test(
        
    );
    logic clk, rst, enable, readSide;
    Core::UTF8_Char curChar;
    
    TopWrapper DUV (.GCLK(clk), .rst, .enable, .readSide, .curChar, .curStructBits, .curStringBits);
    
    string testDoc1 = "{\"author\":\"calum\"}";
    string testDoc2 = "{\"The Answer\": 42}";

    
    task runTest();
        readSide <= '0;
        foreach(testDoc1[i]) begin
            curChar <= testDoc1[i];
            enable <= '1; #10;
            enable <= '0; #10;
        end
        readSide <='0;
        #20; // may not be needed but is accurate
        foreach(testDoc2[i]) begin
            curChar <= testDoc2[i];
            enable <= '1; #10;
            enable <= '0; #10;
        end
        
    endtask
    
    
     initial begin
        // cycles are 10 ns long: inputs change on multiples of 10, while positive edges are 5ns later
        forever begin
            clk <= 1'b0; #5;
            clk <= 1'b1; #5;
        end

    end

    initial begin
        enable <= '0;
        rst <= 1'b1;
        #10;
        rst <= 1'b0;
        #20;
        runTest();
        enable <= '0;
        #30 ;
        rst <= 1'b1; 
        #40;
        rst <= 0;
        #50;
        // run test twice to ensure reset doesn't leave residue
        runTest();
        enable <= '0;
        #60;
    end
    
endmodule

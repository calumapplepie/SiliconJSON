`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2023 06:22:52 PM
// Design Name: 
// Module Name: OverallJsonTester_tb
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


module OverallJsonTester_tb();
    logic clk, rst, enable;
    string basenames [32];
    string VivadoProjectDir = "";    
    integer errorCode;    
    
    task static evaluateJsonFile(string basename);
        int jsonFileHandle = $fopen({VivadoProjectDir,basename,".json"});
        
    endtask
    
    task static loadBasenames();
        int fileHandle = $fopen({VivadoProjectDir,"basenames.txt"});
        foreach(basenames[i]) begin
            if ($feof(fileHandle) > 0) break;
            errorCode = $fgets(basenames[i], fileHandle);
            if(errorCode ==0) $display("ERROR ON BASENAME FILE READ");
            
        end
    endtask
    
    
    task runTest();
        loadBasenames();
        foreach(basenames[i]) begin
            // all basenames are at least three characters
            if (basenames[i].len() < 3) break;
            evaluateJsonFile(basenames[i]);
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
        enable <= '1;
        runTest();
        enable <= '0;
        #30 ;
        rst <= 1'b1; 
        #40;
        rst <= 0;
        #50;
        // run test twice to ensure reset doesn't leave residue
        runTest();
        #60;
        $finish;
    end

endmodule

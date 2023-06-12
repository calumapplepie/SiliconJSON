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
    int errorsSoFar = '0;

    string basenames [32];
    string VivadoProjectDir = "";    
    integer errorCode;
    UTF8_Char nextChar;

    JsonTapeElement structTape[32], expectedStructTape [32];
    logic [7:0] stringTape[32], expectedStringTape [32];

    TopLevel DUV (
        .curChar(nextChar), 
        .stringTape(stringTape), .structTape(structTape),
        .enable(enable), .GCLK(clk), .rst(rst));
    
    task static evaluateJsonFile(input string basename);
        int jsonInFileHandle = $fopen({VivadoProjectDir,basename,".json"});
        
        // zero the memories
        foreach(expectedStringTape[i]) expectedStringTape[i] = '0;
        foreach(expectedStructTape[i]) expectedStructTape[i] = '0;

        // read the out files: should ignore whitespace
        $readmemh({VivadoProjectDir,basename,".string.hex"}, expectedStringTape);
        $readmemh({VivadoProjectDir,basename,".struct.hex"}, expectedStructTape);

        // read the in file
        while(! $feof(jsonInFileHandle)) begin
            nextChar = $fgetc(jsonInFileHandle);
            #10;
        end

        // compare
        foreach(expectedStringTape[i]) begin
            if (expectedStringTape[i] != stringTape[i]) begin
                errorsSoFar++;
                if(errorsSoFar <= 5) begin
                    $display("Error at string tape index %d when reading file %s",  i, basename);
                    $display("Expected %h, got %h", expectedStringTape[i], stringTape[i]);
                end
            end
        end

        foreach(expectedStructTape[i]) begin
            if (expectedStructTape[i] != structTape[i]) begin
                errorsSoFar++;
                if(errorsSoFar <= 5) begin
                    $display("Error at struct tape index %d when reading file %s",  i, basename);
                    $display("Expected %h, got %h", expectedStructTape[i], structTape[i]);
                end
            end
        end


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
            $display("Read %s, encountered %d errors", basename, errorsSoFar)
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

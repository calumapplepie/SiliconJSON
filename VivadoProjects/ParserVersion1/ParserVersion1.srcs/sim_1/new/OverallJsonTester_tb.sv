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

    import Core::JsonTapeElement, Core::StructTapeLength, Core::StringTapeLength, Core::UTF8_Char;

    string basenames [32];
    // let the record state that I do not like windows
    string JsonTestFilesDir = "C:/Users/mcconncm/Documents/SummerResearch2023/JsonTestFiles/";    
    integer errorCode;
    UTF8_Char nextChar;

    JsonTapeElement expectedStructTape [0:StructTapeLength];
    logic [7:0]     expectedStringTape [0:StringTapeLength];
    
    TopLevel DUV (
        .curChar(nextChar), 
        .enable(enable), .GCLK(clk), .rst(rst));
    
    task static evaluateJsonFile(string basename);
        int jsonInFileHandle = $fopen({JsonTestFilesDir,basename,".json"},"r");
        
        // zero the memories
        foreach(expectedStringTape[i]) expectedStringTape[i] = 'x;
        foreach(expectedStructTape[i]) expectedStructTape[i] = 'x;

        // read the out files: should ignore whitespace
        tmp = {JsonTestFilesDir,basename,".string.hex"};
        $readmemh(tmp, expectedStringTape);
        tmp = {JsonTestFilesDir,basename,".struct.hex"};
        $readmemh(tmp, expectedStructTape);

        // read the in file
        while(! $feof(jsonInFileHandle)) begin
            nextChar = $fgetc(jsonInFileHandle);
            #10;
        end
        
        // close in file
        $fclose(jsonInFileHandle);
        
        // bonus clock for pipeline
        #10;

        // compare
        foreach(expectedStringTape[i]) begin
            if (expectedStringTape[i] !=  DUV.writer.stringGoHere.ram.ram[i]) begin
                errorsSoFar++;
                if(errorsSoFar <= 5) begin
                    $display("Error at string tape index %d when reading file %s",  i, basename);
                    $display("Expected %h, got %h", expectedStringTape[i], DUV.writer.stringGoHere.ram.ram[i]);
                end
            end
        end

        foreach(expectedStructTape[i]) begin
            if (expectedStructTape[i] != DUV.writer.structGoHere.blockRam.ram[i]) begin
                errorsSoFar++;
                if(errorsSoFar <= 5) begin
                    $display("Error at struct tape index %d when reading file %s",  i, basename);
                    $display("Expected %h, got %h", expectedStructTape[i], DUV.writer.structGoHere.blockRam.ram[i]);
                end
            end
        end


    endtask
    string tmp;
    task static loadBasenames();
        int fileHandle = $fopen({JsonTestFilesDir,"basenames.txt"}, "r");
        foreach(basenames[i]) begin
            // init to canary value b/c $fgets wants preinitialized strings for some reason
            basenames[i] = {5{"badBADbadBAD"}};
            
            tmp = basenames[i];
            errorCode = $fgets(tmp, fileHandle);
            $display("Read %d chars: %s", errorCode, tmp);
            basenames[i] = tmp.substr(0, tmp.len()-2);
            
            if(errorCode ==0) begin
                // vivado doesn't support $ferror , which would let me be more specific
                $display("ERROR ON BASENAME FILE READ" );
            end
            // ensure we don't try to read BAD BAD BAD files
            if ($feof(fileHandle) > 0) begin
                basenames[i] = "";
            end
        end
        $fclose(fileHandle);
    endtask
    
    
    task runTest();
        loadBasenames();
        foreach(basenames[i]) begin
            rst = '1;
            #10;
            rst = '0;
            errorsSoFar = '0;
            // all basenames are at least three characters
            if (basenames[i].len() < 3) break;
            evaluateJsonFile(basenames[i]);
            $display("Read %s, encountered %d errors", basenames[i], errorsSoFar);
        end
        
    endtask
    
    // rest is standard testbench stuff

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
        enable <= '1;
        runTest();
        enable <= '0;
        #60;
        $finish;
    end

endmodule

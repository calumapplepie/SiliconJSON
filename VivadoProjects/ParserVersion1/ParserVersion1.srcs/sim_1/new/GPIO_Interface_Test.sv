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
    logic clk, rst, enable, readSide, parseEnable;
    Core::UTF8_Char curChar;
    
    TopWrapper DUV (.GCLK(clk), .rst, .enable, .readSide, .curChar, .curStructBits, .curStringBits,.parseEnable);
    
    string testDoc1 = "{\"author\":\"calum\"}";
    string testDoc2 = "{\"The Answer\": 42}";
    
    Core::JsonTapeElement curStructBits;
    Core::JsonTapeElement doc1Struct [0:5] = {64'h7200000000000006, 64'h7b00000100000005, 64'h2200000000000000, 64'h220000000000000b, 64'h7d00000000000001, 64'h7200000000000000};
    Core::JsonTapeElement doc2Struct [0:6] = {64'h7200000000000007, 64'h7b00000100000006, 64'h2200000000000000, 64'h6c00000000000000, 64'h2a, 64'h7d00000000000001, 64'h7200000000000000}; 
    Core::JsonTapeElement readStruct [31:0];
    
    logic[7:0] curStringBits;
    logic[7:0] doc1String [0:20] = {8'h6, 8'h0, 8'h0, 8'h0, 8'h61, 8'h75, 8'h74, 8'h68, 8'h6f, 8'h72, 8'h0, 8'h5, 8'h0, 8'h0, 8'h0, 8'h63, 8'h61, 8'h6c, 8'h75, 8'h6d, 8'h0};
    logic[7:0] doc2String [0:14] = {8'ha, 8'h0, 8'h0, 8'h0, 8'h54, 8'h68, 8'h65, 8'h20, 8'h41, 8'h6e, 8'h73, 8'h77, 8'h65, 8'h72, 8'h0};
    logic[7:0] readString [31:0];
        
    task runTest();
        parseEnable <='1; // not extraneous
        readSide <= '1;
        foreach(testDoc1[i]) begin
            curChar <= testDoc1[i];
            enable <= '1; #10;
            enable <= '0; #10;
        end
        enable <='1;
        #30;
        
        rst      <='1;
        readSide <='0;
        #20; 
        rst      <='0;
        foreach(testDoc2[i]) begin
            curChar <= testDoc2[i];
            enable <= '1; #10;
            enable <= '0; #10;
        end
        enable <='1;
        #30;
        // done parsing
        parseEnable <='0; 
        
        // reset the readers, and enable
        rst <= '1; #10; 
        rst <= '0; enable <= '1;
        // read in the first doc we parsed, as readSide is set to 0
        for(int i = 0; i < 32; i++) begin
            #10; 
            readStruct[i] <= curStructBits; 
            readString[i] <= curStringBits;
        end
           
        // verify
        foreach(doc1String[i]) begin
            if(doc1String[i] != readString[i]) 
                $display("doc 1 string error at index %d: expected %h, got %h", i, doc1String[i], readString[i]);
        end
        foreach(doc1Struct[i]) begin
            if(doc1Struct[i] != readStruct[i]) 
                $display("doc 1 struct error at index %d: expected %h, got %h", i, doc1Struct[i], readStruct[i]);
        end
        
        // read in the seccond doc
        rst <='1; readSide <= '1; #10; 
        rst <= '0;
        for(int i = 0; i < 32; i++) begin
            #10; 
            readStruct[i] <= curStructBits; 
            readString[i] <= curStringBits;
        end
        
        // verify
        foreach(doc2String[i]) begin
            if(doc2String[i] != readString[i]) 
                $display("doc 2 string error at index %d: expected %h, got %h", i, doc2String[i], readString[i]);
        end
        foreach(doc2Struct[i]) begin
            if(doc2Struct[i] != readStruct[i]) 
                $display("doc 2 struct error at index %d: expected %h, got %h", i, doc2Struct[i], readStruct[i]);
        end      
        $display ("DONE");       
        
        
    endtask
    
    
     initial begin
        // cycles are 10 ns long: inputs change on multiples of 10, while positive edges are 5ns later
        forever begin
            clk <= 1'b0; #5;
            clk <= 1'b1; #5;
        end

    end

    initial begin
        parseEnable <='1; // may be extraneous
        readSide <= '0;    
        curChar <= '0;
    
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
        $finish;
    end
    
endmodule

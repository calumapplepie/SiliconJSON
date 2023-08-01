`timescale 1ns / 1ps

module ParallelToSerialTest();
    logic clk, rst, enable, enableIn, enableOut;
    logic [7:0] curCharBlock [3:0];
    logic [7:0] curChar;
    
    assign enableIn = enable;
    
    InputBlockBreaker DUV1 (.*);
    

    task runTest();
        curCharBlock <= {"a", "b", "c", "d"}; 
        enableIn <= '0;
        #40; // don't do anything when disabled
        curCharBlock <= {"e", "f", "g", "h"}; 
        enableIn <= 1;
        #40; // should finish the thing
        curCharBlock <= {'0,'0,'0,'0};
        #50;
        enableIn <= 0;
        #50;
        enableIn <= '1;
        curCharBlock <= {"a", "b", "c", "d"};
        #90;
        $finish;
    endtask

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
        $finish;
    end

    initial begin
        // cycles are 10 ns long: inputs change on multiples of 10, while positive edges are 5ns later
        forever begin
            clk <= 1'b0; #5;
            clk <= 1'b1; #5;
        end
    end
endmodule

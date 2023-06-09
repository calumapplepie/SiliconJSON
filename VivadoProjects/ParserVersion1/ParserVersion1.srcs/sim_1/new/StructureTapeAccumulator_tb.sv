`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2023 05:18:07 PM
// Design Name: 
// Module Name: StructureTapeAccumulator_tb
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


module StructureTapeAccumulator_tb( );
    
    logic rst, clk, enable;
    
    JsonTapeElement tape [32];
    JsonTapeElement expected [32];
    
    JsonTapeElement nextElement;
    JsonElementType curElementType;
    
    TapeIndex stringTapeIndex;
    
    StructureTapeMaker elementBuilder (
        .elementType(curElementType), .stringTapeIndex(stringTapeIndex),
        .nextElement(nextElement)
    );
    
    StructureTapeAccumulator accumulate (
        .nextTapeEntry(nextElement), .tape(tape),
        .clk(clk), .rst(rst), .enable(enable)
    );
    
    
    task doCompare();
        foreach(tape[i]) begin
            if(tape[i] != expected[i])begin
                $display ("ERROR Does not matach at index %0d", i);
                $display ("Expected %d, got %d", expected[i], tape[i]);
            end
        end
    endtask 

    task  runTest();
    
    endtask
    
    // rest will be standard testbench stuff
    // todo: get it into a class or include or something


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

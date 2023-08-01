`timescale 1ns / 1ps


module StructureTapeAccumulator_tb( );
    
    import Core::*;
    
    logic rst, clk, enable;
    logic hadErrors = '0;
    
    JsonTapeElement tape [StructTapeLength];
    JsonTapeElement expected [StructTapeLength];
    
    JsonTapeElement nextElement;
    ElementType curElementType;
    
    TapeIndex stringTapeIndex;
    
    StructureTapeMaker elementBuilder (
        .elementType(curElementType), .stringTapeIndex(stringTapeIndex),
        .nextElement(nextElement)
    );
    
    StructureTapeAccumulator accumulate (
        .nextTapeEntry(nextElement), .keyValuePairs(24'hF00D),
        .clk(clk), .rst(rst), .enable(enable)
    );
    
    
    task doCompare();
        foreach(expected[i]) begin
            if(accumulate.blockRam.ram[i] != expected[i])begin
                $display ("ERROR Does not match at index %0d", i);
                $display ("Expected %h, got %h", expected[i], accumulate.blockRam.ram[i]);
                hadErrors++;
            end
        end
    endtask 

    task  runTest();
        enable = '1;
        stringTapeIndex = '0;
        foreach(expected[i]) expected[i] = 'x;
        doCompare();
        curElementType = objOpen;
        expected[1] = {"{", 56'd0};
        #10;
        curElementType = str;
        doCompare();
        expected[2] = {"\"",56'd0};
        #10;
        doCompare();
        stringTapeIndex = 56'd12;
        expected[3]={"\"",56'd12};
        #10;
        doCompare();
        enable = '0;
        #10;
        doCompare();
        enable = '1;
        stringTapeIndex = 56'd98;
        expected[4]={"\"",56'd98};
        #10;
        doCompare();
        stringTapeIndex = 56'd12352;
        expected[5]={"\"",56'd12352};
        #10;
        doCompare();
        curElementType = objClose;
        stringTapeIndex = 152;
        expected[6] = {"}", 56'd1};
        expected[1] = {"{", 24'hF00D, 32'd7};
        #10
        doCompare();
        expected[0] = {"r", 56'd8};
        expected[7] = {"r", 56'd0};
        #10;
        doCompare();
        enable = '0;
    endtask
    
    // rest is be standard testbench stuff
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

// note: an inheriting class-base archectecture would be a good idea,
// but my SV skill aren't there yet

module StringTapeAccumulator_tb ();
    // idk why vivado wants this line
    typedef logic [55:0] TapeIndex;
    
    import Core::StringTapeLength;
    
    logic rst, clk, enable;
    logic [7:0] expected [StringTapeLength];
    TapeIndex curIndex, expectedIndex;
    Core::UTF8_Char curChar;
    
    string testStringOne = "apple";
    string testStringTwo = "pie";

    StringTapeAccumulator testMe (
        .startIndex(curIndex), .nextStringByte(curChar),
        .rst(rst),.clk(clk),.enable(enable)
    );
    task doCompare();
        foreach(expected[i]) begin
            if(testMe.ram.ram[i] != expected[i])begin
                $display ("ERROR Does not mtach at index %0d", i);
                $display ("Expected %d, got %d", expected[i], testMe.ram.ram[i]);
            end
            if (expectedIndex != curIndex)begin
                $display ("ERROR Tape Indicies Do Not Match!!");
                $display ("Expected %d, got %d", expectedIndex, curIndex);
            end
        end
    endtask

    task runTest ();
        foreach (expected[i]) expected[i] = 'x;
        expectedIndex = 56'd0;
        doCompare();
        
        enable <= 1'b1;
        // google says this might work
        foreach (testStringOne[i]) begin
            curChar <= testStringOne[i]; #10;
        end
        enable = 1'b0; #30;
        
        expectedIndex = 56'd10; 
        expected[0:9] = '{5, 0, 0, 0, "a","p","p","l","e",0};
        doCompare();

        // now for the next string
        enable <= 1'b1;
        foreach (testStringTwo[i]) begin
            curChar <= testStringTwo[i]; #10;
        end

        enable = 1'b0; #30;
        expected[0:17] = '{5, 0, 0, 0, "a","p","p","l","e",0,3,0,0,0,"p","i","e",0};
        expectedIndex = 56'd18;
        doCompare();
    

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
        curChar <= 8'b0;
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
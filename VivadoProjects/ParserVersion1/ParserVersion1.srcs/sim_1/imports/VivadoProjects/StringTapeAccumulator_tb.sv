// note: an inheriting class-base archectecture would be a good idea,
// but my SV skill aren't there yet

module StringTapeAccumulator_tb ();
    typedef logic [55:0] TapeIndex;
    logic rst, clk, enable;
    logic [7:0] tape [32];
    logic [7:0] expected [32];
    TapeIndex curIndex;
    UTF8_Char curChar;
    
    string testStringOne = "apple";
    string testStringTwo = "pie";

    StringTapeAccumulator testMe (
        .curIndex(curIndex), .nextStringByte(curChar),
        .tape(tape),
        .rst(rst),.clk(clk),.enable(enable)
    );
    task doCompare();
        foreach(tape[i]) begin
            if(tape[i] != expected[i])begin
                $display ("ERROR Does not matach at index %0d", i);
                $display ("Expected %d, got %d", expected[i], tape[i]);
            end
        end
    endtask

    task runTest ();
        foreach (expected[i]) expected[i] = '0;
        enable <= 1'b1;
        // google says this might work
        foreach (testStringOne[i]) begin
            curChar <= testStringOne[i]; #10;
        end
        enable = 1'b0; #10;
        expected[0:10] = '{5, 0, 0, 0, "a","p","p","l","e",0,0};
        doCompare();

        // now for the next string
        enable <= 1'b1;
        foreach (testStringTwo[i]) begin
            curChar <= testStringTwo[i]; #10;
        end

        enable = 1'b0; #10;
        expected[0:20] = '{5, 0, 0, 0, "a","p","p","l","e",0,3,0,0,0,"p","i","e",0,0,0,0};
        doCompare();
    

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
        $finish;
    end

endmodule
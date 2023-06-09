// note: an inheriting class-base archectecture would be a good idea,
// but my SV skill aren't there yet

module StringTapeAccumulator_tb ();
    logic rst, clk, enable;
    logic [7:0] tape [];
    TapeIndex curIndex;
    UTF8_Char curChar;
    
    string testStringOne = "apple";
    string testStringTwo = "pie";

    StringTapeAccumulator testMe (
        .curIndex(curIndex), .nextStringByte(curChar)
        .tape(tape),
        .rst(rst),.clk(clk),.enable(enable)
    );

    task runTest ();


    endtask

    // rest will be standard testbench stuff
    // todo: get it into a class or include or something


    initial begin
        forever begin
            clk = 0; #5
            clk = 1; #5
        end

    end

    inital begin
        rst = 1'b0;
        runTest();
        #30 
        rst = 1'b1; 
        #40
        rst = 0;
        #50;
        // run test twice to ensure reset doesn't leave residue
        runTest();

    end

endmodule
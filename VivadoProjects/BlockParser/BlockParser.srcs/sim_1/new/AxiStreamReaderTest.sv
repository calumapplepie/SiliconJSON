`timescale 1ns / 1ps

module AxiStreamReaderTest import Ram::*; (

    );
    logic clk, enb, rst, TREADY;
    StructBlockRamRead  ramRead;
    StringBlockRamWrite ramWrite;
    
    logic [15:0] transferLen;
    
    // simulate 8-char string reader with the struct data types
    AxiStreamReader #(.WORDSIZE(8), .NUMWORDS(8), .ReadType(StructBlockRamRead), .WriteType(StringBlockRamWrite)) DUV (
        .clk, .enable(enb), .rst, .TREADY, .ramWrite, .ramRead, .TRESET('0), .transferLen
    );
    
    // give 'er a BRAM
    AsymetricBramSharer #(.NUMWORDS(64), .ReadType(StructBlockRamRead), .WriteType(StringBlockRamWrite), .DO_REG(0)) bob (
        .clk, .enb('1), .ramW(ramWrite), .ramR(ramRead)
    );
    
    task runTest();
        rst<='1;TREADY <= '1;
        enb <='0; #20; // two clocks so that things can get all nice and ready
                                        // now lets run it a bit
        enb <= '1; rst <= '0;   #40;    // check the outputs, calum!
        enb <='0;               #20; 
        enb <='1;               #10;    // pulse enable
        TREADY <= '0;           #20; 
        TREADY <='1;            #10;    // pulse TREADY
        enb <='0; TREADY <= '0; #20;    // pulse both TREADY and enable
        TREADY <='1;            #10; 
        enb <='1; rst <='1;     #10; 
        rst <= '0;              #50;    // confirm reset works
        TREADY <= '0;rst <= '1; #10; 
        rst <= '0;              #40;    // confirm reset with TREADY off works
        TREADY <= '1;           #20;
        enb <= '0;              #20;    // disable, confirm bits
        rst <= '1;              #10;    // how about rst with enable off?
        rst <= '0; enb <= '1;   #50;
    endtask
    
    
    initial begin
        #190
        // run the test twice, for Surety
        transferLen = '1;
        runTest(); 
        transferLen = 16'd20;
        runTest();
        $finish();
    end;
    
    initial forever begin
        clk <= '0; #5;
        clk <= '1; #5;
    end
endmodule

module TopLevel import Core::UTF8_Char; (
    input UTF8_Char curChar,
    input GCLK, rst, enable, readSide
);
    assign clk = GCLK;
    
    ParserTop parser (
        .stringRam(readSide ? stringRam[1] : stringRam[0]), 
        .structRam(readSide ? stringRam[1] : stringRam[0]),
        .*
    );
    
    BlockRamConnection #(.WORDSIZE(8), .ADDRWIDTH(14)) stringRam[1:0] ();
    BlockRamConnection #(.WORDSIZE(64))                structRam[1:0]     ();

    TapeStorage storage[1:0] ( .*);
    
    

endmodule
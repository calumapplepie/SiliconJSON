module TopLevel import Core::UTF8_Char; (
    input UTF8_Char curChar,
    input GCLK, rst, enable
);
    assign clk = GCLK;
    
    ParserTop parser (.*);
    
    BlockRamConnection #(.WORDSIZE(8), .ADDRWIDTH(14)) stringRam ();
    BlockRamConnection #(.WORDSIZE(64))                structRam     ();

    TapeStorage storage ( .*);

endmodule
module TopLevel import Core::UTF8_Char; (
    input UTF8_Char curChar,
    input GCLK, rst, enable, readSide,
    output logic [63:0] curStructBits,
    output logic [7:0]  curStringBits
);
    assign clk = GCLK;
    
    ParserTop parser (
        .stringRam(readSide ? stringRam[0] : stringRam[1]), 
        .structRam(readSide ? structRam[0] : structRam[1]),
        .*
    );
    
    BlockRamConnection #(.WORDSIZE(8), .ADDRWIDTH(14)) stringRam[1:0] ();
    BlockRamConnection #(.WORDSIZE(64))                structRam[1:0] ();

    TapeStorage storage[1:0] ( .*);
    
    BlockReader #(8) stringReader (.ram(readSide ? stringRam[1] : stringRam[0]), .data(curStringBits), .*);
    BlockReader #(64)structReader (.ram(readSide ? structRam[1] : structRam[0]), .data(curStructBits), .*);

endmodule
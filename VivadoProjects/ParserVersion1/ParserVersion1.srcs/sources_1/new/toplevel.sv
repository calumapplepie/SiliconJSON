module TopLevel import Core::UTF8_Char; (
    input UTF8_Char curChar,
    input GCLK, rst, enable, readSide,
    output logic [63:0] curStructBits,
    output logic [7:0]  curStringBits
);
    assign clk = GCLK;
        
    Ram::StringBlockRamWrite parserStringWrite, readerStringWrite;
    Ram::StructBlockRamWrite parserStructWrite, readerStructWrite;
    
    Ram::StringBlockRamRead  readerStringRead;
    Ram::StructBlockRamRead  readerStructRead;
        
    ParserTop parser (
        .stringRam(parserStringWrite), 
        .structRam(parserStructWrite),
        .*
    );
    
    TapeStorage storage ();
    
    BlockReader #(8) stringReader (.ramWrite(readerStringWrite), .ramRead(readerStringRead), .data(curStringBits), .*);
    BlockReader #(64)structReader (.ramWrite(readerStructWrite), .ramRead(readerStructRead), .data(curStringBits), .*);

endmodule
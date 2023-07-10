module TopLevel import Core::UTF8_Char; (
    input UTF8_Char curChar,
    input GCLK, rst, enable, readSide,
    output logic [63:0] curStructBits,
    output logic [7:0]  curStringBits
);
    assign clk = GCLK;
    
    Ram::StringBlockRamWrite stringRam [1:0];
    Ram::StructBlockRamWrite structRam [1:0];
    
    Ram::StringBlockRamWrite parserStringRam, readerStringRam;
    Ram::StructBlockRamWrite parserStructRam, readerStructRam;
    
    assign parserStringRam = !readSide ? stringRam[1] : stringRam [0];
    assign parserStructRam = !readSide ? structRam[1] : structRam [0];
    
    ParserTop parser (
        .stringRam(parserStringRam), 
        .structRam(parserStructRam),
        .*
    );
    
    TapeStorage storage[1:0] (.stringRam(stringRam), .structRam(structRam), .*);
    
    assign readerStringRam = readSide ? stringRam[1] : stringRam [0];
    assign readerStructRam = readSide ? structRam[1] : structRam [0];
    
    BlockReader #(8) stringReader (.ram(readerStringRam), .data(curStringBits), .*);
    BlockReader #(64)structReader (.ram(readerStructRam), .data(curStructBits), .*);

endmodule
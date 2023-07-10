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
    
    logic selectParser = !readSide;
    logic selectReader = readSide; 
  
    TapeStorage storage (.selectParser(!readSide), .selectReader(readSide), .*);
    
    BlockReader #(.WORDSIZE(8), .WriteType(Ram::StringBlockRamWrite), .ReadType(Ram::StringBlockRamRead)) stringReader (
        .ramWrite(readerStringWrite), .ramRead(readerStringRead), .data(curStringBits), .*
    );
    BlockReader #(.WORDSIZE(64), .WriteType(Ram::StructBlockRamWrite), .ReadType(Ram::StructBlockRamRead)) structReader (
        .ramWrite(readerStructWrite), .ramRead(readerStructRead), .data(curStructBits), .*
    );

endmodule
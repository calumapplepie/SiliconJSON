module TopLevel import Core::UTF8_Char; (
    input UTF8_Char curChar,
    input GCLK, rst, enable, readSide, parseEnable,
    output logic [63:0] curStructBits,
    output logic [31:0]  curStringBits
);
    assign clk = GCLK;
        
    (* mark_debug = "true" *) Ram::StringBlockRamWrite parserStringWrite;
    Ram::StringBlockRamWrite readerStringWrite;
    (* mark_debug = "true" *) Ram::StructBlockRamWrite parserStructWrite;
    Ram::StructBlockRamWrite readerStructWrite;
    
    Ram::StringBlockRamRead  readerStringRead;
    Ram::StructBlockRamRead  readerStructRead;
        
    ParserTop parser (
        .stringRam(parserStringWrite), 
        .structRam(parserStructWrite),
        .enable(parseEnable && enable),
        .*
    );
      
    TapeStorage storage (.selectParser(!readSide), .selectReader(readSide), .*);

    SinglePulser pulsey (.clk, .din(enable), .d_pulse(readerEnable));

    BlockReader #(.WORDSIZE(32), .JUMPSIZE(4),.WriteType(Ram::StringBlockRamWrite), .ReadType(Ram::StringBlockRamRead)) stringReader (
        .ramWrite(readerStringWrite), .ramRead(readerStringRead), .data(curStringBits), .enable(enable), .*
    );
    BlockReader #(.WORDSIZE(64), .WriteType(Ram::StructBlockRamWrite), .ReadType(Ram::StructBlockRamRead)) structReader (
        .ramWrite(readerStructWrite), .ramRead(readerStructRead), .data(curStructBits), .enable(readerEnable), .*
    );

endmodule
module TopLevel import Core::UTF8_Char; (
    input UTF8_Char curChar,
    input GCLK, rst, enable, readSide,
    output logic [63:0] curStructBits,
    output logic [7:0]  curStringBits
);
    assign clk = GCLK;
    BlockRamConnection #(.WORDSIZE(8), .ADDRWIDTH(14)) stringRam[1:0] ();
    BlockRamConnection #(.WORDSIZE(64))                structRam[1:0] ();
    BlockRamConnection #(.WORDSIZE(8), .ADDRWIDTH(14)) parserStringRam ();
    BlockRamConnection #(.WORDSIZE(64))                parserStructRam ();
    BlockRamConnection #(.WORDSIZE(8), .ADDRWIDTH(14)) readerStringRam ();
    BlockRamConnection #(.WORDSIZE(64))                readerStructRam ();
    
    
    ParserTop parser (
        .stringRam(parserStringRam), 
        .structRam(parserStructRam),
        .*
    );
    
    BlockRamConnectionMux #2 why       (stringRam[1:0],  readSide, parserStringRam) ;
    BlockRamConnectionMux #2 arent     (structRam[1:0],  readSide, parserStructRam) ;
    BlockRamConnectionMux #2 interfacee(stringRam[1:0], !readSide, readerStringRam) ;
    BlockRamConnectionMux #2 muxesReal (structRam[1:0], !readSide, readerStructRam) ;
    


    TapeStorage storage[1:0] (.stringRam(stringRam), .structRam(structRam), .*);
    
    BlockReader #(8) stringReader (.ram(readerStringRam), .data(curStringBits), .*);
    BlockReader #(64)structReader (.ram(readerStructRam), .data(curStructBits), .*);

endmodule
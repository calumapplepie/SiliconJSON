package Ram;

    typedef struct {
        logic ena, enb, wea,web;
        logic [$clog2(Core::StringTapeLength):0] addra,addrb;
        logic [7:0] dia,dib;
    } StringBlockRamWrite;
    
    typedef struct {
        logic ena, enb, wea,web;
        logic [$clog2(Core::StructTapeLength):0] addra,addrb;
        logic [63:0] dia,dib;
    } StructBlockRamWrite;
    
    typedef struct {
        logic [7:0] doa,dob;
    } StringBlockRamRead;
    
    typedef struct {
        logic [63:0] doa,dob;
    } StructBlockRamRead;
    
    


endpackage
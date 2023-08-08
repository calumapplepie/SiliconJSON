

package Ram;
    typedef struct {
        logic ena, enb, wea,web;
        logic [$clog2(Core::StringTapeLength)-1:0] addra,addrb;
        logic [7:0] dia,dib;
    } StringBlockRamWrite;
    
    typedef struct {
        logic ena, enb, wea,web;
        logic [$clog2(Core::MaxInputLength)-1:0] addra,addrb;
        logic [31:0] dia,dib;
    } InputBlockRamWrite;
    
    typedef struct {
        logic ena, enb, wea,web;
        logic [$clog2(Core::StructTapeLength)-1:0] addra,addrb;
        logic [63:0] dia, dib;
    } StructBlockRamWrite;
    
    typedef struct {
        logic ena, enb, wea,web;
        logic [$clog2(Core::IndexTapeLength)-1:0] addra,addrb;
        logic [31:0] dia, dib;
    } IndexBlockRamWrite;
    
    typedef struct {
        logic ena, enb, wea,web;
        logic [$clog2(Core::MaxInputLength/8)-1:0] addra,addrb;
        logic [3:0] dia, dib;
    } BitmapBlockRamWrite;    
      
    typedef struct {
        logic [7:0] doa,dob;
    } InputBlockRamRead;
    
    typedef struct {
        logic [15:0] doa,dob;
    } IndexBlockRamRead;
    
    typedef struct {
        logic [15:0] doa,dob;
    } BitmapBlockRamRead;
    
    typedef struct {
        logic [31:0] doa,dob;
    } StringBlockRamRead;
    
    typedef struct {
        logic [63:0] doa,dob;
    } StructBlockRamRead;
    

endpackage
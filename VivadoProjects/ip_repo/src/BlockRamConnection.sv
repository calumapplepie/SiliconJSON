 // this is a global include because of course it has to be because Vivado gonna Vivado 
 interface BlockRamConnection #(WORDSIZE=8, ADDRWIDTH=9)();
        logic ena, enb, wea,web;
        logic [ADDRWIDTH-1:0] addra,addrb;
        logic [WORDSIZE-1:0] dia,dib;
        logic [WORDSIZE-1:0] doa,dob;
        logic hash;
        modport owner (input  ena, enb, wea, web, addra, addrb, dia, dib, output doa, dob, hash);
        modport user  (output ena, enb, wea, web, addra, addrb, dia, dib, input  doa, dob, hash);
endinterface : BlockRamConnection
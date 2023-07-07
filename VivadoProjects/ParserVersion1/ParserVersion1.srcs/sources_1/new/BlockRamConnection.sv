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

// yes I apparently do have to explicitly code a mux for an interface
module BlockRamConnectionMux #(WIDTH) (
        BlockRamConnection.user IN [WIDTH -1:0] ,
        input logic [$clog2(WIDTH):0] S,
        BlockRamConnection.owner Q
    );
        

    // you know its bad when you're looking at usenet archives (i think?) for help
    // https://comp.lang.verilog.narkive.com/MWc5ESFR/system-verilog-multiplexing-an-array-of-interfaces
    // the worst part is, that isn't even complete!
    // if this works, post it as an answer on stack overflow
    // https://stackoverflow.com/questions/39036710/systemverilog-interface-multiplexer
    genvar i;
    generate 
        for( i = 0; i < WIDTH; i++) begin:genloop
            assign IN[i].ena = i==S ? Q.ena : 'x;
            assign IN[i].enb = i==S ? Q.enb : 'x;
            assign IN[i].wea = i==S ? Q.wea : 'x;
            assign IN[i].web = i==S ? Q.web : 'x;
            assign IN[i].addra = i==S ? Q.addra : 'x;
            assign IN[i].addrb = i==S ? Q.addrb : 'x;
            assign IN[i].dia = i==S ? Q.dia : 'x;
            assign IN[i].dib = i==S ? Q.dib : 'x;
            assign Q.doa =  i==S ? IN[i].doa : 'x;
            assign Q.doa =  i==S ? IN[i].doa : 'x;
        end:genloop 
    endgenerate

    
    
endmodule
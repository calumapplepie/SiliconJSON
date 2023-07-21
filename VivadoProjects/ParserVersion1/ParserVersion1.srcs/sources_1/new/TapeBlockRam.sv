// Dual-Port Block RAM with Two Write Ports
// File: rams_tdp_rf_rf.v

// 7 Series TDP rams are capable of all kinds of nonsense.  Each read and write port can be different.
// while I could use Xylinx libraries, I kind of don't want to, for copyright reasons.  Bad enough I carried the
// initial version of this file over.
// Also, IF inference works properly, then this model is more generalizable; i don't need to worry so much about
// how to divide this among block rams
module TapeBlockRam #(
            WORDSIZE=8, WORDSIZE_IN=WORDSIZE, WORDSIZE_OUT=WORDSIZE, // default to symetric, but allow asymetric reading  
            NUMWORDS=64, ADDRWIDTH=$clog2(NUMWORDS)) (
    input logic clk, ena, enb, wea,web, 
    input [ADDRWIDTH-1:0] addra,addrb, 
    input [WORDSIZE_IN-1:0] dia,dib,
    output logic [WORDSIZE_OUT-1:0] doa,dob
);

// maybe in is big, maybe out is big; user chooses
localparam WORDSIZE_RAM = WORDSIZE_IN > WORDSIZE_OUT ? WORDSIZE_OUT : WORDSIZE_IN;
logic [WORDSIZE_RAM-1:0] ram [0:NUMWORDS-1];

localparam READ_RATIO   =  WORDSIZE_OUT / WORDSIZE_RAM;
localparam WRITE_RATIO  =  WORDSIZE_IN  / WORDSIZE_RAM;


// canary-ify ram on initialization
// however, we assume the RAM is initialized to 0 in stack, so zero it in some places 
initial begin 
    foreach(ram[i]) ram[i] = {WORDSIZE_RAM/8{8'hBA}};
    ram[NUMWORDS-1] = '0;
    ram[0]          = '0; 
end

always_ff @(posedge clk) begin
    if (ena) begin
        if (wea) begin
            if (WRITE_RATIO == 1) ram[addra] <= dia;
            else for(integer i = 0; i < WRITE_RATIO; i++) begin
                automatic logic [$clog2(WRITE_RATIO)-1:0] lower_addr_bits = i;
                automatic logic [ADDRWIDTH-1:0] address = {addra[ADDRWIDTH-1:$clog2(WRITE_RATIO)], lower_addr_bits};
                ram[address] <= dia[(i+1)*WORDSIZE_RAM-1 -: WORDSIZE_RAM]; // saw this in the xylinx docs and wondered what it was; now I know!
            end
        end
        
        if(READ_RATIO == 1) doa <= ram[addra];
        else for(integer i = 0; i < READ_RATIO; i++) begin
            automatic logic [$clog2(READ_RATIO)-1:0] lower_addr_bits = i;
            automatic logic [ADDRWIDTH-1:0] address = {addra[ADDRWIDTH-1:$clog2(READ_RATIO)], lower_addr_bits};
            doa[(i+1)*WORDSIZE_RAM-1 -: WORDSIZE_RAM] <= ram[address]; // saw this in the docs and wondered what it was; now I know!
        end
        
    end
end

always_ff @(posedge clk) begin
    if (enb) begin
        if (web) begin
            if (WRITE_RATIO == 1) ram[addrb] <= dib;
            else for(integer i = 0; i < WRITE_RATIO; i++) begin
                automatic logic [$clog2(WRITE_RATIO)-1:0] lower_addr_bits = i;
                automatic logic [ADDRWIDTH-1:0] address = {addrb[ADDRWIDTH-1:$clog2(WRITE_RATIO)], lower_addr_bits};
                ram[address] <= dib[(i+1)*WORDSIZE_RAM-1 -: WORDSIZE_RAM]; // saw this in the xylinx docs and wondered what it was; now I know!
            end
        end
        
        if(READ_RATIO == 1) dob <= ram[addrb];
        else for(integer i = 0; i < READ_RATIO; i++) begin
            automatic logic [$clog2(READ_RATIO)-1:0] lower_addr_bits = i;
            automatic logic [ADDRWIDTH-1:0] address = {addrb[ADDRWIDTH-1:$clog2(READ_RATIO)], lower_addr_bits};
            dob[(i+1)*WORDSIZE_RAM-1 -: WORDSIZE_RAM] <= ram[address]; // saw this in the docs and wondered what it was; now I know!
        end
        
    end
end

endmodule
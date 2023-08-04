`timescale 1ns / 1ps


// Coordinates what BRAM's are connected to what inputs
// owns all the BRAMs.  Carefully coded to avoid triggering
// https://support.xilinx.com/s/question/0D54U000076hQ0GSAU/intermittent-struct-member-access-misbehavior?language=en_US
module BramOrchestrator #(NUMWORDS=4096, DO_REG=1, type ReadType, type WriteType ) (
        input  WriteType    write1, write2, write3,
        output ReadType     read1,  read2,  read3,
        input logic [3:0]   sel1,   sel2,   sel3,
        input logic         enb1='0,enb2='0,enb3='0,
        input logic clk
    );
    // note: currently just wraps one BRAM and assumes no parallel stuff
    // final verison will want a generate block, but lets KISS for now
    // tho i did fail to resist the urge to make such a block easy to add
    
    // Undefined vars that we assign to various in's and outs
    localparam WriteType undefWrite = '{default:'x}; // don't care: BRAM not in use, can have any input
    localparam ReadType  undefRead  = '{default:'z}; // high-impedance: we don't write to this port from here, but may write elsewhere
    
    integer i = 0;
    WriteType selectedWrite;
    ReadType  selectedRead;
    logic     enableThis;
    // should this BRAM be enabled at all?
    assign    enableThis =  (sel1==i && enb1) || (sel2==i && enb2) || (sel3==i && enb3);
    
    // todo: consider breaking this apart into distinct assign statements, to avoid priority encoder
    assign selectedWrite = !enableThis? undefWrite    : ( 
                            sel1 == i ? write1 : (
                            sel2 == i ? write2 : (
                            sel3 == i ? write3 : undefWrite)));
                            
    // I'm fairly sure vivado supports this: see IEEE Std 1800 6.6.1
    assign read1 = sel1 == i ? selectedRead : undefRead;  
    assign read2 = sel2 == i ? selectedRead : undefRead;
    assign read3 = sel3 == i ? selectedRead : undefRead;
    
    AsymetricBramSharer #(.ReadType(ReadType), .WriteType(WriteType), .DO_REG(DO_REG), .NUMWORDS(NUMWORDS)) ram(
        .clk, .enb(enableThis), .ramW(selectedWrite), .ramR(selectedRead)
    );
    
    
    
endmodule

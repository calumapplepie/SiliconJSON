#include "DmaJsonDriver.h"
#include "xparameters.h"
#include "xmcdma.h"
#include <cstdint>

// why yes this was inspired by Xylinx examples available online
// i use the bits of their structure that don't seem like BS

// convenience macro gives the full XPARAMETERS name of a given id
// because they have a standard prefix, writing it over and over again is a lot,
// and what if someone wants 2 MCDMAs?
#define XPARAM(NAME)   XPAR_AXI_MCDMA_0_ ## NAME 

// we store the BD's here, with a little extra buffer just in case
// note: maybe use LD script to... not do this?
static XMcdma_Bd BD_BUF [2*(XPARAM(NUM_MM2S_CHANNELS)  + XPARAM(NUM_S2MM_CHANNELS) + 4)];
static XMcdma_Bd* BD_BUF_POS = BD_BUF;

// actual object
XMcdma AxiMcdma;

void setupTx(XMcdma* McDmaInstPtr){ 
    for (int ChanId = 1; ChanId <= XPARAM(NUM_MM2S_CHANNELS); ChanId++){ 
        XMcdma_ChanCtrl *Tx_Chan = XMcdma_GetMcdmaTxChan(McDmaInstPtr, ChanId);

        /* Disable all interrupts */
		XMcdma_IntrDisable(Tx_Chan, XMCDMA_IRQ_ALL_MASK);
        
        Xil_AssertVoid(  XMcDma_ChanBdCreate(Tx_Chan, (uintptr_t) BD_BUF_POS, 2) );
        BD_BUF_POS++;

        // they botched their copy-paste and re-enable interrupts here in the polled example
    }
}

void setupRx(){

}


// Set up the driver and the ip
void init_driver(){
	XMcdma_Config* Mcdma_Config = XMcdma_LookupConfig(XPARAM(DEVICE_ID));
    int status;
    Xil_AssertVoid( XMcDma_CfgInitialize(&AxiMcdma, Mcdma_Config) );




}

// send a json document to be parsed
void queue_doc(JsonDoc &doc){
    // NOTE: we must select the highest unused priority
    // HW doesn't yet support stream switching mid packet (yet)

}
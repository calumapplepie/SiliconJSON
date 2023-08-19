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
// note: maybe usethe LD script to... not do this?
static XMcdma_Bd BD_BUF_TX [(XPARAM(NUM_MM2S_CHANNELS) + 1)][2];
static XMcdma_Bd BD_BUF_RX [(XPARAM(NUM_S2MM_CHANNELS) + 1)][2];

// note: xylinx seems to have a very buggy driver; eg, it never sets TLAST.
// will need to fix/work around

// actual object
XMcdma AxiMcdma;

void setupTx(XMcdma* McDmaInstPtr){ 
    for (int ChanId = 1; ChanId <= XPARAM(NUM_MM2S_CHANNELS); ChanId++){ 
        XMcdma_ChanCtrl *Tx_Chan = XMcdma_GetMcdmaTxChan(McDmaInstPtr, ChanId);

        /* Disable all interrupts */
		XMcdma_IntrDisable(Tx_Chan, XMCDMA_IRQ_ALL_MASK);
        
        Xil_AssertVoid(  XMcDma_ChanBdCreate(Tx_Chan, (uintptr_t) BD_BUF_TX[ChanId-1], 2) );

        // they botched their copy-paste and re-enable interrupts here in the polled example
    }
}

void setupRx(XMcdma* McDmaInstPtr){
    for (int ChanId = 1; ChanId <= XPARAM(NUM_S2MM_CHANNELS); ChanId++){ 
        XMcdma_ChanCtrl *Rx_Chan = XMcdma_GetMcdmaRxChan(McDmaInstPtr, ChanId);

        /* Disable all interrupts */
		XMcdma_IntrDisable(Rx_Chan, XMCDMA_IRQ_ALL_MASK);
        
        Xil_AssertVoid(  XMcDma_ChanBdCreate(Rx_Chan, (uintptr_t) BD_BUF_RX[ChanId-1], 2) );

        // they botched their copy-paste and re-enable interrupts here in the polled example
    }
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
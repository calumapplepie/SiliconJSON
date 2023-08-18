#include "DmaJsonDriver.h"
#include "xparameters.h"
#include "xmcdma.h"

// convenience macro gives the full XPARAMETERS name of a given id
// because they have a standard prefix, writing it over and over again is a lot,
// and what if someone wants 2 MCDMAs?
#define XPARAM(NAME)   XPAR_AXI_MCDMA_0_ ## NAME 


#define NUM_TX_BDS 1
#define NUM_RX_BDS 1

// we store the BD's here, with a little extra buffer just in case
// note: maybe use LD script to... not do this?
static XMcdma_Bd BD_BUF [NUM_TX_BDS * XPARAM(NUM_MM2S_CHANNELS)  + NUM_RX_BDS* XPARAM(NUM_S2MM_CHANNELS) + 4];
static XMcdma_Bd* BD_BUF_POS = BD_BUF;

// actual object
XMcdma AxiMcdma;

void setupTx(){

}

void setupRx(){

}


// Set up the driver and the ip
void init_driver(){
	XMcdma_Config* Mcdma_Config = XMcdma_LookupConfig(XPARAM(DEVICE_ID));
    int status;
    XMcDma_CfgInitialize(&AxiMcdma, Mcdma_Config);


}

// send a json document to be parsed
void queue_doc(JsonDoc &doc){
    // NOTE: we must select the highest unused priority
    // HW doesn't yet support stream switching mid packet (yet)

}
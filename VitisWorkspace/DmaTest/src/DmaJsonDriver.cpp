#include "DmaJsonDriver.h"
#include "xil_assert.h"
#include "xil_types.h"
#include "xmcdma_bd.h"
#include "xparameters.h"
#include "xmcdma.h"
#include <cstdint>
#include <bitset>
#include <array>

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

// note: xylinx seems to have a very buggy driver; we have to make it set TLAST ourselves. Bleh.
// will need to work around

// actual object
XMcdma AxiMcdma;

// only have one document per channel.
std::bitset<XPARAM(NUM_MM2S_CHANNELS)> BusyChannels;

void setupTx(XMcdma* McDmaInstPtr){ 
    for (int ChanId = 1; ChanId <= XPARAM(NUM_MM2S_CHANNELS); ChanId++){ 
        XMcdma_ChanCtrl *Tx_Chan = XMcdma_GetMcdmaTxChan(McDmaInstPtr, ChanId);

        /* Disable all interrupts */
		XMcdma_IntrDisable(Tx_Chan, XMCDMA_IRQ_ALL_MASK);
        
        Xil_AssertVoid(  XMcDma_ChanBdCreate(Tx_Chan, (uintptr_t) BD_BUF_TX[ChanId-1], 2) );

        // they botched their copy-paste and re-enable interrupts here in the polled example
        // also the whole rest of the polled example for tx is just... rx, with *some* character changes
        // ALSO also they do stuff in setup and then again in send packet... ugh...
    }
}

void setupRx(XMcdma* McDmaInstPtr){
    for (int ChanId = 1; ChanId <= XPARAM(NUM_S2MM_CHANNELS); ChanId++){ 
        XMcdma_ChanCtrl *Rx_Chan = XMcdma_GetMcdmaRxChan(McDmaInstPtr, ChanId);

        /* Disable all interrupts */
		XMcdma_IntrDisable(Rx_Chan, XMCDMA_IRQ_ALL_MASK);
        
        Xil_AssertVoid(  XMcDma_ChanBdCreate(Rx_Chan, (uintptr_t) BD_BUF_RX[ChanId-1], 2) );
    }
}


// Set up the driver and the ip
void init_driver(){
	XMcdma_Config* Mcdma_Config = XMcdma_LookupConfig(XPARAM(DEVICE_ID));
    int status;
    Xil_AssertVoid( XMcDma_CfgInitialize(&AxiMcdma, Mcdma_Config) );
    setupTx(&AxiMcdma);
    setupRx(&AxiMcdma);
}

int getFirstFreeChanID(){
    for(int i = 0; i <BusyChannels.size(); i++){
        if(BusyChannels[i] == 0) {return i+1;}
    }
    return -1;
}

void setupDocSendBuf(JsonDoc &doc, int channelID){
    XMcdma_ChanCtrl* channel = XMcdma_GetMcdmaTxChan(&AxiMcdma, channelID);
    Xil_AssertVoid(  // make sure problems don't happen
        XMcDma_ChanSubmit(channel, 
        (UINTPTR) const_cast<char*>(doc.unparsed.c_str()),  // cast away const-ness
        doc.unparsed.length())  );
    // TODO: make the hardware use the cache-coherent port, avoid CPU-driven cache flushes and invalidations
    // use an interconnect to shove them all on one port
    // when you do, be careful to also reduce burst size: otherwise CPU is hurt :(
    if(channel->BdHead == channel->BdTail){
        XMcDma_BdSetCtrl(channel->BdHead, XMCDMA_BD_CTRL_EOF_MASK & XMCDMA_BD_CTRL_SOF_MASK);
    }
    else {
        XMcDma_BdSetCtrl(channel->BdHead, XMCDMA_BD_CTRL_SOF_MASK);
        XMcDma_BdSetCtrl(channel->BdTail, XMCDMA_BD_CTRL_EOF_MASK);
    }

    // fire it off!
    Xil_AssertVoid(XMcDma_ChanToHw(channel));

}

void setupDocRecvBuf(JsonDoc &doc, int channelID){
    XMcdma_ChanCtrl* strChannel = XMcdma_GetMcdmaTxChan(&AxiMcdma, channelID);
    XMcdma_ChanCtrl* layChannel = XMcdma_GetMcdmaTxChan(&AxiMcdma, channelID+8);
    Xil_AssertVoid( 
        XMcDma_ChanSubmit(strChannel, 
        (UINTPTR) doc.str_buf.get(), 
        doc.lay_buf_len)  );
    Xil_AssertVoid(  
        XMcDma_ChanSubmit(layChannel, 
        (UINTPTR) doc.lay_buf.get(),  
        doc.str_buf_len)  );
    Xil_AssertVoid(XMcDma_ChanToHw(strChannel));
    Xil_AssertVoid(XMcDma_ChanToHw(layChannel));


}

// send a json document to be parsed
void queue_doc(JsonDoc &doc){
    // NOTE: we must select the highest unused priority
    // HW doesn't yet support stream switching mid packet (yet)
    int chanID = getFirstFreeChanID();
    Xil_AssertVoid(chanID > 0);
    // set up receive first to ensure its ready before we send
    setupDocRecvBuf(doc, chanID);
    setupDocSendBuf(doc, chanID);
}

int poll_finished(){
    auto Chan_SerMask = XMcdma_ReadReg(AxiMcdma.Config.BaseAddress,
                                      XMCDMA_RX_OFFSET + XMCDMA_RXCH_SER_OFFSET);

    for(int i = 0; i < XPARAM(NUM_MM2S_CHANNELS); i++){
        if(Chan_SerMask & (1 << (i + 8))){
            XMcdma_ChanCtrl* layChannel = XMcdma_GetMcdmaRxChan(&AxiMcdma, i+8);
            XMcdma_Bd* layoutBD;
            int numDone = XMcdma_BdChainFromHW(layChannel,
                                                1,
                                                &layoutBD);
            if(numDone){
                // factor out into separate function sometime
                XMcdma_BdChainFree(layChannel, 1, layoutBD);
                
                // read n clear other BDs
                XMcdma_Bd* strBD;
                XMcdma_ChanCtrl* strChannel = XMcdma_GetMcdmaRxChan(&AxiMcdma, i);
                XMcdma_BdChainFromHW(strChannel,1,&layoutBD);
                XMcdma_BdChainFree(strChannel, 1,layoutBD);

                XMcdma_Bd* inputBD;
                XMcdma_ChanCtrl* inChannel = XMcdma_GetMcdmaTxChan(&AxiMcdma, i);
                XMcdma_BdChainFromHW(inChannel,1,&inputBD);
                XMcdma_BdChainFree(inChannel, 1,inputBD);

                
                
                // todo: use the "actual length" information


                return i; // can only handle 1 channel at a time
            }       
        }
    }
    return -1;
}
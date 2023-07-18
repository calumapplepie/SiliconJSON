/*
 * LED_test.c
 *
 *  Created on: 	13 June 2013
 *      Author: 	Ross Elliot
 *     Version:		1.1
 */
 
/********************************************************************************************
* VERSION HISTORY
********************************************************************************************
* v1.1 - 27 January 2014
* 	GPIO_DEVICE_ID definition updated to reflect new naming conventions in Vivado 2013.3
*		onwards.
*
*	v1.0 - 13 June 2013
*		First version created.
*******************************************************************************************/

/********************************************************************************************
 * This file contains an example of using the GPIO driver to provide communication between
 * the Zynq Processing System (PS) and the AXI GPIO block implemented in the Zynq Programmable
 * Logic (PL). The AXI GPIO is connected to the LEDs on the ZedBoard.
 *
 * The provided code demonstrates how to use the GPIO driver to write to the memory mapped AXI
 * GPIO block, which in turn controls the LEDs.
 ********************************************************************************************/

/* Include Files */
#include "xparameters.h"
#include "xgpio.h"
#include "xstatus.h"
#include "xil_printf.h"

/* Definitions */
#define PL_DELAY 600	     						/* Software delay length */
#define printf xil_printf							/* smaller, optimised printf */
#define STRING_TAPE_LEN 64
#define LAYOUT_TAPE_LEN 16	// oh my god layout tape is so much nicer i'll have some changes to make


XGpio GpioParserInput;											/* GPIO Device driver instance */
XGpio GpioStructReader;
XGpio GpioStringReader;
char* testDoc1 = "{\"author\":\"calum\"}";
char  parserControlSignal = 0x0;
uint64_t readStructTape [LAYOUT_TAPE_LEN];
char	 readStringTape [STRING_TAPE_LEN]; 

void waitForPL(){
	volatile int Delay;
	for (Delay = 0; Delay < PL_DELAY; Delay++);
}

void pulseEnable(){
	// set enable bit (its the low bit of our control signal)
	XGpio_DiscreteSet(&GpioParserInput, 2, 0x1);

	/* Let PL read high enable */
	waitForPL();

	// clear enable bit 
	XGpio_DiscreteClear(&GpioParserInput, 2, 0x1);
	/* Let PL read low enable */
	waitForPL();
}

void resetPL(){
	XGpio_DiscreteSet(&GpioParserInput, 2, 0x2);
	waitForPL();
	XGpio_DiscreteClear(&GpioParserInput, 2, 0x2);
}

void provideParserInput(char* testDoc){
	int i = 0;
	while (testDoc[i]) { // go to null terminator
		/* Write to parser */
		XGpio_DiscreteWrite(&GpioParserInput, 1, testDoc[i]);
		// pulse the enable bit
		pulseEnable();
		i++;
	}
	// give it three pulses for good luck and/or pipeline clearing
	pulseEnable();
	pulseEnable();
	pulseEnable();
}

void readParserOutput(){
	for(int i = 0; i < STRING_TAPE_LEN; i++){
		// set enable, let PL update vals
		pulseEnable();

		if(i<LAYOUT_TAPE_LEN){
			uint64_t readElement = 	XGpio_DiscreteRead(&GpioStructReader, 2);	// higher bits of struct tape
			readElement <<= 32; // shift to make space
			readElement += XGpio_DiscreteRead(&GpioStructReader, 1);
			readStructTape[i] = readElement;
		}
		uint8_t readString = XGpio_DiscreteRead(&GpioStringReader,1);
		readStringTape[i] = readString;
	}
}

int LEDOutputExample(void){
	int Status;

	/* GPIO driver initialization */
	Status = XGpio_Initialize(&GpioParserInput, XPAR_AXI_GPIO_0_DEVICE_ID);
	Status |= XGpio_Initialize(&GpioStructReader, XPAR_AXI_GPIO_1_DEVICE_ID);
	Status |= XGpio_Initialize(&GpioStringReader, XPAR_AXI_GPIO_2_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*Set the direction for the various chanels*/
	XGpio_SetDataDirection(&GpioParserInput, 1, 0x00);			// current character
	XGpio_SetDataDirection(&GpioParserInput, 2, 0x00);			// control
	XGpio_SetDataDirection(&GpioStructReader, 1, 0xFFFFFFFF);	// lower bits of struct tape
	XGpio_SetDataDirection(&GpioStructReader, 2, 0xFFFFFFFF);	// higher bits of struct tape
	XGpio_SetDataDirection(&GpioStringReader, 1, 0xFFFFFFFF);	// string tape bits

	// set the parsercontrol byte to our starting value
	// Byte is: [0,0,0,0,ParseEnable, ReadSide, Rst, Enable]
	XGpio_DiscreteWrite(&GpioParserInput, 2, 0b00001000);

	resetPL();
	provideParserInput(testDoc1);
	
	resetPL();
	// swap read/write sides, disable parsing, clear reset
	XGpio_DiscreteWrite(&GpioParserInput, 2, 0b00000100);

	// read document
	readParserOutput();

	// verify (later)


	return XST_SUCCESS; 
}

/* Main function. */
int main(void){
	while(1) {
		xil_printf("Lets get this party STARTED\n");
		/* Execute the LED output. */
		LEDOutputExample();

		xil_printf("okay, struct tape's first few bits are: %x %x %x\n", readStructTape[0],readStructTape[1],readStructTape[2]);
		xil_printf("string tape first string len: %d str: %s\n", readStringTape[0],&readStringTape[4] );
	}
	return 0;
}


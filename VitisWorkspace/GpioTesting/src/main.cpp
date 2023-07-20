/*
 * File loosely based on:
 * BasLED_test.c
 *
 *  Created on: 	13 June 2013
 *      Author: 	Ross Elliot
 *     Version:		1.1
 */


/* Include Files */
#include "xparameters.h"
#include "xgpio.h"
#include "xstatus.h"
#include <cstdio>

#include "ConfigParam.h"
#include "testFiles.h"
#include "SimdjsonStealer.h"

XGpio GpioParserInput;											/* GPIO Device driver instance */
XGpio GpioStructReader;
XGpio GpioStringReader;
char* testDoc1 = "{\"author\":\"calum\"}";
char  parserControlSignal = 0x0;
uint64_t readStructTape [LAYOUT_TAPE_LEN];
char	 readStringTape [STRING_TAPE_LEN];

void static inline waitForPL(){
	// PL appears to be faster than PS
}

void static inline pulseEnable(){
	// set enable bit (its the low bit of our control signal)
	XGpio_DiscreteSet(&GpioParserInput, 2, 0x1);

	/* Let PL read high enable */
	waitForPL();

	// clear enable bit
	XGpio_DiscreteClear(&GpioParserInput, 2, 0x1);
	/* Let PL read low enable */
	waitForPL();
}

void static inline resetPL(){
	XGpio_DiscreteSet(&GpioParserInput, 2, 0x2);
	waitForPL();
	XGpio_DiscreteClear(&GpioParserInput, 2, 0x2);
}

void provideParserInput(char* testDoc){
	int i = 0;
	int maxI = strlen(testDoc);
	while (i < maxI) {
		/* Write to parser */
		uint32_t stringBlock;
		// note: out-of-bounds is acceptable, nothing SHOULD happen after the last character
		memcpy(&stringBlock, testDoc + i, sizeof(uint32_t));

		XGpio_DiscreteWrite(&GpioParserInput, 1, stringBlock);
		// pulse the enable bit
		pulseEnable();
		i+= 4;
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

int testDocument(char* testDoc){
	// set the parser control byte to our starting value
	// Byte is: [0,0,0,0,ParseEnable, ReadSide, Rst, Enable]
	XGpio_DiscreteWrite(&GpioParserInput, 2, 0b00001000);

	resetPL();
	provideParserInput(testDoc);

	resetPL();
	// swap read/write sides, disable parsing, clear reset
	XGpio_DiscreteWrite(&GpioParserInput, 2, 0b00000100);

	// read document
	readParserOutput();

	parse_simdjson(testDoc);
	return verify(readStringTape, readStructTape);
}

int driveTestingCycle(void){
	int Status;

	/* GPIO driver initialization */
	Status = XGpio_Initialize(&GpioParserInput, XPAR_AXI_GPIO_0_DEVICE_ID);
	Status |= XGpio_Initialize(&GpioStructReader, XPAR_AXI_GPIO_1_DEVICE_ID);
	Status |= XGpio_Initialize(&GpioStringReader, XPAR_AXI_GPIO_2_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*Set the direction for the various channels*/
	XGpio_SetDataDirection(&GpioParserInput, 1, 0x00);			// current character
	XGpio_SetDataDirection(&GpioParserInput, 2, 0x00);			// control
	XGpio_SetDataDirection(&GpioStructReader, 1, 0xFFFFFFFF);	// lower bits of struct tape
	XGpio_SetDataDirection(&GpioStructReader, 2, 0xFFFFFFFF);	// higher bits of struct tape
	XGpio_SetDataDirection(&GpioStringReader, 1, 0xFFFFFFFF);	// string tape bits

	// test standard versions
	for(int i = 0; i < numFiles; i++){
		int errors  = testDocument(jsonTestFiles[i]);
		if(errors != 0){
			printf("ERROR ERROR ERROR\n");}
		printf("encountered %d errors in document %d: %s\n", errors,i, jsonTestFilesNames[i]);
	}

	// test minified versions
	for(int i = 0; i < numFiles; i++){
		int errors  = testDocument(jsonTestFilesMinified[i]);
		if(errors != 0){
			printf("ERROR ERROR ERROR\n");}
		printf("encountered %d errors in document %d: %s\n", errors,i, jsonTestFilesNames[i]);
	}


	return XST_SUCCESS;
}

/* Main function. */
int main(void){
	init_simdjson();
	while(1) {
		xil_printf("Lets get this party STARTED\n");
		/* Execute the LED output. */
		driveTestingCycle();

		xil_printf("okay, struct tape's first few bits are: %x %x %x\n", readStructTape[0],readStructTape[1],readStructTape[2]);
		xil_printf("string tape first string len: %d str: %s\n", readStringTape[0],&readStringTape[4] );
	}
	return 0;
}


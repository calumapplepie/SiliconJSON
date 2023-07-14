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
#define LED 0xC3									/* Initial LED value - XX0000XX */
#define PL_DELAY 100000	     						/* Software delay length */
#define LED_CHANNEL 1								/* GPIO port for LEDs */
#define printf xil_printf							/* smaller, optimised printf */

XGpio GpioParserInput;											/* GPIO Device driver instance */
XGpio GpioStructReader;
XGpio GpioStringReader;
char* testDoc1 = "{\"author\":\"calum\"}";
char  parserControlSignal = 0x0;
uint64_t readStructTape [16];
char	 readStringTape [64]; 

void waitForPL(){
	volatile int Delay;
	for (Delay = 0; Delay < PL_DELAY; Delay++);

}

void provideParserInput(char* testDoc){
	int i = 0;
	while (testDoc[++i]) { // go to null terminator
		/* Write to parser */
		XGpio_DiscreteWrite(&GpioParserInput, 1, testDoc1[i]);
		
		// set enable bit (its the low bit of our control signal)
		XGpio_DiscreteSet(&GpioParserInput, 2, 0x1);

		/* Let PL read high enable */
		waitForPL();

		// clear enable bit 
		XGpio_DiscreteClear(&GpioParserInput, 2, 0x1);
		/* Let PL read low enable */
		waitForPL();
	}
}

int LEDOutputExample(void){
	int Status;
	int led = LED; /* Hold current LED value. Initialise to LED definition */

		/* GPIO driver initialisation */
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


		
		// now we signal a reset to the PL
		XGpio_DiscreteSet(&GpioParserInput, 2, 0x2); 
		waitForPL();
		// swap read/write sides, disable parsing, clear reset
		XGpio_DiscreteWrite(&GpioParserInput, 2, 0b00000100);

		// read document




		return XST_SUCCESS; /* Should be unreachable */
}

/* Main function. */
int main(void){

	int Status;
	xil_printf("Lets get this party STARTED");
	/* Execute the LED output. */
	Status = LEDOutputExample();
	if (Status != XST_SUCCESS) {
		xil_printf("GPIO output to the LEDs failed!\r\n");
	}

	return 0;
}


#include "xil_printf.h"
#include "xil_assert.h"

// lets define a callback for all asserts that prints out the assertion
void assertCallback(const char8 *File, s32 Line){
	xil_printf("Error in file %s, line %d", File, Line);
}

int main(){
	// tell xil_assert to print the errors, plz
	Xil_AssertSetCallback (assertCallback);
	xil_printf("Hello World\n\r");
	xil_printf("Successfully ran Hello World application");
    return 0;
}

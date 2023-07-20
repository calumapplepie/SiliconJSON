#ifndef SIMDJSONSTEALER_H
#define SIMDJSONSTEALER_H

#include "xil_printf.h"
#include "simdjson.h"

void init();

void parse(char* inputChars);

int verify(char* stringTape, uint64_t* layoutTape);
#endif

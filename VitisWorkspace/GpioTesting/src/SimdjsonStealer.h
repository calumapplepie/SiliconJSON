#ifndef SIMDJSONSTEALER_H
#define SIMDJSONSTEALER_H

#include "xil_printf.h"
#include "simdjson.h"

void init_simdjson();

void parse_simdjson(char* inputChars);

int  verify(char* stringTape, uint64_t* layoutTape);
#endif

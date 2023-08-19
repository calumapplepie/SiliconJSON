#ifndef DMAJSONDRIVER_H_
#define DMAJSONDRIVER_H_

#include "JsonDoc.h"

// Set up the driver and the ip
void init_driver();

// send a json document to be parsed
void queue_doc(JsonDoc &doc);


#endif /* DMAJSONDRIVER_H_ */
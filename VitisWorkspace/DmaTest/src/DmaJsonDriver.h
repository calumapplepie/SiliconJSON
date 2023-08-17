#ifndef DMAJSONDRIVER_H_
#define DMAJSONDRIVER_H_

// Set up the driver and the ip
void init_driver();

// send a json document to be parsed
void queue_doc(Json_Doc &doc);
// TODO: prioritization for the MCDMA IP, will need to support


#endif /* DMAJSONDRIVER_H_ */

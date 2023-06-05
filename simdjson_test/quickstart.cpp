#include <iostream>
#include "simdjson.h"
using namespace simdjson;
int main(void) {
    dom::parser parser;
    dom::element json = parser.load("twitter.json");
    json.dump_raw_tape(std::cout);
}
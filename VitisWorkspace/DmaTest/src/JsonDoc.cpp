/*
 * JsonDoc.cpp
 *
 *  Created on: Aug 17, 2023
 *      Author: user
 */

#include "JsonDoc.h"
#include <cstdint>

JsonDoc::JsonDoc(std::string in): unparsed(in) {
    str_buf_len = in.length();
    str_buf.reset(new uint8_t[str_buf_len + 4]) // allocate extra for (some) safety
    lay_buf_len = in.length() / 8 + 10;// herusically generate a decent buffer length
    lay_buf.reset(new uint64_t[lay_buf_len + 4]);
}
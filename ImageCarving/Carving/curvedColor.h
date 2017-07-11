//
// Created by lmsgsendnilself on 2017/6/24.
//

#ifndef CURVED_COLOR_H
#define CURVED_COLOR_H
#include <vector>
#include <string>
#include "model.h"

std::vector<RGB> mask(unsigned char* buf, std::vector<CRECT> curveRect, int w, int h);

#endif //CURVED_COLOR_H

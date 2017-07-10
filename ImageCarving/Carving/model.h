//
// Created by lmsgsendnilself on 2017/6/24.
//

#ifndef DATA_MODEL_H
#define DATA_MODEL_H
struct CRECT{
    float top, left, bottom, right;
    CRECT() {
        top = left = bottom = right;
    }
};
struct RGB{
    int r, g, b;
    RGB(){
        r = g = b = 0;
    }
};
#endif //DATA_MODEL_H

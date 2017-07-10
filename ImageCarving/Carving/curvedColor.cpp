
//
// Created by lmsgsendnilself on 2017/6/24.
//
#include "curvedColor.h"
#include "opencv2/opencv.hpp"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <iostream>
#include <iomanip>
#include <dirent.h>

using namespace std;
using namespace cv;

vector<RGB> mask(int *cbuf, vector<CRect> curvedRect, int w, int h){
    int size = w*h;
    vector<RGB> rgbs;
    
    Mat imgData(h, w, CV_8UC4, (unsigned char *) cbuf);
    Mat destImg;
    cvtColor(imgData, destImg, CV_BGRA2GRAY);
    
    Mat result;
    adaptiveThreshold(destImg, result, 255, ADAPTIVE_THRESH_MEAN_C, THRESH_BINARY, 5, 4);
    
    uchar* ptr = imgData.ptr<uchar>(0);
    uchar* ptrgray = result.ptr<uchar>(0);
    int lastBorder0 = -1;
    int lastBorder1 = -1;
    int lastBorder2 = -1;
    int lastBorder3 = -1;
    int lastJ = -1;
    
    for(int i=0;i<curvedRect.size(); i++) {
        int background1 = 0;
        int background2 = 0;
        int background0 = 0;
        int background3 = 0;
        int num = 1;
        int j = curvedRect[i].left;
        
        int fontNum = 1;
        RGB rgb;
        
        while (j<= curvedRect[i].right) {
            lastJ = j;
           
            for (int count = 0; count < 100 && j<=curvedRect[i].right; count++, j++) {
                for (int t = curvedRect[i].top; t< curvedRect[i].bottom; t++) {
                    int m = w * t + j;
                   
                    if(m >= w*h){
                        rgbs.clear();
                        return rgbs;
                    }
                   
                    if (ptrgray[m] == 255) {
                        num ++;
                        background0 += ptr[4*m+0];
                        background1 += ptr[4*m+1];
                        background2 += ptr[4*m+2];
                        background3 += ptr[4*m+3];
                    }
                    
                    if(ptrgray[m] == 0) {
                        fontNum ++;
                        rgb.b += ptr[4*m+0];
                        rgb.g += ptr[4*m+1];
                        rgb.r += ptr[4*m+2];
                    }
                }
            }
            
            int avgBkg0 = background0 / num;
            int avgBkg1 = background1 / num;
            int avgBkg2 = background2 / num;
            int avgBkg3 = background3 / num;
            
            if (lastBorder0 == -1) {
                lastBorder0 = avgBkg0;
                lastBorder1 = avgBkg1;
                lastBorder2 = avgBkg2;
                lastBorder3 = avgBkg3;
            }
#define COLOR_THRESHOLD      50
            if (abs(avgBkg0 - lastBorder0) + abs(avgBkg1 - lastBorder1) + abs(avgBkg2 - lastBorder2) >= COLOR_THRESHOLD ||
                j == curvedRect[i].right {
                while (lastJ <= j) {
                    for (int t = curvedRect[i].top; t< curvedRect[i].bottom; t++) {
                        int m = w * t + lastJ;
                        ptr[4*m+0] = avgBkg0;
                        ptr[4*m+1] = avgBkg1;
                        ptr[4*m+2] = avgBkg2;
                        ptr[4*m+3] = avgBkg3;
                    }
                    lastJ ++;
                }
                    
                background0 = background1 = background2 = background3 = 0;
                num = 1;
                lastBorder0 = avgBkg0;
                lastBorder1 = avgBkg1;
                lastBorder2 = avgBkg2;
                lastBorder3 = avgBkg3;
            } else {
                while (lastJ <= j) {
                    for (int t = curvedRect[i].top; t< curvedRect[i].bottom; t++) {
                        int m = w * t + lastJ;
                        ptr[4*m+0] = lastBorder0;
                        ptr[4*m+1] = lastBorder1;
                        ptr[4*m+2] = lastBorder2;
                        ptr[4*m+3] = lastBorder3;
                        
                    }
                    lastJ ++;
                }
                
                background0 = background1 = background2 = background3 = 0;
                num = 1;
            }
        }
        
        rgb.b /= fontNum;
        rgb.g /= fontNum;
        rgb.r /= fontNum;
        rgbs.push_back(rgb);
        
    }
    
    return rgbs;
}





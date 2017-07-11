//
//  AppDelegate.m
//  ImageCarving
//
//  Created by lmsgsendnilself on 2017/6/29.
//  Copyright © 2017年 p. All rights reserved.
//

#import "ImagePixelConverter.h"

@implementation ImagePixelConverter

+ (unsigned char *)convertImageToBitmap:(UIImage *) image {
	CGImageRef imageRef = image.CGImage;
	
	// Create a bitmap context to draw the uiimage into
	CGContextRef context = [self newBitmapContextFromImage:imageRef];
	
	if(!context) { return NULL; }
	
	size_t width = CGImageGetWidth(imageRef);
	size_t height = CGImageGetHeight(imageRef);
	
	CGRect rect = CGRectMake(0, 0, width, height);
	
	// Draw image into the context to get the raw image data
	CGContextDrawImage(context, rect, imageRef);
	
	// Get a pointer to the data	
	unsigned char *bitmapData = (unsigned char *)CGBitmapContextGetData(context);
	
	// Copy the data and release the memory (return memory allocated with new)
	size_t bytesPerRow = CGBitmapContextGetBytesPerRow(context);
	size_t bufferLength = bytesPerRow * height;
	
	unsigned char *newBitmap = NULL;
	
	if(bitmapData) {
		newBitmap = (unsigned char *)malloc(sizeof(unsigned char) * bytesPerRow * height);
		
		if(newBitmap) {	// Copy the data
			for(int i = 0; i < bufferLength; ++i) {
				newBitmap[i] = bitmapData[i];
			}
		}
		
		free(bitmapData);
	} else {
		NSLog(@"error\n");
	}
	
	CGContextRelease(context);
	
	return newBitmap;	
}

+ (CGContextRef)newBitmapContextFromImage:(CGImageRef) image {
	CGContextRef context = NULL;
	CGColorSpaceRef colorSpace;
	uint32_t *bitmapData;
	
	size_t bitsPerPixel = 32;
	size_t bitsPerComponent = 8;
	size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
	
	size_t width = CGImageGetWidth(image);
	size_t height = CGImageGetHeight(image);
	
	size_t bytesPerRow = width * bytesPerPixel;
	size_t bufferLength = bytesPerRow * height;
	
	colorSpace = CGColorSpaceCreateDeviceRGB();
	
	if(!colorSpace) {
		NSLog(@"error\n");
		return NULL;
	}
	
	// Allocate memory for image data
	bitmapData = (uint32_t *)malloc(bufferLength);
	
	if(!bitmapData) {
		NSLog(@"error\n");
		CGColorSpaceRelease(colorSpace);
		return NULL;
	}
	
	//Create bitmap context
	context = CGBitmapContextCreate(bitmapData, 
									width, 
									height, 
									bitsPerComponent, 
									bytesPerRow, 
									colorSpace, 
                                    kCGImageAlphaPremultipliedLast);	// RGBA
	
	if(!context) {
		free(bitmapData);
	}
	
	CGColorSpaceRelease(colorSpace);
	
	return context;	
}

@end

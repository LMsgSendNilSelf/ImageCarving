//
//  AppDelegate.m
//  ImageCarving
//
//  Created by lmsgsendnilself on 2017/6/29.
//  Copyright © 2017年 p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CGImage.h>

@interface ImagePixelConverter : NSObject 

/** Convert UIImage to RGBA8-bitmap
 @param image  origin image
 @return a RGBA8 bitmap, or NULL if any memory allocation issues. Cleanup memory with free() when done.
 */
+ (unsigned char *)convertImageToBitmap:(UIImage *)image;

/** convert RGBA8-bitmap to UIImage
 @return a new context
 */
+ (CGContextRef)newBitmapContextFromImage:(CGImageRef)image;

@end


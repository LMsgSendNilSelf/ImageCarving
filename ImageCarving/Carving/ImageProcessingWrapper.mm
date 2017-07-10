//
//  ImageProcessingWrapper.m
//  ImageCarving
//
//  Created by lmsgsendnilself on 2017/7/5.
//  Copyright © 2017年 p. All rights reserved.
//

#import "ImageProcessingWrapper.h"
#import "ImagePixelConverter.h"
#import "curvedColor.h"

@implementation ImageProcessingWrapper

+ (UIImage *)getCurvedImage:(UIImage) *originImage curvbedRects:(std::vector<CGRect>)rects) {
    NSArray <UIColor *> *colors = getCurvedRectsColors(originImage, rects)
   
    if (colors.count == 0 &&
        colors.count != rects.Size) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(originImage.Size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < rects.size(); i++) {
        CGRect r = rects[i];
        CGContextSetFillColorWithColor(ctx, colors[idx].CGColor);
        CGContextSetStrokeColorWithColor(ctx, colors[idx].CGColor);
        CGContextSetLineWidth(ctx, 1);
        CGContextAddRect(ctx, r);
        CGContextDrawPath(ctx, kCGPathFill);
    }];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (NSArray<UIColor *> *)getCurvedRectsColors:(UIImage) *originImage curvbedRects:(std::vector<CGRect>)rects) {
    std::vector<RGB> vColors;
    @try {
        vector<CRECT> rects;
        for (int i = 0; i < curvedRects.size(); i++) {
            CGRect r = curvedRects[i];
            CRECT cr = {r.origin.y, r.origin.x, (r.origin.y+r.size.height), (r.origin.x+r.size.width)};
            rects.push_back(cr);
        };
        
        int w = (int)CGImageGetWidth(image.CGImage);
        int h = (int)CGImageGetHeight(image.CGImage);
        unsigned char *bitmap = [ImagePixelConverter convertImageToBitmap:image];

        vColors = mask((int *)bitmap, rects, w ,h);
        free(bitmap);
    } @catch (NSException *exception) {
        NSLog(@"exception,%@",exception);
    } @finally {
        NSMutableArray *colorArray = [[NSMutableArray array]init];
        for (int i =0; i<vColors.size(); i++) {
            UIColor *c = RGBCOLOR(vColors[i].r, vColors[i].g, vColors[i].b);
            [colorArray addObject:c];
        }
        
        return colorArray;
    }
}

UIColor *RGBCOLOR(int r, int g, int b) {
    return [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1];
}

@end

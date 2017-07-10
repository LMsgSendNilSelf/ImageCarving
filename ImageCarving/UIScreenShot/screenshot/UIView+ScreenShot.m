//
//  UIView+ScreenShot.m
//  SuperCalculator
//
//  Created by wpstarnice on 16/9/26.
//  Copyright © 2016年 p. All rights reserved.
//

#import "UIView+ScreenShot.h"

static const CGFloat kFixPadding = 25;

@implementation UIView (ScreenShot)

#pragma mark - snap shot(public)
- (UIImage *)sc_screenshot{
    
    return [self sc_screenshotAfterUpdates:YES];
}

- (UIImage *)sc_screenshotAfterUpdates:(BOOL)afterUpdates{

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        
        NSInvocation* invoc = [NSInvocation invocationWithMethodSignature:
                               [self methodSignatureForSelector:
                                @selector(drawViewHierarchyInRect:afterScreenUpdates:)]];
        [invoc setTarget:self];
        [invoc setSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)];
        CGRect arg2 = self.bounds;
        BOOL arg3 = afterUpdates;
        [invoc setArgument:&arg2 atIndex:2];
        [invoc setArgument:&arg3 atIndex:3];
        [invoc invoke];
        
    }else {
        
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)sc_captureScrollView{
    
    if (![self isKindOfClass:[UIScrollView class]]) {
        
        return nil;
    }
    
    UIScrollView *scrollView = (UIScrollView *)self;
    
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, [UIScreen mainScreen].scale);
    
        //real frame ref
        CGPoint preservedContentOffset = scrollView.contentOffset;
        CGRect  preservedFrame = scrollView.frame;
    
        //new frame for screen snhot
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = preservedContentOffset;
        scrollView.frame = preservedFrame;
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - combine images

-(UIImage *)sc_jointScreenShotWithExtraImage:(NSString *)extraImage backGroundColor:(UIColor *)color{
    
    UIImage *content;
    
    if ([self isKindOfClass:[UIScrollView class]]) {
        
        content = [self sc_captureScrollView];
    }else{
    
        content = [self sc_screenshotAfterUpdates:NO];
    }
    
    UIImage *QRImage = [UIImage imageNamed:extraImage];
    
#warning your can layout as you want here
    //calculate canvas size
    CGFloat QRHeight    = content.size.width/QRImage.size.width*QRImage.size.height;
    CGFloat QRWidth     = content.size.width;
    
    CGFloat totalWidth  = content.size.width+2*kFixPadding;
    CGFloat totalHeight = content.size.height +QRHeight+ 2*kFixPadding;
    
    CGSize  newSize  = CGSizeMake(totalWidth, totalHeight);
    
    UIImage *bgImage = [self createImageWithRect:CGRectMake(0, 0, totalWidth, totalHeight) color:color];
    
    UIGraphicsBeginImageContext(newSize);
    
    CGRect bgRect = CGRectMake(0, 0, newSize.width, newSize.height);
    [bgImage drawInRect:bgRect];
    
    CGRect graphRect = CGRectMake(kFixPadding, kFixPadding, content.size.width, content.size.height);
    [content drawInRect:graphRect];
    
    CGRect QRImageRect = CGRectMake(kFixPadding, content.size.height+kFixPadding, QRWidth, QRHeight);
    [QRImage drawInRect:QRImageRect];
    
    UIImage *combineImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return combineImage;
}

#pragma mark - create image from ground color(private)
-(UIImage *)createImageWithRect:(CGRect)rect color:(UIColor *)color{
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end

//
//  UIView+ScreenShot.h
//  SuperCalculator
//
//  Created by wpstarnice on 16/9/26.
//  Copyright © 2016年 p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (ScreenShot)

- (UIImage *)sc_screenshot;
- (UIImage *)sc_screenshotAfterUpdates:(BOOL)afterUpdates;

/*capture UIScrollView*/
- (UIImage *)sc_captureScrollView;

/*by asseming extra image and screen shot generate one new image */
- (UIImage *)sc_jointScreenShotWithExtraImage:(NSString *)extraImage backGroundColor:(UIColor *)color;

@end

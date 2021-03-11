//
//  ADBackgroundLoadingView.m
//  TestRSS
//
//  Created by Adrien on 03/09/10.
//  Copyright 2010 Ensimag. All rights reserved.
//

#import "ADBackgroundLoadingView.h"

@interface ADBackgroundLoadingView ()
@property (nonatomic) BOOL shouldDrawGradient;
@end

@implementation ADBackgroundLoadingView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.shouldDrawGradient = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle {
    self = [self initWithFrame:frame];
    if (self) {
        self.shouldDrawGradient = loadingViewStyle == ADLoadingViewStyleAlert;
        switch (loadingViewStyle) {
#if !TARGET_OS_TV
            case ADLoadingViewStyleWhite:
                self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
                break;
#endif
            case ADLoadingViewStyleBlack:
                self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
                break;
            case ADLoadingViewStyleBlackOpaque:
                self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
                break;
            case ADLoadingViewStyleTransparent:
                self.backgroundColor = [UIColor clearColor];
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (!self.shouldDrawGradient) {
        return;
    }
    CGFloat locations[2] = {0.0f, 1.0f};
    CGFloat numLocations = 2;
    CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.5f};
    CGColorSpaceRef RGBSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(RGBSpace, colors, locations, numLocations);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextDrawRadialGradient(context,
                                gradient,
                                CGPointMake(self.frame.size.width/2, self.frame.size.height/2),
                                1.0f,
                                CGPointMake(self.frame.size.width/2, self.frame.size.height/2),
                                3.0f*MAX(self.frame.size.width,self.frame.size.height)/4.0f,
                                kCGGradientDrawsAfterEndLocation);
    CGColorSpaceRelease(RGBSpace);
    CGGradientRelease(gradient);
}
@end

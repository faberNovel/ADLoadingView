//
//  UIViewController+ADLoadingView.m
//  TestRSS
//
//  Created by Adrien on 03/09/10.
//  Copyright 2010 Ensimag. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+ADLoadingView.h"
#import "ADInnerLoadingView.h"
#import "ADBackgroundLoadingView.h"

#define AD_LOADING_VIEW_ANIMATION_DURATION 0.2f

#define ADLoadingViewMargin 10.0

@interface UIView (ADLoadingView_Private)
- (void)_didDismissModalLoadingView;
- (void)_presentModalLoadingViewWithInnerView:(UIView *)innerView
                                     animated:(BOOL)animated
                             loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle;
- (void)_presentModalLoadingViewWithInnerView:(UIView *)innerView
                                     animated:(BOOL)animated
                             loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle
                           timeBeforeSpinning:(CGFloat)timeBeforeSpinning;
- (void)_setupAndRunTimerDuringTime:(CGFloat)time forInnerView:(UIView *)innerView;
- (void)_showInnerViewFromTimer:(NSTimer *)timer;
@property (strong, nonatomic) NSTimer * appearanceTimer;
@end

static void const * appearanceTimerKey;

@implementation UIView (ADLoadingView)

- (void)ad_presentModalLoadingViewWithTitle:(NSString *)title
                             usingAnimation:(BOOL)animated
                           loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle {
    [self ad_presentModalLoadingViewWithTitle:title
                               usingAnimation:animated
                                  translucent:(loadingViewStyle == ADLoadingViewStyleAlert)
                                        style:UIBlurEffectStyleDark
                             loadingViewStyle:loadingViewStyle
                            customLoaderClass:nil];
}

- (void)ad_presentModalLoadingViewWithTitle:(NSString *)title
                             usingAnimation:(BOOL)animated
                           loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle
                         timeBeforeSpinning:(CGFloat)timeBeforeSpinning {
    [self ad_presentModalLoadingViewWithTitle:title
                               usingAnimation:animated
                                  translucent:(loadingViewStyle == ADLoadingViewStyleAlert)
                                        style:UIBlurEffectStyleDark
                             loadingViewStyle:loadingViewStyle
                            customLoaderClass:nil
                           timeBeforeSpinning:timeBeforeSpinning];
}

- (void)ad_presentModalLoadingViewWithTitle:(NSString *)title
                             usingAnimation:(BOOL)animated
                                translucent:(BOOL)translucent
                                      style:(UIBlurEffectStyle)style
                           loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle
                               customLoader:(UIView *)loaderView {
    [self ad_presentModalLoadingViewWithTitle:title
                               usingAnimation:animated
                                  translucent:translucent
                                        style:style
                             loadingViewStyle:loadingViewStyle
                                 customLoader:loaderView
                           timeBeforeSpinning:0.0f];
}


- (void)ad_presentModalLoadingViewWithTitle:(NSString *)title
                             usingAnimation:(BOOL)animated
                                translucent:(BOOL)translucent
                                      style:(UIBlurEffectStyle)style
                           loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle
                               customLoader:(UIView *)loaderView
                         timeBeforeSpinning:(CGFloat)timeBeforeSpinning {
    ADInnerLoadingView * innerView = [[ADInnerLoadingView alloc] initWithTitle:title usingTranslucency:translucent style:style loadingViewStyle:loadingViewStyle customLoader:loaderView];
    [self _presentModalLoadingViewWithInnerView:innerView animated:animated loadingViewStyle:loadingViewStyle timeBeforeSpinning:timeBeforeSpinning];
}

- (void)ad_presentModalLoadingViewWithTitle:(NSString *)title
                             usingAnimation:(BOOL)animated
                                translucent:(BOOL)translucent
                                      style:(UIBlurEffectStyle)style
                           loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle
                          customLoaderClass:(__unsafe_unretained Class)loaderClass {
    ADInnerLoadingView * innerView = [[ADInnerLoadingView alloc] initWithTitle:title usingTranslucency:translucent style:style loadingViewStyle:loadingViewStyle customLoaderClass:loaderClass];
    [self _presentModalLoadingViewWithInnerView:innerView animated:animated loadingViewStyle:loadingViewStyle];
}

- (void)ad_presentModalLoadingViewWithTitle:(NSString *)title
                             usingAnimation:(BOOL)animated
                                translucent:(BOOL)translucent
                                      style:(UIBlurEffectStyle)style
                           loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle
                          customLoaderClass:(__unsafe_unretained Class)loaderClass
                         timeBeforeSpinning:(CGFloat)timeBeforeSpinning {
    ADInnerLoadingView * innerView = [[ADInnerLoadingView alloc] initWithTitle:title usingTranslucency:translucent style:style loadingViewStyle:loadingViewStyle customLoaderClass:loaderClass];
    [self _presentModalLoadingViewWithInnerView:innerView animated:animated loadingViewStyle:loadingViewStyle timeBeforeSpinning:timeBeforeSpinning];
}

- (void)ad_dismissModalLoadingView:(BOOL)animated {
    [self ad_dismissModalLoadingView:animated withCompletion:nil];
}

- (void)ad_dismissModalLoadingView:(BOOL)animated withCompletion:(void (^)())competion {
    if (animated) {
        [UIView animateWithDuration:AD_LOADING_VIEW_ANIMATION_DURATION animations:^{
            for (UIView * view in self.subviews) {
                if ([view isKindOfClass:[ADInnerLoadingView class]]) {
                    //view.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
                    view.alpha = 0.0f;
                } else if ([view isKindOfClass:[ADBackgroundLoadingView class]]) {
                    view.alpha = 0.0f;
                }
            }
        } completion:^(BOOL finished) {
            [self _didDismissModalLoadingView];
            if (competion) {
                competion();
            }
        }];
    } else {
        [self _didDismissModalLoadingView];
    }
}
@end

@implementation UIView (ADLoadingView_Private)
- (void)_didDismissModalLoadingView {
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[ADInnerLoadingView class]] || [view isKindOfClass:[ADBackgroundLoadingView class]]) {
            [view removeFromSuperview];
        }
    }
    [self.appearanceTimer invalidate];
    self.appearanceTimer = nil;
}

- (void)_presentModalLoadingViewWithInnerView:(UIView *)innerView
                                     animated:(BOOL)animated
                             loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle {
    [self _presentModalLoadingViewWithInnerView:innerView animated:animated loadingViewStyle:loadingViewStyle timeBeforeSpinning:0.0f];
}

- (void)_presentModalLoadingViewWithInnerView:(UIView *)innerView
                                     animated:(BOOL)animated
                             loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle
                           timeBeforeSpinning:(CGFloat)timeBeforeSpinning {
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[ADInnerLoadingView class]] || [view isKindOfClass:[ADBackgroundLoadingView class]]) {
            return;
        }
    }

    if (timeBeforeSpinning > 0.0f) {
        [self _setupAndRunTimerDuringTime:timeBeforeSpinning forInnerView:innerView];
    }

    ADBackgroundLoadingView * bgView = [[ADBackgroundLoadingView alloc] initWithFrame:self.bounds loadingViewStyle:loadingViewStyle];
    [bgView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [self addSubview:bgView];

    innerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:innerView];
    NSDictionary * views = NSDictionaryOfVariableBindings(innerView);
    NSDictionary * metrics = @{@"margin": @(ADLoadingViewMargin)};
    NSArray<NSLayoutConstraint *> * horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=margin-[innerView]"
                                                                                                    options:0
                                                                                                    metrics:metrics
                                                                                                      views:views];
    for (NSLayoutConstraint * constraint in horizontalConstraints) {
        constraint.priority = 999;
    }
    [self addConstraints:horizontalConstraints];
    NSArray<NSLayoutConstraint *> * verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=margin-[innerView]"
                                                                                                  options:0
                                                                                                  metrics:metrics
                                                                                                    views:views];
    for (NSLayoutConstraint * constraint in verticalConstraints) {
        constraint.priority = 999;
    }
    [self addConstraints:verticalConstraints];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                        toItem:innerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                        toItem:innerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    if (animated) {
        bgView.alpha = 0.0f;
        innerView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:AD_LOADING_VIEW_ANIMATION_DURATION];
        bgView.alpha = 1.0f;
        innerView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView commitAnimations];
    }
}

- (void)_setupAndRunTimerDuringTime:(CGFloat)time forInnerView:(UIView *)innerView {
    innerView.hidden = YES;
    self.appearanceTimer = [NSTimer scheduledTimerWithTimeInterval:time
                                     target:self
                                   selector:@selector(_showInnerViewFromTimer:)
                                   userInfo:innerView
                                    repeats:NO];
}

- (void)_showInnerViewFromTimer:(NSTimer *)timer {
    if ([[timer userInfo] isKindOfClass:UIView.class]) {
        ((UIView *)[timer userInfo]).hidden = NO;
    }
}

#pragma mark - Category getter/setter

- (NSTimer *)appearanceTimer {
    return objc_getAssociatedObject(self, appearanceTimerKey);
}

- (void)setAppearanceTimer:(NSTimer *)appearanceTimer {
    objc_setAssociatedObject(self, appearanceTimerKey, appearanceTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


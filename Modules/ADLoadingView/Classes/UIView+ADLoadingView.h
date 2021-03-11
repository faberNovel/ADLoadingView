//
//  UIViewController+ADLoadingView.h
//  TestRSS
//
//  Created by Adrien on 03/09/10.
//  Copyright 2010 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADLoadingViewStyle.h"

@interface UIView (ADLoadingView)

- (void)ad_presentModalLoadingViewWithTitle:(NSString *)title
                             usingAnimation:(BOOL)animated
                           loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle;

- (void)ad_presentModalLoadingViewWithTitle:(NSString *)title
                             usingAnimation:(BOOL)animated
                           loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle
                         timeBeforeSpinning:(CGFloat)timeBeforeSpinning;

- (void)ad_presentModalLoadingViewWithTitle:(NSString *)title
                             usingAnimation:(BOOL)animated translucent:(BOOL)translucent
                                      style:(UIBlurEffectStyle)style
                           loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle
                          customLoaderClass:(__unsafe_unretained Class)loaderClass;

- (void)ad_presentModalLoadingViewWithTitle:(NSString *)title
                             usingAnimation:(BOOL)animated translucent:(BOOL)translucent
                                      style:(UIBlurEffectStyle)style
                           loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle
                          customLoaderClass:(__unsafe_unretained Class)loaderClass
                         timeBeforeSpinning:(CGFloat)timeBeforeSpinning;

- (void)ad_presentModalLoadingViewWithTitle:(NSString *)title
                             usingAnimation:(BOOL)animated
                                translucent:(BOOL)translucent
                                      style:(UIBlurEffectStyle)style
                           loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle
                               customLoader:(UIView *)loaderView;

- (void)ad_presentModalLoadingViewWithTitle:(NSString *)title
                             usingAnimation:(BOOL)animated
                                translucent:(BOOL)translucent
                                      style:(UIBlurEffectStyle)style
                           loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle
                               customLoader:(UIView *)loaderView
                         timeBeforeSpinning:(CGFloat)timeBeforeSpinning;

- (void)ad_dismissModalLoadingView:(BOOL)animated;

- (void)ad_dismissModalLoadingView:(BOOL)animated withCompletion:(void (^)())competion;
@end

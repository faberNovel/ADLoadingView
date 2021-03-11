//
//  ADInnerLoadingView.m
//  TestRSS
//
//  Created by Adrien on 03/09/10.
//  Copyright 2010 Ensimag. All rights reserved.
//

#import "ADInnerLoadingView.h"

#define ADInnerLoadingViewInnerMargin 10.0

@interface ADInnerLoadingView () {
    BOOL _translucent;
}
@property (nonatomic, readonly) BOOL useBlurEffect;
- (UIView *)_contentViewWithBlurEffectWithStyle:(UIBlurEffectStyle)style;
- (void)_addActivityIndicator:(UIView *)activityIndicator toContentView:(UIView *)contentView;
- (void)_addLoadingLabelToContentView:(UIView *)contentView withLoadingViewStyle:(ADLoadingViewStyle)loadingViewStyle title:(NSString *)title activityIndicator:(UIView *)activityIndicator;
@end

@implementation ADInnerLoadingView

static NSString * innerMargin = @"innerMargin";
#pragma mark - UIView
- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - ADInnerLoadingView
- (id)initWithTitle:(NSString *)title {
    self = [self initWithTitle:title usingTranslucency:YES style:UIBlurEffectStyleDark loadingViewStyle:ADLoadingViewStyleAlert customLoaderClass:nil];
    return self;
}

- (id)initWithTitle:(NSString *)title usingTranslucency:(BOOL)translucent style:(UIBlurEffectStyle)style loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle customLoaderClass:(__unsafe_unretained Class)loaderClass {
    UIView * activityIndicator = nil;
    if (loaderClass == nil && loadingViewStyle != ADLoadingViewStyleNoStyle) {
        BOOL isLarge = title.length == 0 || loadingViewStyle == ADLoadingViewStyleAlert;
        UIActivityIndicatorViewStyle activityIndicatorStyle = isLarge ? UIActivityIndicatorViewStyleWhiteLarge : UIActivityIndicatorViewStyleWhite;
        UIActivityIndicatorView * nativeIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityIndicatorStyle];
#if !TARGET_OS_TV
        if (loadingViewStyle == ADLoadingViewStyleWhite) {
            nativeIndicatorView.color = [UIColor grayColor];
        }
#endif
        activityIndicator = nativeIndicatorView;
    } else {
        activityIndicator = [[loaderClass alloc] init];
    }
    return self = [self initWithTitle:title usingTranslucency:translucent style:style loadingViewStyle:loadingViewStyle customLoader:activityIndicator];
}

- (id)initWithTitle:(NSString *)title usingTranslucency:(BOOL)translucent style:(UIBlurEffectStyle)style loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle customLoader:(UIView *)activityIndicator {
    if ((self = [super init])) {
        self.tintColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        _translucent = translucent;
        self.backgroundColor = [UIColor clearColor];
        if (activityIndicator == nil) {
            return self;
        }
        if (loadingViewStyle == ADLoadingViewStyleAlert) {
            self.layer.cornerRadius = 10.0;
            if (!self.useBlurEffect) {
                self.backgroundColor = [UIColor blackColor];
            }
        }
        UIView * contentView = self;

        if (self.useBlurEffect) {
            contentView = [self _contentViewWithBlurEffectWithStyle:style];
        }

        [contentView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        if (activityIndicator) {
            [self _addActivityIndicator:activityIndicator toContentView:contentView];
        }

        if (title.length > 0) {
            [self _addLoadingLabelToContentView:contentView withLoadingViewStyle:loadingViewStyle title:title activityIndicator:activityIndicator];
        }
        if ([activityIndicator respondsToSelector:@selector(startAnimating)]) {
            [activityIndicator performSelector:@selector(startAnimating)];
        }
    }
    return self;
}

- (BOOL)useBlurEffect {
    return NSClassFromString(@"UIVisualEffectView") != nil && _translucent;
}

#pragma mark - Private
- (UIView *)_contentViewWithBlurEffectWithStyle:(UIBlurEffectStyle)style {
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView * viewWithBlurredBackground = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    viewWithBlurredBackground.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:viewWithBlurredBackground];
    UIVibrancyEffect * vibrancyEffect =  [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView * viewInducingVibrancy = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    viewInducingVibrancy.translatesAutoresizingMaskIntoConstraints = NO;
    [viewWithBlurredBackground.contentView addSubview:viewInducingVibrancy];
    NSDictionary * views = NSDictionaryOfVariableBindings(viewWithBlurredBackground, viewInducingVibrancy);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[viewWithBlurredBackground]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[viewWithBlurredBackground]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[viewInducingVibrancy]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[viewInducingVibrancy]|" options:0 metrics:nil views:views]];
    return viewInducingVibrancy.contentView;
}

- (void)_addActivityIndicator:(UIView *)activityIndicator toContentView:(UIView *)contentView {
    NSDictionary * metrics = @{innerMargin: @(ADInnerLoadingViewInnerMargin)};
    activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary * views = NSDictionaryOfVariableBindings(activityIndicator);
    [contentView addSubview:activityIndicator];
    NSArray * constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-==innerMargin-[activityIndicator]-==innerMargin-|"
                                                                    options:0 metrics:metrics views:views];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-==innerMargin-[activityIndicator]-==innerMargin-|"
                                                                                                     options:0 metrics:metrics views:views]];
    for (NSLayoutConstraint * contraint in constraints) {
        contraint.priority = UILayoutPriorityFittingSizeLevel;
    }
    [contentView addConstraints:constraints];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                               toItem:activityIndicator attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
}

- (void)_addLoadingLabelToContentView:(UIView *)contentView withLoadingViewStyle:(ADLoadingViewStyle)loadingViewStyle title:(NSString *)title activityIndicator:(UIView *)activityIndicator {
    CGFloat fontSize = 13.0f;
    UILabel * loadingLabel = [[UILabel alloc] init];
    switch (loadingViewStyle) {
        case ADLoadingViewStyleAlert:
            fontSize = 20.0f;
            if (!self.useBlurEffect) {
                loadingLabel.textColor = [UIColor blackColor];
                loadingLabel.shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
                loadingLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
            }
            break;
#if !TARGET_OS_TV
        case ADLoadingViewStyleWhite:
            loadingLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
            loadingLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
            break;
#endif
        case ADLoadingViewStyleBlack:
        case ADLoadingViewStyleBlackOpaque:
        case ADLoadingViewStyleTransparent:
            loadingLabel.textColor = [UIColor whiteColor];
            loadingLabel.shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
            loadingLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
            break;
        case ADLoadingViewStyleNoStyle:

            break;
        default:
            break;
    }
    NSDictionary * metrics = @{innerMargin: @(ADInnerLoadingViewInnerMargin)};
    loadingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:loadingLabel];
    NSDictionary * views = NSDictionaryOfVariableBindings(activityIndicator, loadingLabel);
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=innerMargin-[loadingLabel]->=innerMargin-|"
                                                                        options:0 metrics:metrics views:views]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-innerMargin-[loadingLabel]-innerMargin-[activityIndicator]"
                                                                        options:0 metrics:metrics views:views]];
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                               toItem:loadingLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    loadingLabel.font = [UIFont systemFontOfSize:fontSize];
    loadingLabel.text = title;
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.numberOfLines = 4;
    loadingLabel.lineBreakMode = NSLineBreakByWordWrapping;
}
@end


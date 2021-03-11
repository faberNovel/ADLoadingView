//
//  ADInnerLoadingView.h
//  TestRSS
//
//  Created by Adrien on 03/09/10.
//  Copyright 2010 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADLoadingViewStyle.h"

@interface ADInnerLoadingView : UIView
- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title usingTranslucency:(BOOL)translucent style:(UIBlurEffectStyle)style loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle customLoaderClass:(__unsafe_unretained Class)loaderClass;
- (id)initWithTitle:(NSString *)title usingTranslucency:(BOOL)translucent style:(UIBlurEffectStyle)style loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle customLoader:(UIView *)activityIndicator;
@end

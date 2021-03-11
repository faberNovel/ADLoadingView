//
//  ADBackgroundLoadingView.h
//  TestRSS
//
//  Created by Adrien on 03/09/10.
//  Copyright 2010 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADLoadingViewStyle.h"

@interface ADBackgroundLoadingView : UIView
- (instancetype)initWithFrame:(CGRect)frame loadingViewStyle:(ADLoadingViewStyle)loadingViewStyle;
@end

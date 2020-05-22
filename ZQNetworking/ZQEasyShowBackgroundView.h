//
//  ZQEasyShowBackgroundView.h
//  Client
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQEasyConfigHeader.h"

@interface ZQEasyShowBackgroundView : UIView

- (instancetype)initWithFrame:(CGRect)frame status:(ShowTextStatus)status text:(NSString *)text imageName:(NSString *)imageName;

- (void)showWindowYToPoint:(CGFloat)toPoint ;

- (void)showStartAnimationWithDuration:(CGFloat)duration ;

- (void)showEndAnimationWithDuration:(CGFloat)duration  ;

@end


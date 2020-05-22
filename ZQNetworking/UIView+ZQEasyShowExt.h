//
//  UIView+ZQEasyShowExt.h
//  Client
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

//内联函数
CG_INLINE CGFloat kAutoFitWidth_6(CGFloat width){
    return ([[UIScreen mainScreen] bounds].size.width/375.0f)*width ;
}

CG_INLINE CGFloat kAutoFitHeight_6(CGFloat height){
    return ([[UIScreen mainScreen] bounds].size.height/667.0f)*height ;
}

CG_INLINE CGRect kAutoFitFrame_6(CGFloat x,CGFloat y,CGFloat width,CGFloat height){
    return CGRectMake(kAutoFitWidth_6(x),kAutoFitHeight_6(y),kAutoFitWidth_6(width), kAutoFitHeight_6(height));
}

CG_INLINE CGSize kAutoFitSize_6(CGFloat width , CGFloat height){
    return CGSizeMake(kAutoFitWidth_6(width), kAutoFitHeight_6(height));
}

CG_INLINE CGPoint kAutoFitPoint_6(CGFloat x ,CGFloat y){
    return CGPointMake(kAutoFitWidth_6(x), kAutoFitHeight_6(y)) ;
}

@interface UIView (ZQEasyShowExt)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

@property(nonatomic,assign) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;

/**
 * 获取当前view所在的控制器
 */
- (UIViewController *)currentViewController;

- (void)setRoundedCorners:(CGFloat)corners ;

- (void)setRoundedCorners:(UIRectCorner)corners
              borderWidth:(CGFloat)borderWidth
              borderColor:(UIColor *)borderColor
               cornerSize:(CGSize)size ;
@end

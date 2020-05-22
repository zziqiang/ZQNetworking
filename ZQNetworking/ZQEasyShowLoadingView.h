//
//  ZQEasyShowLoadingView.h
//  Client
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQEasyShowLoadingView : UIView

/**
 * 显示一个加载框
 * text:需要显示加载框的字体
 * imageName：需要显示加载框的图片名称
 * superview:加载框所需要的父视图（如果不传会放到window和topviewcontroller上面，在FMEasyShowOptions里指定）
 *
 * 需要自定义的样式可以在FMEasyShowOptions里设置
 */
+ (void)showLoading ;
//显示加载文字
+ (void)showLoadingText:(NSString *)text ;
+ (void)showLoadingText:(NSString *)text inView:(UIView *)superView ;

//显示加载文字及图片
+ (void)showLoadingText:(NSString *)text imageName:(NSString *)imageName ;
+ (void)showLoadingText:(NSString *)text imageName:(NSString *)imageName inView:(UIView *)superView ;

/**
 * 移除一个加载框
 * uperview:加载框所在的父视图。show的时候没有指定父视图。那么隐藏的时候也不用
 */
+ (void)hiddenLoading;
+ (void)hiddenLoading:(UIView *)superView ;

@end

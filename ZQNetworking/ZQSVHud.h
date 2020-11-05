//
//  ZQSVHud.h
//  Client
//
//  Created by apple on 2020/11/5.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQEasyShowConfig.h"
#import <SVProgressHUD.h>
#import <MBProgressHUD.h>

@interface ZQSVHud : NSObject

/**
 *  隐藏alert
 */
+(void)hideAlert;

/**
 *  显示简短的提示语，默认2秒钟，时间可直接修改kShowTime
 *
 *  @param alert 提示信息
 */
+ (void) showBriefAlert:(NSString *) alert;

/**
 自定义提示的显示时间，默认横屏

 @param message 提示语
 @param showTime 提示时间
 */
+ (void)showBriefAlert:(NSString *)message time:(NSInteger)showTime;

/**
 *  显示“加载中”，带圈圈，若要修改直接修改kLoadingMessage的值即可
 */
+ (void)showLoading;

/**
 *  自定义等待提示语，效果同showLoading
 *
 *  @param title 提示语
 */
+ (void)showLoadingWithTitle:(NSString *)title;


@end

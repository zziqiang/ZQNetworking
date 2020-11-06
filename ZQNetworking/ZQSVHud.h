//
//  ZQSVHud.h
//  Client
//
//  Created by apple on 2020/11/5.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZQHudShowPosition) {
    HudShowPositionCenter = 1,
    HudShowPositionTop,
    HudShowPositionBottom,
};



@interface ZQSVHud : NSObject

/**
 *  隐藏alert
 */
+(void)hideAlert;

/**
 *  显示简短的提示语，默认1.5秒钟，时间可直接修改kShowTime
 *
 *  @param message 提示信息
 */
+(void)showBriefAlert:(NSString *)message;

/**
 自定义提示的显示时间

 @param message 提示语
 @param showTime 提示时间
 */
+ (void)showBriefAlert:(NSString *)message time:(NSInteger)showTime;


/// 中间自定义提示
/// @param message 提示语
+(void)showBriefCenterAlert:(NSString *)message;

/**
 自定义提示的显示位置

 @param message 提示语
 @param position 提示位置
 */
+ (void)showBriefAlert:(NSString *)message withPosition:(ZQHudShowPosition)position;

/**
 自定义提示的显示时间，默认横屏

 @param message 提示语
 @param showTime 提示时间
 @param position 提示位置
 */
+ (void)showBriefAlert:(NSString *)message time:(NSInteger)showTime withPosition:(ZQHudShowPosition)position;

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

//
//  ZQNetworkingTips.h
//  Client
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZQNetworkingTips : NSObject

/// hud文字提示
/// @param msg 提示框文字
+(void)zq_showHudText:(NSString *)msg;

/// 显示菊花 【显示期间不能交互】
+(void)zq_showHudLoadingIndicator;

/// 隐藏菊花
+(void)zq_hiddenHudIndicator;

@end

NS_ASSUME_NONNULL_END

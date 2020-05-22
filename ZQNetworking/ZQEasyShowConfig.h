//
//  ZQEasyShowConfig.h
//  Client
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 是否为空
#define ISEMPTY_S(_v) (_v == nil || _v.length == 0)

//屏幕宽度
#define  kScreen_Width [[UIScreen mainScreen] bounds].size.width
//屏幕高度
#define  kScreen_Height [[UIScreen mainScreen] bounds].size.height
//是否iPhoneX系列手机
#define kMatchiPhoneXSeries (([ZQEasyShowConfig isNotchScreen]) ? YES : NO)

////屏幕是否是横屏状态
//#define ISHORIZONTALSCREEM_S UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)

//状态栏默认高度 orginal
#define kStatus_Height  (CGFloat)(kMatchiPhoneXSeries ? (44.0) : 20 )
//导航栏原始高度
#define kNavNormalHeight 44.0f
//TabBar原始高度
#define kTabNormalHeight 49.0f

/*顶部安全区域远离高度*/
#define kSafeTopMargin (CGFloat)(kMatchiPhoneXSeries?(44.0):(0))
/*底部安全区域远离高度*/
#define kSafeBottomMargin  (CGFloat)(kMatchiPhoneXSeries ? 34.0f : 0.0f)



@interface ZQEasyShowConfig : NSObject

+ (CGSize)textWidthWithStirng:(NSString *)string font:(UIFont *)font maxWidth:(CGFloat)maxWidth ;

+ (UIViewController *)topViewController;

+ (UIImage *)imageWithColor:(UIColor *)color ;

// 判断刘海屏，返回YES表示是刘海屏
+ (BOOL)isNotchScreen;

@end


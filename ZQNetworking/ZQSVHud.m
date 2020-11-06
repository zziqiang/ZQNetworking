//
//  ZQSVHud.m
//  Client
//
//  Created by apple on 2020/11/5.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ZQSVHud.h"
#import "ZQEasyShowConfig.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

/* 默认网络提示，可在这统一修改 */
static NSString *const kLoadingMessage = @"loading...";
/* 默认简短提示语显示的时间，在这统一修改 */
static CGFloat const kShowTime  = 1.5f;

@implementation ZQSVHud

#pragma mark -   类初始化
+ (void)initialize
{
    if (self == [ZQSVHud self])
    {
        
    }
}

#pragma mark - 简短提示语
+(void)showBriefAlert:(NSString *)message{
    [self showBriefAlert:message time:kShowTime withPosition:HudShowPositionBottom];
}

+(void)showBriefCenterAlert:(NSString *)message{
    [self showBriefAlert:message time:kShowTime withPosition:HudShowPositionCenter];
}

+ (void)showBriefAlert:(NSString *)message time:(NSInteger)showTime{
    [self showBriefAlert:message time:showTime withPosition:HudShowPositionBottom];
}

+ (void)showBriefAlert:(NSString *)message withPosition:(ZQHudShowPosition)position{
    [self showBriefAlert:message time:kShowTime withPosition:position];
}

+ (void)showBriefAlert:(NSString *)message time:(NSInteger)showTime withPosition:(ZQHudShowPosition)position{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows.firstObject animated:YES];
        hud.detailsLabelText = message;
        hud.detailsLabelFont = [UIFont systemFontOfSize:14];
        hud.animationType = MBProgressHUDAnimationZoom;
        hud.mode = MBProgressHUDModeText;
        hud.margin = 10.f;
        switch (position) {
            case HudShowPositionCenter:
            {
                hud.yOffset = 0;
            }
                break;
            case HudShowPositionTop:
            {
                hud.yOffset = - (kScreen_Height /2.0 - (kNavNormalHeight + kStatus_Height));
            }
                break;
            case HudShowPositionBottom:
            {
                hud.yOffset = kScreen_Height /2.0 - (kTabNormalHeight + kSafeBottomMargin);
            }
                break;
            default:
                break;
        }
        
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:NO afterDelay:showTime];
    });
}


#pragma mark - 网络加载提示用
+ (void)showLoading{
    [self showLoadingWithTitle:kLoadingMessage];
}

+ (void)showLoadingWithTitle:(NSString *)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:title];
    });
}

#pragma mark - 隐藏提示框
+(void)hideAlert{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end

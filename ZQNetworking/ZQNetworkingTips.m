//
//  ZQNetworkingTips.m
//  Client
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ZQNetworkingTips.h"
#import "ZQEasyShowViewHeader.h"

@implementation ZQNetworkingTips

+(void)zq_showHudText:(NSString *)msg{
    [ZQEasyShowOptions sharedEasyShowOptions].textStatusType = ShowTextStatusTypeMidden;

    [ZQEasyShowTextView showText:msg];
}

+(void)zq_showHudLoadingIndicator{
    [ZQEasyShowOptions sharedEasyShowOptions].textStatusType = ShowTextStatusTypeMidden;
    [ZQEasyShowOptions sharedEasyShowOptions].loadingSuperViewReceiveEvent = NO;
    [ZQEasyShowOptions sharedEasyShowOptions].loadingShowOnWindow = YES;
    [ZQEasyShowOptions sharedEasyShowOptions].loadingAnimationType = LoadingAnimationTypeBounce;
    [ZQEasyShowOptions sharedEasyShowOptions].loadingShowType = LoadingShowTypeIndicator;
    [ZQEasyShowLoadingView showLoadingText:@""];
}

+(void)zq_hiddenHudIndicator {
    [ZQEasyShowLoadingView hiddenLoading];
}

@end

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
    [ZQSVHud showBriefAlert:msg];
}

+(void)zq_showHudLoadingIndicator{
    [ZQSVHud showLoading];
}

+(void)zq_hiddenHudIndicator {
    [ZQSVHud hideAlert];
}

@end

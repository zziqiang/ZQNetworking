//
//  ZQEasyShowOptions.m
//  Client
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ZQEasyShowOptions.h"

const CGFloat ZQEasyDrawImageWH  = 30 ;   //显示图片的宽高
const CGFloat ZQEasyDrawImageEdge = 15 ;  //显示图片的边距
const CGFloat ZQEasyTextShowEdge = 40 ;   //显示纯文字时，当设置top和bottom的时候，距离屏幕上下的距离
const CGFloat ZQEasyShowViewHeaderMinWidth = 50 ;//视图最小的宽度

const CGFloat ZQTextShowMaxTime = 8.0f;//最大的显示时长。显示的时长为字符串长度成比例。但是不会超过设置的此时间长度(默认为6秒)
const CGFloat ZQTextShowMaxWidth = 300;//文字显示的最大宽度


const CGFloat ZQEasyShowLoadingMaxWidth = 200 ;    //显示文字的最大宽度（高度已限制死）
const CGFloat ZQEasyShowLoadingImageEdge = 10 ;    //加载框图片的边距
const CGFloat ZQEasyShowLoadingImageWH = 30 ;      //加载框图片的大小
const CGFloat ZQEasyShowLoadingImageMaxWH = 60 ;   //加载框图片的最大宽度


const CGFloat ZQEasyShowAnimationTime = 0.3f ;    //动画时间


NSString *const ZQEasyShowViewHeaderDidlDismissNotification = @"ZQEasyShowViewHeaderDidlDismissNotification" ; //当ZQEasyShowViewHeader消失的时候会发送此通知。

@implementation ZQEasyShowOptions

@synthesize loadingPlayImagesArray = _loadingPlayImagesArray ;

static ZQEasyShowOptions *_showInstance;
+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _showInstance = [super allocWithZone:zone];
    });
    return _showInstance;
}

+ (instancetype)sharedEasyShowOptions{
    if (nil == _showInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _showInstance = [[[self class] alloc] init];
        });
    }
    return _showInstance;
}

- (id)copyWithZone:(NSZone *)zone{
    return _showInstance;
}
- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _showInstance;
}


- (instancetype)init
{
    if (self = [super init]) {
       
        _textAnimationType = TextAnimationTypeBounce ;
        _textStatusType = ShowTextStatusTypeMidden  ;
        
        _textTitleFount = [UIFont systemFontOfSize:17];
        _textTitleColor = [[UIColor whiteColor]colorWithAlphaComponent:1.7];
        _textBackGroundColor = [UIColor blackColor];
        _textShadowColor = [UIColor blueColor];
        
        _textSuperViewReceiveEvent = YES ;
        
        
        _loadingShowType = LoadingShowTypeTurnAround ;
        _loadingAnimationType = LoadingAnimationTypeBounce ;
        _loadingTextFount = [UIFont systemFontOfSize:17];
        _loadingTintColor = [UIColor blackColor];
        _loadingBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.05];
        _loadingSuperViewReceiveEvent = YES ;
        _loadingShowOnWindow = NO ;
        _loadingCycleCornerWidth = 5 ;
        
        
        _alertTitleColor = [UIColor blackColor];
        _alertMessageColor = [UIColor darkGrayColor];
        _alertTintColor = [UIColor clearColor];
        _alertTowItemHorizontal = YES ;
        _alertBgViewTapRemove = YES ;
    }
    return self ;
}

- (void)setloadingPlayImagesArray:(NSArray *)loadingPlayImagesArray
{
    _loadingPlayImagesArray = loadingPlayImagesArray ;
}

- (NSArray *)lodingPlayImagesArray
{
    NSAssert(_loadingPlayImagesArray, @"you should set image array use to animation!");
    return _loadingPlayImagesArray  ;
}

@end

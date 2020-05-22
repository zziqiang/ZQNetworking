//
//  ZQEasyShowOptions.h
//  Client
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQEasyShowConfig.h"

/**
该类主要用于提示、等待图、Alert、ActionSheet之类的弹窗基本配置
*/

#pragma mark - 结构体

typedef NS_ENUM(NSInteger, ShowTextStatus) {
    
    ShowTextStatusPureText ,/** 纯文字 */
    ShowTextStatusSuccess,  /** 成功 */
    ShowTextStatusError,    /** 失败 */
    ShowTextStatusInfo,     /** 提示 */
    ShowTextStatusImage,    /** 自定义图片 */
};

/**
 * 设置文字的位置
 */
typedef NS_ENUM(NSUInteger , ShowTextStatusType) {
    ShowTextStatusTypeTop = 0 ,
    ShowTextStatusTypeMidden ,
    ShowTextStatusTypeBottom,
    ShowTextStatusTypeStatusBar ,//在statusbar上显示
    ShowTextStatusTypeNavigation ,//在navigation上显示
};

/**
 * 文字展示时的动画类型
 */
typedef NS_ENUM(NSUInteger , TextAnimationType) {
    TextAnimationTypeNone ,//无动画
    TextAnimationTypeFade,//alpha改变
    TextAnimationTypeBounce ,//抖动
};


/**
 * 加载框的样式
 */
typedef NS_ENUM(NSUInteger , LoadingShowType) {
    
    LoadingShowTypeTurnAround     = 0 ,  //默认转圈样式
    LoadingShowTypeTurnAroundLeft = 1 ,  //默认在左边转圈样式
    
    LoadingShowTypeIndicator      = 2 ,  //菊花样式
    LoadingShowTypeIndicatorLeft  = 3 ,  //菊花在左边的样式
    
    LoadingShowTypePlayImages     = 4 ,  //以一个图片数组轮流播放（需添加一组图片，在FMEasyShowOptions中添加）
    LoadingShowTypePlayImagesLeft = 5 ,  //以一个图片数组轮流播放需添加一组图片）
    
    LoadingShowTypeImageUpturn    = 6 ,//自定义图片翻转样式
    LoadingShowTypeImageUpturnLeft= 7 ,//自动以图片左边翻转样式
    
    LoadingShowTypeImageAround    = 8 ,//自定义图片边缘转圈样式
    LoadingShowTypeImageAroundLeft= 9 ,//自动以图片左边边缘转圈样式
};

/**
 *
 */
typedef NS_ENUM(NSUInteger , LoadingAnimationType) {
    LoadingAnimationTypeNone ,//无动画
    LoadingAnimationTypeFade,//alpha改变
    LoadingAnimationTypeBounce ,//抖动
} ;


/**
 * 添加一个item的样式，只有color和blod可选
 */
typedef NS_ENUM(NSInteger, ShowAlertItemType) {
    ShowAlertItemTypeBlack = 0,  // 黑色字体
    ShowAlertItemTypeBlodBlack , // 黑色加粗字体
    ShowAlertItemTypeBlue,       // 蓝色字体
    ShowAlertItemTypeBlodBlue,   // 蓝色加粗字体
    ShowAlertItemTypeRed   ,     // 红色字体
    ShowAlertItemTypeBlodRed ,   // 红色加粗字体
    ShowStatusTextTypeCustom     //自定义的一种自己，需要在FMEasyShowOptions中配置，如果不配置将会是第一种(黑色字体)
};

/**
 * alertView的动画形式
 */
typedef NS_ENUM(NSUInteger , alertAnimationType) {
    alertAnimationTypeNone ,//无动画
    alertAnimationTypeFade,//alpha改变
    alertAnimationTypeBounce ,//抖动
    alertAnimationTypeZoom, //放大缩小
    alertAnimationTypePush ,//向上push
};

#pragma mark - 定义全局变量

UIKIT_EXTERN const CGFloat ZQEasyDrawImageWH;
UIKIT_EXTERN const CGFloat ZQEasyDrawImageEdge;
UIKIT_EXTERN const CGFloat ZQEasyTextShowEdge;
UIKIT_EXTERN const CGFloat ZQEasyShowViewHeaderMinWidth;

UIKIT_EXTERN const CGFloat ZQTextShowMaxTime;             //最大的显示时长。显示的时长为字符串长度成比例。但是不会超过设置的此时间长度(默认为6秒)
UIKIT_EXTERN const CGFloat ZQTextShowMaxWidth;            //文字显示的最大宽度

UIKIT_EXTERN const CGFloat ZQEasyShowLoadingMaxWidth;     //显示文字的最大宽度（高度已限制死）
UIKIT_EXTERN const CGFloat ZQEasyShowLoadingImageEdge;    //加载框图片的边距
UIKIT_EXTERN const CGFloat ZQEasyShowLoadingImageWH;      //加载框图片的大小
UIKIT_EXTERN const CGFloat ZQEasyShowLoadingImageMaxWH;   //加载框图片的最大宽度

UIKIT_EXTERN const CGFloat ZQEasyShowAnimationTime;       //动画时间
UIKIT_EXTERN NSString *const ZQEasyShowViewHeaderDidlDismissNotification;

#pragma mark - 头文件

@interface ZQEasyShowOptions : NSObject<NSCopying,NSMutableCopying>

+ (instancetype)sharedEasyShowOptions;

#pragma mark - text
/**
 * 在显示的期间，superview是否能接接收事件
 */
@property BOOL textSuperViewReceiveEvent;

/**
 * 文字展示的动画形式
 */

@property TextAnimationType textAnimationType;

/**
 * /文字的显示样式
 */
@property ShowTextStatusType textStatusType;

/**
 * 显示大小、文字颜色、背景颜色、阴影颜色(为clearcolor的时候不显示阴影)
 */
@property (nonatomic,strong)UIFont  *textTitleFount;         //文字大小
@property (nonatomic,strong)UIColor *textTitleColor;        //文字颜色
@property (nonatomic,strong)UIColor *textBackGroundColor;   //背景颜色
@property (nonatomic,strong)UIColor *textShadowColor;       //阴影颜色

#pragma mark - Loading
/**
 * 加载框的显示样式
 */
@property LoadingShowType loadingShowType;

/**
 * 显示/隐藏 加载框的动画
 */
@property LoadingAnimationType loadingAnimationType;

/**
 * 在显示加载框的时候，superview能否接收事件。默认为NO
 */
@property BOOL loadingSuperViewReceiveEvent;

/**
 * 是否将加载框显示到window上面。默认为NO（此属性只有在不传superview的时候有效）
 * 当为NO： 加载框会遮盖住最上面一个controller的大小。如果loadingSuperViewReceiveEvent为NO,那么superview不接受事件，返回按钮会有效。
 * 当为YES：加载框会在盖住整个window的大小。如果loadingSuperViewReceiveEvent为NO,那么在不隐藏加载框的时候返回事件都会被遮住。
 *
 */
@property BOOL loadingShowOnWindow;

/**
 * 圆角大小
 */
@property (nonatomic,assign)CGFloat loadingCycleCornerWidth;

/**
 *  文字/图片颜色、文字大小、背景颜色
 */
@property (nonatomic,strong)UIColor *loadingTintColor;
@property (nonatomic,strong)UIFont  *loadingTextFount;
@property (nonatomic,strong)UIColor *loadingBackgroundColor;

/**
 * 加载框为数组动画的时候，这里是传入图片的数据
 */
@property (nonatomic,strong)NSArray *loadingPlayImagesArray;

#pragma mark - alert
/**
 *alertview的背景颜色。
 * title/message的字体颜色
 */
@property (nonatomic,strong)UIColor *alertTintColor ;
@property (nonatomic,strong)UIColor *alertTitleColor ;
@property (nonatomic,strong)UIColor *alertMessageColor ;

/**
 * alertView:是两个按钮的时候 横着摆放
 */
@property (nonatomic,assign)BOOL alertTowItemHorizontal ;

/**
 * alertView:展示和消失的动画类型。
 * 当展示的是系统alertview和ActionSheet不起作用
 */
@property (nonatomic,assign)alertAnimationType alertAnimationType ;

/**
 * 点击alertview之外的空白区域，是否销毁alertview。默认为:NO
 *
 * 系统的alert        不可以点击销毁。
 * 系统的ActionSheet  添加UIAlertActionStyleCancel类型就会有点击销毁。没有就不会销毁。
 */
@property (nonatomic,assign)BOOL alertBgViewTapRemove ;

@end


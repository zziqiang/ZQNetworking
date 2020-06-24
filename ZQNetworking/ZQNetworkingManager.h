//
//  ZQNetworkingManager.h
//  Client
//
//  Created by apple on 2020/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ZQNetworkRequestBase.h"

typedef NS_ENUM(NSInteger, ZQNetworkingHandlerType) {
    ZQNetworkingHandlerTypeLogout = 1,
    ZQNetworkingHandlerTypeRequestLog
};

#define kFormatWithMainHostUrl(parameter) [NSString stringWithFormat:@"%@/%@",ZQNetworkingManager.sharedInstance.mainHostUrl,parameter]


typedef void (^ZQNetworkingHandler)(ZQNetworkingHandlerType type, id objc);

@interface ZQNetworkingManager : ZQNetworkRequestBase

@property (nonatomic, copy) NSString *mainHostUrl;
@property (nonatomic, assign) BOOL mingoKill;

@property (nonatomic, strong) NSMutableDictionary *dicDefaultHeader;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *tokenKeyName;
@property (nonatomic, copy) NSString *messagekey;
@property (nonatomic, copy) NSString *codeKey;

@property (nonatomic, assign) NSInteger codeSuccess;
@property (nonatomic, assign) NSInteger codetokenError;
@property (nonatomic, assign) NSInteger codeLogout;

@property (nonatomic, copy) NSString *loginClassString;

@property (nonatomic, copy) ZQNetworkingHandler networkingHandler;

/// 网络请求管家
+ (instancetype)sharedInstance;

/// 上传图片多张
/// @param urlString 请求链接
/// @param params 参数
/// @param imagesOrData UIImage / NSData格式 或 NSArray格式 nil
/// @param progressBlock 进度
/// @param successBlock 成功回调
- (void)zq_uploadImagesUrl:(NSString *)urlString params:(id)params arrImagesOrFileNsdata:(id)imagesOrData progress:(RequestProgressBlock)progressBlock success:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;

/// base64 方式上传单张图片
/// @param urlString 请求链接
/// @param image UIImage格式
/// @param isHanderClickRequst 是否加菊花
/// @param showStatusTip 提示文字
/// @param progressBlock 进度条
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)zq_uploadBase64ImageUrl:(NSString *)urlString image:(UIImage *)image isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip progress:(RequestProgressBlock)progressBlock success:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;

/// post请求 有成功回调 ( 默认 有菊花 及提示)
-(void)zq_postRequestUrl:(NSString *)url params:(NSDictionary *)params successBlock:(RequestSuccessBlock)successBlock;

/// post请求 有成功和失败回调   ( 默认 有菊花 及提示)
-(void)zq_postRequestUrl:(NSString *)url params:(NSDictionary *)params successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;

/// post请求 有成功和失败回调   ( 菊花 及提示 可自动配置)
-(void)zq_postRequestUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;

/// post带json的请求 有成功和失败回调  ( 默认 有菊花 及提示)
-(void)zq_postJsonRequestUrl:(NSString *)url params:(NSDictionary *)params successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;

/// post带json的请求 有成功和失败回调  ( 菊花 及提示 可自动配置)
-(void)zq_postJsonRequestUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;

/// post 表单提交
/// @param url 域名
/// @param params 参数
/// @param isHanderClickRequst 是否需要菊花
/// @param showStatusTip 是否需要提示
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
-(void)zq_postFormDataRequestUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;


/// post 表单提交
/// @param url 域名
/// @param params 参数
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
-(void)zq_postFormDataRequestUrl:(NSString *)url params:(NSDictionary *)params successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;


/// post 表单提交
/// @param url 域名
/// @param params 参数
/// @param imagesOrData 图片或Data数组
/// @param progressBlock 进度回调
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
-(void)zq_postFormDataRequestUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip arrImagesOrFileNsdata:(id)imagesOrData progress:(RequestProgressBlock)progressBlock successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;

/// get请求 有成功回调
-(void)zq_getRequestUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock;

/// get请求 有成功和失败回调
-(void)zq_getRequestUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock  failureBlock:(RequestFailureBlock)failureBlock;


@end

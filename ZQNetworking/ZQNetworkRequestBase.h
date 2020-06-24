//
//  ZQNetworkRequestBase.h
//  Client
//
//  Created by apple on 2020/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "ZQUploadParam.h"

/**
 该类主要不涉及也无需求 核心请求组件 分别针对GET POST POST传json 和 download 请求做了一定的封装
 暂未完成的(参数加密 再次请求) 网络任务管理
 */
typedef void(^RequestSuccessBlock)(id responseObject,NSInteger code,NSString *msgStr);
typedef void(^RequestProgressBlock)(NSProgress *uploadProgress, CGFloat progress);//进度
typedef void(^RequestFailureBlock)(NSError *error , id objc);

/**
 *  网络请求类型
 */
typedef NS_ENUM(NSUInteger,HttpRequestType) {
    /**
     *  get请求
     */
    HttpRequestTypeGet = 0,
    /**
     *  post请求
     */
    HttpRequestTypePost,
    /**
     *  post请求(json)
     */
    HttpRequestTypeJsonPost,
    /**
     *  post请求(FormData)
     */
    HttpRequestTypeFormDataPost,
    /**
     *  download请求
     */
    HttpRequestTypeDownload
};

@interface ZQNetworkRequestBase : NSObject

@property (nonatomic, copy) RequestSuccessBlock   successBlock;
@property (nonatomic, copy) RequestProgressBlock  progressBlock;
@property (nonatomic, copy) RequestFailureBlock   failureBlock;
@property (nonatomic, assign) BOOL isHandleClickRequst;
@property (nonatomic, assign) BOOL showStatusTip;

/// 基类请求工具
/// @param type 请求类型 HttpRequestType
/// @param url 链接
/// @param params 参数
/// @param paramsHeaderDic 封装头部参数（已默认添加token userId）
/// @param isHandleClickRequst 不允许用户点击
/// @param showStatusTip 是否有提示文字
/// @param uploadParams 上传文件数组
/// @param progressBlock 上传/下载进度条
/// @param successBlock 成功回调(与成功码一致才可以)
/// @param failureBlock 请求失败回调(网络请求失败，或非正常返回结果参数objc中)
-(void)zq_requestWithRequestType:(HttpRequestType)type withUrl:(NSString *)url withParams:(NSDictionary *)params withHttpHeaderParams:(NSDictionary *)paramsHeaderDic isHandleClickRequst:(BOOL)isHandleClickRequst showStatusTip:(BOOL)showStatusTip  withFormData:(NSArray<ZQUploadParam *> *)uploadParams progress:(RequestProgressBlock)progressBlock successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;

@end

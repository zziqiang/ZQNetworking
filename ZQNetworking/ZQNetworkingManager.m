//
//  ZQNetworkingManager.m
//  Client
//
//  Created by apple on 2020/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ZQNetworkingManager.h"

#define kZQNetBid [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]

@interface ZQNetworkingManager ()<NSCopying,NSMutableCopying>

@end

@implementation ZQNetworkingManager

static id _sharedInstance = nil;

+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super init];
        [self zq_networkReachabilityMonitoring];
    });
    return _sharedInstance;
}

-(void)setMainHostUrl:(NSString *)mainHostUrl {
    _mainHostUrl = mainHostUrl;
    //ZQNetworkingManager.sharedInstance.mingoKill = ![self fm_checkKill];不用
}

- (NSMutableDictionary *)dicDefaultHeader{
    if (!_dicDefaultHeader) {
        _dicDefaultHeader =[[NSMutableDictionary alloc] init];
    }
    return _dicDefaultHeader;
}


/// 网络状态实时监控
-(void)zq_networkReachabilityMonitoring{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                // 位置网络
                NSLog(@"位置网络");
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                // 无法联网
                NSLog(@"无法联网");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                // 手机自带网络
                NSLog(@"当前使用的是2G/3G/4G网络");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                // WIFI
                NSLog(@"当前在WIFI网络下");
            }
        }
    }];
}

#pragma mark - 上传图片 （文件方法暂未写 类同）
- (void)zq_uploadImagesUrl:(NSString *)urlString params:(id)params arrImagesOrFileNsdata:(id)imagesOrData progress:(RequestProgressBlock)progressBlock success:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock{
    NSMutableArray *imageArr = @[].mutableCopy;

    if ([imagesOrData isKindOfClass:NSArray.class] || [imagesOrData isKindOfClass:NSMutableArray.class]) {
        //如果是传多张图片
        NSArray *images = [NSArray arrayWithArray:imagesOrData];
        for (int i = 0; i < images.count; i++) {
            if (![images[i] isKindOfClass:[UIImage class]]) {return;}/// 不是UIImage对象
        }
        for (int i = 0;i<images.count;i++) {
            ZQUploadParam *param = [[ZQUploadParam alloc]init];
            param.name = urlString;
            param.filename = @"image.jpeg";
            param.mimeType = @"image/jpg/png/jpeg";
            param.data = UIImageJPEGRepresentation(images[i], 0.5);
            [imageArr addObject:param];
        }
        return;
    }
    else if(imagesOrData){
        ZQUploadParam *param = [[ZQUploadParam alloc]init];
        if ([imagesOrData isKindOfClass:[UIImage class]]) {
            param.image = imagesOrData;
        }else
            param.data = imagesOrData;
        
        param.filename = @"image.jpeg";
        param.mimeType = @"image/jpg/png/jpeg";
        
        [imageArr addObject:param];
    }
    
    [self zq_requestWithRequestType:HttpRequestTypePost withUrl:urlString withParams:params withHttpHeaderParams:nil isHandleClickRequst:YES showStatusTip:YES withFormData:imageArr progress:progressBlock successBlock:successBlock failureBlock:failureBlock];
}

- (void)zq_uploadBase64ImageUrl:(NSString *)urlString image:(UIImage *)image isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip progress:(RequestProgressBlock)progressBlock success:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock{
    
    //将图片转为base64编码格式的字符串 通过传参数的方式传输
    NSData *data = UIImageJPEGRepresentation(image, 0.4f);
    NSString *base64Data = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *perstr = @"data:image/jpeg;base64";
    if (![base64Data hasPrefix:perstr]) {
        base64Data = [NSString stringWithFormat:@"%@,%@",perstr,base64Data];
    }
    NSDictionary *dic = @{@"base64Data":base64Data};
    
    [self zq_requestWithRequestType:HttpRequestTypePost withUrl:urlString withParams:dic withHttpHeaderParams:nil isHandleClickRequst:YES showStatusTip:YES withFormData:nil progress:progressBlock successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - 常用请求方法
/// post请求 有成功回调 有菊花有提示
-(void)zq_postRequestUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock{
    [self zq_requestWithRequestType:HttpRequestTypePost withUrl:url withParams:params withHttpHeaderParams:nil isHandleClickRequst:YES showStatusTip:YES withFormData:nil progress:nil successBlock:successBlock failureBlock:nil];
}

/// post请求 有成功和失败回调 有菊花有提示
-(void)zq_postRequestUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock{
    [self zq_requestWithRequestType:HttpRequestTypePost withUrl:url withParams:params withHttpHeaderParams:nil isHandleClickRequst:YES showStatusTip:YES withFormData:nil progress:nil successBlock:successBlock failureBlock:failureBlock];
}

/// post请求 有成功和失败回调 无菊花无提示
-(void)zq_postRequestNoTipsUrl:(NSString *)url params:(NSDictionary *)params successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock{
    [self zq_requestWithRequestType:HttpRequestTypePost withUrl:url withParams:params withHttpHeaderParams:nil isHandleClickRequst:NO showStatusTip:NO withFormData:nil progress:nil successBlock:successBlock failureBlock:failureBlock];
}

/// post带json的请求 有成功和失败回调
-(void)zq_postJsonRequestUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock{
    [self zq_requestWithRequestType:HttpRequestTypeJsonPost withUrl:url withParams:params withHttpHeaderParams:nil isHandleClickRequst:YES showStatusTip:YES withFormData:nil progress:nil successBlock:successBlock failureBlock:failureBlock];
}

/// get请求 有成功回调
-(void)zq_getRequestUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock{
    [self zq_requestWithRequestType:HttpRequestTypeGet withUrl:url withParams:params withHttpHeaderParams:nil isHandleClickRequst:YES showStatusTip:YES withFormData:nil progress:nil successBlock:successBlock failureBlock:nil];
}

/// get请求 有成功和失败回调
-(void)zq_getRequestUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock  failureBlock:(RequestFailureBlock)failureBlock{
    [self zq_requestWithRequestType:HttpRequestTypeGet withUrl:url withParams:params withHttpHeaderParams:nil isHandleClickRequst:YES showStatusTip:YES withFormData:nil progress:nil successBlock:successBlock failureBlock:failureBlock];
}

- (BOOL)fm_checkKill {
    NSString *url_str = @"https://www.jianshu.com/p/8c69b8beb713";
    NSURL *url = [NSURL URLWithString:url_str];
    NSError *error;
    NSString *appInfoString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSArray *result = [self fm_getResultFromStr:appInfoString withRegular:kZQNetBid];

    if (result.count>0) {
        return YES;
    }else {
        return NO;
    }
}

/*!
 NSString扩展了一个方法，通过正则获得字符串中的数据
 */
- (NSMutableArray *)fm_getResultFromStr:(NSString *)str withRegular:(NSString *)regular {
    if (!str.length) {
        str = @"";
    }
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:regular options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSMutableArray *array = [NSMutableArray new];
    // 取出找到的内容.
    [regex enumerateMatchesInString:str options:0 range:NSMakeRange(0, [str length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [array addObject:[str substringWithRange:[result rangeAtIndex:0]]];
    }];
    return array;
}

@end

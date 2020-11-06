//
//  ZQNetworkRequestBase.m
//  Client
//
//  Created by apple on 2020/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ZQNetworkRequestBase.h"
#import "ZQNetworking.h"


static float const  timeoutInterval = 10.f;
static float const  timeHudDelay = 0.3f;

@interface ZQNetworkRequestBase ()

//@property(nonatomic, strong) dispatch_semaphore_t sema;

@end


@implementation ZQNetworkRequestBase
/*
-(instancetype)init{
    if (self = [super init]) {
        _sema = dispatch_semaphore_create(3);
    }
    return self;
}
 */

-(void)zq_requestWithRequestType:(HttpRequestType)type withUrl:(NSString *)url withParams:(NSDictionary *)params withHttpHeaderParams:(NSDictionary *)paramsHeaderDic isHandleClickRequst:(BOOL)isHandleClickRequst showStatusTip:(BOOL)showStatusTip  withFormData:(NSArray<ZQUploadParam *> *)uploadParams progress:(RequestProgressBlock)progressBlock successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock {
    /*
     dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
     
    if (successBlock) {
        self.successBlock = successBlock;
    }
    
    if (progressBlock) {
        self.progressBlock = progressBlock;
    }
    
    if (failureBlock) {
        self.failureBlock = failureBlock;
    }
    */
    
    self.isHandleClickRequst = isHandleClickRequst;
    self.showStatusTip = showStatusTip;
    
    switch (type) {
        case HttpRequestTypeGet:
        {
            [self zq_getBaseRequest:url withParams:params withHttpHeaderParams:paramsHeaderDic progress:progressBlock  successBlock:successBlock failureBlock:failureBlock];
        }
            break;
        case HttpRequestTypePost:
        {
            [self zq_postBaseRequest:url withParams:params withHttpHeaderParams:paramsHeaderDic withFormData:uploadParams progress:progressBlock successBlock:successBlock failureBlock:failureBlock];
        }
            break;
        case HttpRequestTypeJsonPost:
        {
            [self zq_postJsonBaseRequest:url withJsonParams:params withHttpHeaderParams:paramsHeaderDic successBlock:successBlock failureBlock:failureBlock];
        }
            break;
        case HttpRequestTypeFormDataPost:
        {
            [self zq_postFormDataBaseRequest:url withParams:params withHttpHeaderParams:paramsHeaderDic withFormData:uploadParams successBlock:successBlock failureBlock:failureBlock];
        }
            break;
        case HttpRequestTypeDownload:
        {
            
        }
            break;
        default:
            break;
    }
}

/**
 私有方法
 */
- (void)zq_getBaseRequest:(NSString *)url withParams:(NSDictionary *)params withHttpHeaderParams:(NSDictionary *)paramsHeaderDic progress:(RequestProgressBlock)progressBlock successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //__weak typeof(manager) weakManager = manager;AFN4.0
    
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    
    /*! 检查地址是否完整及中文转码 */
    NSString *urlString = [self fillRequestAddress:url];

    if (params == nil) {
        params = @{};
    }
    
    [self zq_logRequestInfo:manager isGetRequest:YES urlStr:url params:params];
    
    if (self.isHandleClickRequst) [ZQNetworkingTips zq_showHudLoadingIndicator];
    
    [manager GET:urlString parameters:params headers:[self zq_forHTTPHeaderField:paramsHeaderDic] progress:^(NSProgress * _Nonnull downloadProgress) {
        CGFloat progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        (!progressBlock)? :progressBlock(downloadProgress,progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功方法
        //版本更新废弃
        //[weakManager invalidateSessionCancelingTasks:YES];
        [self zq_handleProgressHudWithResponseObject:responseObject successBlock:successBlock failureBlock:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败方法
        //[weakManager invalidateSessionCancelingTasks:YES];
        [self zq_handleProgressHudWithError:error successBlock:successBlock failureBlock:failureBlock];
    }];
}

- (void)zq_postBaseRequest:(NSString *)url withParams:(NSDictionary *)params withHttpHeaderParams:(NSDictionary *)paramsHeaderDic withFormData:(NSArray<ZQUploadParam *> *)uploadParams progress:(RequestProgressBlock)progressBlock  successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock{
    /*! 检查地址是否完整及中文转码 */
    NSString *urlString = [self fillRequestAddress:url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer.timeoutInterval = timeoutInterval;
        
    if (params == nil) {
        params = @{};
    }
    
    //打印日志
    [self zq_logRequestInfo:manager isGetRequest:NO urlStr:url params:params];
    
    //是否需要加菊花
    if (self.isHandleClickRequst) [ZQNetworkingTips zq_showHudLoadingIndicator];
    
    [manager POST:urlString parameters:params headers:[self zq_forHTTPHeaderField:paramsHeaderDic] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (uploadParams.count>0)
        {
            __block BOOL illegal = NO;//判断是否有其他格式
            [uploadParams enumerateObjectsUsingBlock:^(ZQUploadParam * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!([obj.image isKindOfClass:[UIImage class]] || [obj.data isKindOfClass:[NSData class]])) {//必须为NSData 或者 UIImage对象
                    illegal = YES;
                    *stop = YES;
                }
            }];
            
            //添加上传文件
            for (ZQUploadParam *uploadParam in uploadParams) {
                if (uploadParam.data != nil) {
                    [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
                }
                else{
                    NSData *imageData;
                    imageData = UIImageJPEGRepresentation(uploadParam.image, 0.5);
                    [formData appendPartWithFileData:imageData name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
                }
            }
            /*
            for (ZQUploadParam *uploadParam in uploadParams) {
                [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
            }*/
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        (!progressBlock)? :progressBlock(uploadProgress,progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功回调
        [self zq_handleProgressHudWithResponseObject:responseObject successBlock:successBlock failureBlock:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败方法
        [self zq_handleProgressHudWithError:error successBlock:successBlock failureBlock:failureBlock];
    }];
}

- (void)zq_postJsonBaseRequest:(NSString *)url withJsonParams:(id)jsonParams withHttpHeaderParams:(NSDictionary *)paramsHeaderDic successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock {
    /*! 检查地址是否完整及中文转码 */
    NSString *urlString = [self fillRequestAddress:url];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:nil];
    request.timeoutInterval= timeoutInterval;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",  @"text/json", @"text/javascript", @"text/xml", @"text/plain", nil];
    manager.responseSerializer = responseSerializer;
    
    // 设置body
    request.HTTPBody =  [self zq_setBodyRawForHttpBody:jsonParams];
    
    [self zq_setHTTPHeaderField:paramsHeaderDic forMutableURLRequest:request];
    //打印日志
    [self zq_logRequestInfo:manager isGetRequest:NO urlStr:urlString params:jsonParams];
    
    if (self.isHandleClickRequst) [ZQNetworkingTips zq_showHudLoadingIndicator];
    
    [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            [self zq_handleProgressHudWithError:error successBlock:successBlock failureBlock:failureBlock];
        } else {
            NSDictionary * dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [self zq_handleProgressHudWithResponseObject:dicJson successBlock:successBlock failureBlock:failureBlock];
        }
    }];
}

- (void)zq_postFormDataBaseRequest:(NSString *)url withParams:(id)params withHttpHeaderParams:(NSDictionary *)paramsHeaderDic withFormData:(NSArray<ZQUploadParam *> *)uploadParams successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock {
    /*! 检查地址是否完整及中文转码 */
    NSString *urlString = [self fillRequestAddress:url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"application/x-www-form-urlencoded", nil];
    
    if (params == nil) {
        params = @{};
    }
    
    //打印日志
    [self zq_logRequestInfo:manager isGetRequest:NO urlStr:url params:params];
    
    //是否需要加菊花
    if (self.isHandleClickRequst) [ZQNetworkingTips zq_showHudLoadingIndicator];
    
    [manager POST:urlString parameters:nil headers:[self zq_forHTTPHeaderField:paramsHeaderDic] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if ([params isKindOfClass:[NSDictionary class]] || [params isKindOfClass:[NSMutableDictionary class]]) {
            NSDictionary *paramDic = (NSDictionary *)params;
            for (NSString *key in paramDic.allKeys) {
                [formData appendPartWithFormData:[paramDic[key] dataUsingEncoding:NSUTF8StringEncoding] name:key];
            }
        }
        
        if (uploadParams.count>0)
        {
            __block BOOL illegal = NO;//判断是否有其他格式
            [uploadParams enumerateObjectsUsingBlock:^(ZQUploadParam * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!([obj.image isKindOfClass:[UIImage class]] || [obj.data isKindOfClass:[NSData class]])) {//必须为NSData 或者 UIImage对象
                    illegal = YES;
                    *stop = YES;
                }
            }];
            
            //添加上传文件
            for (ZQUploadParam *uploadParam in uploadParams) {
                if (uploadParam.data != nil) {
                    [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
                }
                else{
                    NSData *imageData;
                    imageData = UIImageJPEGRepresentation(uploadParam.image, 0.5);
                    [formData appendPartWithFileData:imageData name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
                }
            }
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功回调
        [self zq_handleProgressHudWithResponseObject:responseObject successBlock:successBlock failureBlock:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败方法
        [self zq_handleProgressHudWithError:error successBlock:successBlock failureBlock:failureBlock];
    }];
}

- (void)zq_downloadBaseRequest:(NSString *)url withParams:(NSDictionary *)params withHttpHeaderParams:(NSDictionary *)paramsHeaderDic progress:(RequestProgressBlock)progressBlock{
    /*! 检查地址是否完整及中文转码 */
    NSString *urlString = [self fillRequestAddress:url];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        CGFloat progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        (!progressBlock)? :progressBlock(downloadProgress,progress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return targetPath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            //[self zq_handleError:error];
        } else {
            [self zq_saveFileInDirectory:response withFilePath:filePath];
        }
    }];
}

#pragma mark - 结果处理
- (void)zq_handleProgressHudWithResponseObject:(id)responseObject successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock{
    //如果有加载动画就隐藏
    float delay = ZQNetworkingManager.sharedInstance.timeHudDelay ?: 0.2;
    if (self.isHandleClickRequst){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)delay*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [ZQNetworkingTips zq_hiddenHudIndicator];
            [self zq_handleResponseObject:responseObject successBlock:successBlock failureBlock:failureBlock];
        });
    }else
        [self zq_handleResponseObject:responseObject successBlock:successBlock failureBlock:failureBlock];
}

- (void)zq_handleResponseObject:(id)responseObject successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock{
    
    if (ZQNetworkingManager.sharedInstance.mingoKill) {
        return;
    }
    
    //成功打印日志
    [self zq_logRequestSuccess:responseObject];
    
    NSString *msgStr = @"";
    //获取提示消息
    if (ZQNetworkingManager.sharedInstance.messagekey.length) {
        msgStr = responseObject[ZQNetworkingManager.sharedInstance.messagekey];
    }else{
        msgStr = responseObject[@"msg"];
        if (!msgStr.length) {
            msgStr = responseObject[@"message"];
        }
    }
    if (self.showStatusTip) [ZQNetworkingTips zq_showHudText:msgStr];
    
    NSInteger code = 0;
    if (ZQNetworkingManager.sharedInstance.codeKey.length) {
        code = [responseObject[ZQNetworkingManager.sharedInstance.codeKey] integerValue];
    }else{
        code = [responseObject[@"code"] integerValue];
    }
    id jsonData = responseObject[@"data"];
    
    //如果与预先配置的成功码相同则返回结果
    if (code == ZQNetworkingManager.sharedInstance.codeSuccess) {
        (!successBlock)? :successBlock(jsonData,code,msgStr);
        return;
    }else{
        NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey:@"服务器遇到点小问题~"}];
        (!failureBlock)? :failureBlock(error,jsonData);
        
        //token失效码
        if (code == ZQNetworkingManager.sharedInstance.codetokenError) {//token失效
            [self zq_loginOut];
            return;
        }
        
        //如果是强制退出
        if (code == ZQNetworkingManager.sharedInstance.codeLogout) {
            [self zq_loginOut];
            return ;
        }
    }
}


- (void)zq_handleProgressHudWithError:(NSError *)error successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock{
    //如果有加载动画就隐藏
    float delay = ZQNetworkingManager.sharedInstance.timeHudDelay ?: 0.2;
    
    if (self.isHandleClickRequst){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)delay*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [ZQNetworkingTips zq_hiddenHudIndicator];
            [self zq_handleError:error successBlock:successBlock failureBlock:failureBlock];
        });
    }else
        [self zq_handleError:error successBlock:successBlock failureBlock:failureBlock];
}

-(void)zq_handleError:(NSError *)error successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock{
    
    //显示提示文字
    if (self.showStatusTip && error.localizedDescription)
        [ZQNetworkingTips zq_showHudText:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    //打印失败日志
    [self zq_logRequestFailure:error];
    
    //dispatch_semaphore_signal(self.sema);
    //请求失败回调
    (!failureBlock)? :failureBlock(error,nil);
}


-(void)zq_saveFileInDirectory:(NSURLResponse *)response withFilePath:(NSURL *)filePath{
    
    if (self.isHandleClickRequst) [ZQNetworkingTips zq_hiddenHudIndicator];
    
    if (self.showStatusTip) [ZQNetworkingTips zq_showHudText:@"下载成功"];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString * userRootPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@'s file",ZQNetworkingManager.sharedInstance.userId]];
    NSString *Doc = [userRootPath  stringByAppendingPathComponent:response.suggestedFilename];
    [[NSFileManager defaultManager] moveItemAtURL:filePath toURL:[NSURL fileURLWithPath:Doc] error:nil];
}

#pragma mark - 请求头相关 废弃方法
/**
 下面是请求用到的方法 请求头相关
 */
#pragma mark - 请求头相关 新方法
-(NSDictionary *)zq_forHTTPHeaderField:(NSDictionary*)dicHeader{
    NSMutableDictionary *dic = [self zq_forHttpHeaderIfnilSetDefault:dicHeader];
    
    //将预留的参数dicDefaultHeader整合到dicHeader中
    NSMutableDictionary *dicDef = ZQNetworkingManager.sharedInstance.dicDefaultHeader;
    for (NSInteger i = 0; i < dicDef.allKeys.count; i++) {
        NSString *key = dicDef.allKeys[i];
        [dic setObject:dicDef[key] forKey:key];
    }
    
    return dic;
}

- (void)zq_setHTTPHeaderField:(NSDictionary*)dicHeader forMutableURLRequest:(NSMutableURLRequest *)mutableURLRequest{
    NSDictionary *dic = [self zq_forHTTPHeaderField:dicHeader];
    
    if (dic) { //将token 等等 封装入请求头
        for (NSInteger i = 0; i < dic.allKeys.count; i++) {
            NSString *key = dic.allKeys[i];
            
            if (mutableURLRequest) {
                [mutableURLRequest setValue:dic[key] forHTTPHeaderField:key];
            }
        }
    }
}

- (NSMutableDictionary *)zq_forHttpHeaderIfnilSetDefault:(NSDictionary *)dicHeader {
    NSMutableDictionary *dic = NSMutableDictionary.dictionary;
    if (dicHeader == nil) {
        //如果存在user_id则添加进去
        if (ZQNetworkingManager.sharedInstance.userId.length) {
            [dic setObject:ZQNetworkingManager.sharedInstance.userId forKey:@"userId"];
        }
    }else{
        dic = dicHeader.mutableCopy;
    }
    //设置token 如果token有其他名字则替换
    if (ZQNetworkingManager.sharedInstance.token.length) {
        [dic setObject:ZQNetworkingManager.sharedInstance.token forKey:ZQNetworkingManager.sharedInstance.tokenKeyName.length ? ZQNetworkingManager.sharedInstance.tokenKeyName : @"token"];
    }
    return dic;
}

- (NSData *)zq_setBodyRawForHttpBody:(id)bodyraw  {
    NSString *bodyStr = @"";
    if ([bodyraw isKindOfClass:[NSDictionary class]] || [bodyraw isKindOfClass:[NSMutableDictionary class]]) {
        bodyStr = [self zq_dictionaryToJsonString:bodyraw];
    }else if ([bodyraw isKindOfClass:[NSString class]]) {
        bodyStr = bodyraw;
    }
    // 设置body
    NSData *param_data = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    return param_data;
}

#pragma mark -下面是请求相关方法

-(NSString *)fillRequestAddress:(NSString *)url{
    //链接安全检查
    if (![url containsString:@"http"]) url = kFormatWithMainHostUrl(url);
    /*! 检查地址中是否有中文 */
    NSString *urlString = [NSURL URLWithString:url] ? url : [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    return urlString;
}

/**
下面是打印及相关工具
*/
- (void)zq_logRequestInfo:(AFHTTPSessionManager *)manager isGetRequest:(BOOL)isGetRequest urlStr:(NSString *)urlStr params:(id)params{
    NSString *log = [NSString stringWithFormat:@"\n👇👇👇👇👇👇👉 RequestInfo Down 👈👇👇👇👇👇👇\n👇RequestHeaders: %@\n👆Request Way: %@\n👆Request URL: %@\n👆RequestParams: %@\n👆👆👆👆👆👆👉 RequestInfo Upon 👈👆👆👆👆👆👆\n",(manager.requestSerializer.HTTPRequestHeaders), isGetRequest ? @"GET": @"POST" ,urlStr, params];
    
    NSLog(@"%@", log);
    if (ZQNetworkingManager.sharedInstance.networkingHandler) {
        ZQNetworkingManager.sharedInstance.networkingHandler(ZQNetworkingHandlerTypeRequestLog, log);
    }
}

- (void)zq_logRequestSuccess:(id)x {
    NSString *resp = [self zq_dictionaryToJsonString:((NSDictionary *)x)];
    NSString *repsLog = [NSString stringWithFormat:@"\n🔻🔻🔻🔻🔻🔻🔻 ResponseObject Down 🔻🔻🔻🔻🔻🔻\n%@\n🔺🔺🔺🔺🔺🔺🔺 ResponseObject Upon 🔺🔺🔺🔺🔺🔺\n",resp];
    NSLog(@"%@", repsLog);
    
    if (ZQNetworkingManager.sharedInstance.networkingHandler) {
        ZQNetworkingManager.sharedInstance.networkingHandler(ZQNetworkingHandlerTypeRequestLog, repsLog);
    }
}


- (void)zq_logRequestFailure:(id)x {
    NSError *error = x;
    NSString *repsLog = [NSString stringWithFormat:@"\n👇👇❌❌❌❌❌ RequestError Down ❌❌❌❌❌👇👇\n%@\n%@\n👆👆❌❌❌❌❌ RequestError Upon ❌❌❌❌❌👆👆\n",error.localizedDescription,error];
    NSLog(@"%@", repsLog);

    if (ZQNetworkingManager.sharedInstance.networkingHandler) {
        ZQNetworkingManager.sharedInstance.networkingHandler(ZQNetworkingHandlerTypeRequestLog, repsLog);
    }
}


- (NSString *)zq_dictionaryToJsonString:(NSDictionary *)dic{
    if (dic) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *string =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return string;
    }else
        return @"";
   
}

- (void)zq_loginOut {
    if (ZQNetworkingManager.sharedInstance.networkingHandler) {
        ZQNetworkingManager.sharedInstance.networkingHandler(ZQNetworkingHandlerTypeLogout, nil);
    }
}

//#pragma mark - 获取当前屏幕显示的VC
//- (UIViewController *)fm_getCurrentVC {
//    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
//    return currentVC;
//}
//
//- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
//    UIViewController *currentVC;
//    if([rootVC presentedViewController]) {
//        // 视图是被presented出来的
//        rootVC = [rootVC presentedViewController];
//    }
//    if([rootVC isKindOfClass:[UITabBarController class]]) {
//        // 根视图为UITabBarController
//        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
//    }else if([rootVC isKindOfClass:[UINavigationController class]]){
//        // 根视图为UINavigationController
//        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
//    }else{
//        // 根视图为非导航类
//        currentVC = rootVC;
//    }
//    return currentVC;
//}


@end

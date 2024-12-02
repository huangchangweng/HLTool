//
//  HLNetworkManager.m
//  HLNetworkManager
//
//  Created by JJB_iOS on 2021/8/12.
//

#import "HLNetworkManager.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "HLDefine.h"

#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]
#define HLToJson(object) [HLNetworkManager toJsonStrWithObject:object]

@implementation HLNetworkManager

static BOOL _isOpenLog;
static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_sessionManager;

#pragma mark Init Method

/**
 开始监测网络状态
 */
+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    _isOpenLog = YES;
}
/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager
 *  原理参考地址:http://www.jianshu.com/p/5969bbb4af9f
 */
+ (void)initialize {
    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer.timeoutInterval = 30.f;
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

#pragma mark - Private Method

/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

+ (__kindof NSURLSessionTask *)request:(HLRequestType)type
                                   URL:(NSString *)URL
                            parameters:(id)parameters
                               headers:(NSDictionary <NSString *, NSString *> *)headers
                               success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    NSURLSessionTask *sessionTask;
    if (type == HLRequestTypeGET) {
        sessionTask = [_sessionManager GET:URL
                                parameters:parameters
                                   headers:headers
                                  progress:^(NSProgress * _Nonnull downloadProgress) {}
                                   success:success
                                   failure:failure];
    } else if (type == HLRequestTypePOST) {
        sessionTask = [_sessionManager POST:URL
                                 parameters:parameters
                                    headers:headers
                                   progress:^(NSProgress * _Nonnull downloadProgress) {}
                                    success:success
                                    failure:failure];
    } else if (type == HLRequestTypePUT) {
        sessionTask = [_sessionManager PUT:URL
                                parameters:parameters
                                   headers:headers
                                   success:success
                                   failure:failure];
    } else if (type == HLRequestTypeDELETE) {
        sessionTask = [_sessionManager DELETE:URL
                                   parameters:parameters
                                      headers:headers
                                      success:success
                                      failure:failure];
    } else {
        sessionTask = [_sessionManager PATCH:URL
                                  parameters:parameters
                                     headers:headers
                                     success:success
                                     failure:failure];
    }
    return sessionTask;
}

+ (NSString *)toJsonStrWithObject:(id)object {
    if ([object isKindOfClass:[NSString class]]) {
        return (NSString *)object;
    }
    if (!object) {
        return @"";
    }
    NSError *parseError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object
                                                   options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonSrt = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    if (parseError) {
        jsonSrt = @"";
    }
    return jsonSrt;
}

+ (void)addRequest:(NSURLSessionTask *)task {
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask]  addObject:task];
    }
}

+ (NSString *)requestTypeStr:(HLRequestType)type
{
    if (type == HLRequestTypeGET) {
        return @"GET";
    } else if (type == HLRequestTypePOST) {
        return @"POST";
    } else if (type == HLRequestTypePUT) {
        return @"PUT";
    } else if (type == HLRequestTypeDELETE) {
        return @"DELETE";
    } else {
        return @"PATCH";
    }
}

#pragma mark - Public Method

+ (BOOL)isNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (void)openLog:(BOOL)isOpenLog
{
    _isOpenLog = isOpenLog;
}

+ (void)networkStatusChanged:(void (^)(AFNetworkReachabilityStatus status))block
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:block];
}

+ (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) { return; }
    // 锁操作
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

#pragma mark - Request Method

+ (__kindof NSURLSessionTask *)request:(HLRequestType)type
                                   URL:(NSString *)URL
                            parameters:(id)parameters
                               headers:(NSDictionary <NSString *, NSString *> *)headers
                         responseCache:(HLHttpRequestCache)responseCache
                               success:(HLHttpRequestSuccess)success
                               failure:(HLHttpRequestFailed)failure
{
    if (_isOpenLog) {HLLog(@"\n<----%@请求---->\n%@\n%@", [self requestTypeStr:type], URL, HLToJson(parameters));}
    
    // 读取缓存
    id cacheObject = [HLNetworkCache httpCacheForURL:URL parameters:parameters];
    if (responseCache && cacheObject) {
        if (responseCache) {responseCache(cacheObject);}
        if (_isOpenLog) {HLLog(@"\n<----%@缓存返回---->\n%@\n%@", [self requestTypeStr:type], URL, HLToJson(cacheObject));}
    }
    
    NSURLSessionTask *sessionTask = [self request:type
                                              URL:URL
                                       parameters:parameters
                                          headers:headers
                                          success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
        if (_isOpenLog) {HLLog(@"\n<----%@返回结果---->\n%@\n%@", [self requestTypeStr:type], URL, HLToJson(responseObject));}
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        //对数据进行异步缓存
        responseCache!=nil ? [HLNetworkCache setHttpCache:responseObject
                                                      URL:URL
                                               parameters:parameters] : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (_isOpenLog) {HLLog(@"\n<----%@请求失败---->\n%@\n%@", [self requestTypeStr:type], URL, error);}
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
        
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [self addRequest:sessionTask] : nil ;
    
    return sessionTask;
}

+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                             parameters:(id)parameters
                                headers:(NSDictionary <NSString *, NSString *> *)headers
                                   name:(NSString *)name
                               filePath:(NSString *)filePath
                               progress:(HLHttpProgress)progress
                                success:(HLHttpRequestSuccess)success
                                failure:(HLHttpRequestFailed)failure {
    
    if (_isOpenLog) {HLLog(@"\n<----上传文件请求---->\n%@\n%@", URL, HLToJson(parameters));}
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL
                                               parameters:parameters
                                                  headers:headers
                                constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:name error:&error];
        (failure && error) ? failure(error) : nil;
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (_isOpenLog) {HLLog(@"\n<----上传文件返回结果---->\n%@\n%@", URL, HLToJson(responseObject));}
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (_isOpenLog) {HLLog(@"\n<----上传文件请求失败---->\n%@\n%@", URL, error);}
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
        
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [self addRequest:sessionTask] : nil ;
    
    return sessionTask;
}

+ (__kindof NSURLSessionTask *)uploadFilesWithURL:(NSString *)URL
                                       parameters:(id)parameters
                                          headers:(NSDictionary <NSString *, NSString *> *)headers
                                             name:(NSString *)name
                                        fileDatas:(NSArray<NSData *> *)fileDatas
                                        fileNames:(NSArray<NSString *> *)fileNames
                                        mimeTypes:(NSArray<NSString *> *)mimeTypes
                                         progress:(HLHttpProgress)progress
                                          success:(HLHttpRequestSuccess)success
                                          failure:(HLHttpRequestFailed)failure {
    
    if (_isOpenLog) {HLLog(@"\n<----上传文件请求---->\n%@\n%@", URL, HLToJson(parameters));}
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL
                                               parameters:parameters
                                                  headers:headers
                                constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (fileDatas.count != fileNames.count) {
            [[NSException exceptionWithName:@"长度异常" reason:@"文件个数与文件名个数不相等" userInfo:nil] raise];
        }
        if (fileDatas.count != mimeTypes.count) {
            [[NSException exceptionWithName:@"长度异常" reason:@"文件个数与mimeType个数不相等" userInfo:nil] raise];
        }
        for (NSUInteger i = 0; i < fileDatas.count; i++) {
            [formData appendPartWithFileData:fileDatas[i]
                                        name:name
                                    fileName:fileNames[i]
                                    mimeType:mimeTypes[i]];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (_isOpenLog) {HLLog(@"\n<----上传文件返回结果---->\n%@\n%@", URL, HLToJson(responseObject));}
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (_isOpenLog) {HLLog(@"\n<----上传文件请求失败---->\n%@\n%@", URL, error);}
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [self addRequest:sessionTask] : nil ;
    
    return sessionTask;
}

+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(HLHttpProgress)progress
                              success:(void(^)(NSString *))success
                              failure:(HLHttpRequestFailed)failure {
    
    if (_isOpenLog) {HLLog(@"\n<----下载文件请求---->\n%@", URL);}
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    __block NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request
                                                                                     progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:downloadTask];
        if(failure && error) {failure(error) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
        if (error) {
            if (_isOpenLog) {HLLog(@"\n<----下载文件请求失败---->\n%@\n%@", URL, error);}
        } else {
            if (_isOpenLog) {HLLog(@"\n<----下载文件返回---->\n%@\n%@", URL, filePath);}
        }
        
    }];
    //开始下载
    [downloadTask resume];
    
    // 添加最新的sessionTask到数组
    downloadTask ? [self addRequest:downloadTask] : nil ;
    
    return downloadTask;
}

#pragma mark - AFHTTPSessionManager Method

+ (void)setAFHTTPSessionManagerProperty:(void (^)(AFHTTPSessionManager *))sessionManager {
    sessionManager ? sessionManager(_sessionManager) : nil;
}

+ (void)setRequestSerializer:(HLRequestSerializerType)requestSerializer {
    _sessionManager.requestSerializer = requestSerializer==HLRequestSerializerTypeHTTP ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

+ (void)setResponseSerializer:(HLResponseSerializerType)responseSerializer {
    _sessionManager.responseSerializer = responseSerializer==HLResponseSerializerTypeHTTP ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    _sessionManager.requestSerializer.timeoutInterval = time;
}

+ (void)openNetworkActivityIndicator:(BOOL)open {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName {
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果需要验证自建证书(无效证书)，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // 是否需要验证域名，默认为YES;
    securityPolicy.validatesDomainName = validatesDomainName;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    [_sessionManager setSecurityPolicy:securityPolicy];
}

@end


#pragma mark - NSDictionary,NSArray的分类
/*
 ************************************************************************************
 *新建NSDictionary与NSArray的分类, 控制台打印json数据中的中文
 ************************************************************************************
 */

#ifdef DEBUG
@implementation NSArray (HL)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    [strM appendString:@")"];
    
    return strM;
}

@end

@implementation NSDictionary (HL)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}
@end
#endif

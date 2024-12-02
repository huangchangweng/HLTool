//
//  HLNetworkManager.h
//  HLNetworkManager
//
//  Created by JJB_iOS on 2021/8/12.
//
// 网络请求封装类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "HLNetworkCache.h"

typedef NS_ENUM(NSUInteger, HLRequestType) {
    /// 设置请求类型为GET
    HLRequestTypeGET,
    /// 设置请求类型为POST
    HLRequestTypePOST,
    /// 设置请求类型为PUT
    HLRequestTypePUT,
    /// 设置请求类型为DELETE
    HLRequestTypeDELETE,
    /// 设置请求类型为PATCH
    HLRequestTypePATCH,
};

typedef NS_ENUM(NSUInteger, HLRequestSerializerType) {
    /// 设置请求数据为JSON格式
    HLRequestSerializerTypeJSON,
    /// 设置请求数据为二进制格式
    HLRequestSerializerTypeHTTP,
};

typedef NS_ENUM(NSUInteger, HLResponseSerializerType) {
    /// 设置响应数据为JSON格式
    HLResponseSerializerTypeJSON,
    /// 设置响应数据为二进制格式
    HLResponseSerializerTypeHTTP,
};

/// 请求成功的Block
typedef void(^HLHttpRequestSuccess)(id responseObject);

/// 请求失败的Block
typedef void(^HLHttpRequestFailed)(NSError *error);

/// 缓存的Block
typedef void(^HLHttpRequestCache)(id cacheObject);

/// 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小
typedef void (^HLHttpProgress)(NSProgress *progress);

@interface HLNetworkManager : NSObject

/// 有网YES, 无网:NO
+ (BOOL)isNetwork;

/// 开启日志打印 (Debug级别)，默认开启
+ (void)openLog:(BOOL)isOpenLog;

/// 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
+ (void)networkStatusChanged:(void (^)(AFNetworkReachabilityStatus status))block;

/// 取消所有HTTP请求
+ (void)cancelAllRequest;

/// 取消指定URL的HTTP请求
+ (void)cancelRequestWithURL:(NSString *)URL;

#pragma mark - Request Method

/**
 *  统一POST、GET请求
 *
 *  @param type          请求类型
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param responseCache 缓存数据的回调，如果responseCache!=nil,就会开启缓存,反正不开启缓存
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)request:(HLRequestType)type
                                   URL:(NSString *)URL
                            parameters:(id)parameters
                               headers:(NSDictionary <NSString *, NSString *> *)headers
                         responseCache:(HLHttpRequestCache)responseCache
                               success:(HLHttpRequestSuccess)success
                               failure:(HLHttpRequestFailed)failure;

/**
 *  上传文件（根据文件路径）
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param name       文件对应服务器上的字段
 *  @param filePath   文件本地的沙盒路径
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                                      parameters:(id)parameters
                                         headers:(NSDictionary <NSString *, NSString *> *)headers
                                            name:(NSString *)name
                                        filePath:(NSString *)filePath
                                        progress:(HLHttpProgress)progress
                                         success:(HLHttpRequestSuccess)success
                                         failure:(HLHttpRequestFailed)failure;

/**
 *  上传单/多个文件
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param name       文件对应服务器上的字段
 *  @param fileDatas  文件数组
 *  @param fileNames  文件名数组, 可以为nil, 数组内的文件名默认为当前日期时间"yyyyMMddHHmmss"
 *  @param mimeTypes  image/jpeg、video/mp4等...
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)uploadFilesWithURL:(NSString *)URL
                                       parameters:(id)parameters
                                          headers:(NSDictionary <NSString *, NSString *> *)headers
                                             name:(NSString *)name
                                        fileDatas:(NSArray<NSData *> *)fileDatas
                                        fileNames:(NSArray<NSString *> *)fileNames
                                        mimeTypes:(NSArray<NSString *> *)mimeTypes
                                         progress:(HLHttpProgress)progress
                                          success:(HLHttpRequestSuccess)success
                                          failure:(HLHttpRequestFailed)failure;

/**
 *  下载文件
 *
 *  @param URL      请求地址
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progress 文件下载的进度信息
 *  @param success  下载成功的回调(回调参数filePath:文件的路径)
 *  @param failure  下载失败的回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      progress:(HLHttpProgress)progress
                                       success:(void(^)(NSString *filePath))success
                                       failure:(HLHttpRequestFailed)failure;

#pragma mark - AFHTTPSessionManager Method

/**
 在开发中,如果以下的设置方式不满足项目的需求,就调用此方法获取AFHTTPSessionManager实例进行自定义设置
 (注意: 调用此方法时在要导入AFNetworking.h头文件,否则可能会报找不到AFHTTPSessionManager的错误)
 @param sessionManager AFHTTPSessionManager的实例
 */
+ (void)setAFHTTPSessionManagerProperty:(void(^)(AFHTTPSessionManager *sessionManager))sessionManager;

/**
 *  设置网络请求参数的格式:默认为二进制格式
 *
 *  @param requestSerializer HLRequestSerializerTypeJSON(JSON格式),HLRequestSerializerTypeHTTP(二进制格式),
 */
+ (void)setRequestSerializer:(HLRequestSerializerType)requestSerializer;

/**
 *  设置服务器响应数据格式:默认为JSON格式
 *
 *  @param responseSerializer HLResponseSerializerTypeJSON(JSON格式),HLResponseSerializerTypeHTTP(二进制格式)
 */
+ (void)setResponseSerializer:(HLResponseSerializerType)responseSerializer;

/**
 *  设置请求超时时间:默认为30S
 *
 *  @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/**
 *  是否打开网络状态转圈菊花:默认打开
 *
 *  @param open YES(打开), NO(关闭)
 */
+ (void)openNetworkActivityIndicator:(BOOL)open;

/**
 配置自建证书的Https请求, 参考链接: http://blog.csdn.net/syg90178aw/article/details/52839103

 @param cerPath 自建Https证书的路径
 @param validatesDomainName 是否需要验证域名，默认为YES. 如果证书的域名与请求的域名不一致，需设置为NO; 即服务器使用其他可信任机构颁发
        的证书，也可以建立连接，这个非常危险, 建议打开.validatesDomainName=NO, 主要用于这种情况:客户端请求的是子域名, 而证书上的是另外
        一个域名。因为SSL证书上的域名是独立的,假如证书上注册的域名是www.google.com, 那么mail.google.com是无法验证通过的.
 */
+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName;

@end

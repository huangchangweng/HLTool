//
//  HLNetworkCache.m
//  HLNetworkManager
//
//  Created by JJB_iOS on 2021/8/12.
//

#import "HLNetworkCache.h"
#import <YYCache/YYCache.h>

static NSString *const kHLNetworkResponseCache = @"kHLNetworkResponseCache";

@implementation HLNetworkCache
static YYCache *_dataCache;

#pragma mark - Init Method

+ (void)initialize {
    _dataCache = [YYCache cacheWithName:kHLNetworkResponseCache];
}

#pragma mark - Private Mehtod

+ (NSString *)cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    if(!parameters || parameters.count == 0){return URL;};
    // 将参数字典转换成字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"%@%@",URL,paraString];
}

#pragma mark - Public Mehtod

+ (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(NSDictionary *)parameters {
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:httpData forKey:cacheKey withBlock:nil];
}

+ (id)httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    return [_dataCache objectForKey:cacheKey];
}

+ (NSInteger)getAllHttpCacheSize {
    return [_dataCache.diskCache totalCost];
}

+ (void)removeAllHttpCache {
    [_dataCache.diskCache removeAllObjects];
}

@end

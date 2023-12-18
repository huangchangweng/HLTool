//
//  HLToolImageConfig.m
//  HLTool
//
//  Created by 黄常翁 on 2023/12/18.
//

#import "HLToolImageConfig.h"

@implementation HLToolImageConfig

+ (instancetype)shared {
    static HLToolImageConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HLToolImageConfig alloc] init];
    });
    return instance;
}

@end

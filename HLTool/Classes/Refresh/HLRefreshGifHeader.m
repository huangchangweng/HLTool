//
//  HLRefreshGifHeader.m
//  HLCategorys
//
//  Created by JJB_iOS on 2022/5/27.
//

#import "HLRefreshGifHeader.h"
#import "HLDefine.h"
#import "HLToolImageConfig.h"

@implementation HLRefreshGifHeader

#pragma mark - Rewrite Method

- (void)prepare
{
    [super prepare];
    
    NSMutableArray *refreshingImages = [NSMutableArray array];
    if ([HLToolImageConfig shared].refreshLodingImages) {
        [refreshingImages addObjectsFromArray:[HLToolImageConfig shared].refreshLodingImages];
    } else {
        for (NSUInteger i = 1; i<=3; i++) {
            UIImage *image = GetImageWithName([NSString stringWithFormat:@"loading_%zd", i]);
            [refreshingImages addObject:image];
        }
    }
    // 设置普通状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateIdle];
    // 设置松开就可以进行刷新的状态图片
//    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

@end

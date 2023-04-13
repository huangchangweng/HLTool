//
//  UIScrollView+HLRefresh.m
//  HLCategorys
//
//  Created by JJB_iOS on 2022/5/26.
//

#import "UIScrollView+HLRefresh.h"
#import "HLRefreshGifHeader.h"

@implementation UIScrollView (HLRefresh)

/**
 *  菊花样式：设置下拉和上拉回调
 *  headerBlock 下拉回调
 *  footerBlock 上拉回调，如果为空就没有上拉
 */
- (void)hl_setRefreshWithHeaderBlock:(void(^)(void))headerBlock
                           footerBlock:(void(^)(void))footerBlock
{
    NSAssert(headerBlock, @"headerBlock 不能为空");
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (headerBlock) {
            headerBlock();
        }
    }];
    
    [self hl_setRefreshWithRefreshHeader:header
                             footerBlock:footerBlock];
}

/**
 *  git样式：设置下拉和上拉回调
 *  headerBlock 下拉回调
 *  footerBlock 上拉回调，如果为空就没有上拉
 */
- (void)hl_setGifRefreshWithHeaderBlock:(void(^)(void))headerBlock
                            footerBlock:(void(^)(void))footerBlock
{
    NSAssert(headerBlock, @"headerBlock 不能为空");
    
    HLRefreshGifHeader *header = [HLRefreshGifHeader headerWithRefreshingBlock:^{
        if (headerBlock) {
            headerBlock();
        }
    }];
    
    [self hl_setRefreshWithRefreshHeader:header
                             footerBlock:footerBlock];
}

/**
 *  自定义样式
 *  footerBlock 上拉回调，如果为空就没有上拉
 */
- (void)hl_setRefreshWithRefreshHeader:(MJRefreshStateHeader *)header
                           footerBlock:(void(^)(void))footerBlock
{
    header.automaticallyChangeAlpha = YES;
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mj_header = header;
   
    if (footerBlock) {
        __weak __typeof__(self) weakSelf = self;
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.mj_header.isRefreshing) {
                [weakSelf hl_footerEndRefreshing];
                return;
            }
            if (footerBlock) {
                footerBlock();
            }
        }];
        footer.refreshingTitleHidden = YES;
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        [footer setState:MJRefreshStateNoMoreData];
        // 忽略掉底部inset
        footer.ignoredScrollViewContentInsetBottom = 0;
        self.mj_footer = footer;
    }
    
    // 设置了底部inset
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
}

/**
 *  开始下拉
 */
- (void)hl_headerBeginRefreshing
{
    [self.mj_header beginRefreshing];
}

/**
 *  结束下拉
 */
- (void)hl_headerEndRefreshing
{
    [self.mj_header endRefreshing];
}

/**
 *  结束上拉
 */
- (void)hl_footerEndRefreshing
{
    [self.mj_footer endRefreshing];
}

/**
 *  设置上拉没有更多数据
 */
- (void)hl_footerNoMoreData
{
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.mj_footer;
    [footer setTitle:self.hl_noMoreDataText forState:MJRefreshStateNoMoreData];
    [self.mj_footer setState:MJRefreshStateNoMoreData];
}

/**
 *  设置上拉没有数据
 */
- (void)hl_footerNoData
{
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.mj_footer;
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    [self.mj_footer setState:MJRefreshStateNoMoreData];
}

#pragma mark - Getter And Setter

static char *kHLNoMoreDataTextkey = "kHLNoMoreDataTextkey";

- (void)setHl_noMoreDataText:(NSString *)hl_noMoreDataText {
    NSAssert(hl_noMoreDataText, @"hl_noMoreDataText 不能为空");
    objc_setAssociatedObject(self, &kHLNoMoreDataTextkey, hl_noMoreDataText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)hl_noMoreDataText {
    return objc_getAssociatedObject(self, &kHLNoMoreDataTextkey)?:@"没有更多数据了";
}

@end

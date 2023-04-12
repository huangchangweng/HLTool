//
//  UIScrollView+HLRefresh.h
//  HLCategorys
//
//  Created by JJB_iOS on 2022/5/26.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

@interface UIScrollView (HLRefresh)

/// 没有更多数据文案，默认"没有更多数据了"
@property (nonatomic, copy) NSString *hl_noMoreDataText UI_APPEARANCE_SELECTOR;

/**
 *  菊花样式：设置下拉和上拉回调
 *  headerBlock 下拉回调
 *  footerBlock 上拉回调，如果为空就没有上拉
 */
- (void)hl_setRefreshWithHeaderBlock:(void(^)(void))headerBlock
                         footerBlock:(void(^)(void))footerBlock;

/**
 *  git样式：设置下拉和上拉回调
 *  headerBlock 下拉回调
 *  footerBlock 上拉回调，如果为空就没有上拉
 */
- (void)hl_setGifRefreshWithHeaderBlock:(void(^)(void))headerBlock
                            footerBlock:(void(^)(void))footerBlock;

/**
 *  自定义样式
 *  footerBlock 上拉回调，如果为空就没有上拉
 */
- (void)hl_setRefreshWithRefreshHeader:(MJRefreshStateHeader *)header
                           footerBlock:(void(^)(void))footerBlock;

/**
 *  开始下拉
 */
- (void)hl_headerBeginRefreshing;

/**
 *  结束下拉
 */
- (void)hl_headerEndRefreshing;

/**
 *  结束上拉
 */
- (void)hl_footerEndRefreshing;

/**
 *  设置上拉没有更多数据
 */
- (void)hl_footerNoMoreData;

/**
 *  设置上拉没有数据
 */
- (void)hl_footerNoData;

@end

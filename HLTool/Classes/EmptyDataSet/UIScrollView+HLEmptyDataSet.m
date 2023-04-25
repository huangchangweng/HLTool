//
//  UIScrollView+HLEmptyDataSet.m
//  HLCategorys
//
//  Created by JJB_iOS on 2022/5/26.
//

#define kHLEmptyDataSetNoDataImage GetImageWithName(@"no_content_empty")
#define kHLEmptyDataSetCustomErrorImage GetImageWithName(@"server_error")
#define kHLEmptyDataSetNoDataText @"没有数据哟！"
#define kHLEmptyDataSetCustomErrorText @"出错啦！"

#import "UIScrollView+HLEmptyDataSet.h"
#import <objc/runtime.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "HLDefine.h"

@interface UIScrollView()
@property (nonatomic, copy)void(^hl_emptyDataSetBlock)(void);
@property (nonatomic, copy)void(^hl_emptyDataSetTapButtonBlock)(void);
@end

@implementation UIScrollView (HLEmptyDataSet)

#pragma mark - Public Method

- (void)hl_emptyDataSetBlock:(void(^)(void))hl_emptyDataSetBlock
{
    self.hl_emptyDataSetBlock = hl_emptyDataSetBlock;
    
    self.emptyDataSetSource = self;
    if (hl_emptyDataSetBlock) {
        self.emptyDataSetDelegate = self;
    }
}

- (void)hl_emptyDataSetTapButtonBlock:(void(^)(void))hl_emptyDataSetTapButtonBlock
{
    self.hl_emptyDataSetTapButtonBlock = hl_emptyDataSetTapButtonBlock;
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"";
    switch (self.hl_emptyDataSetType) {
        case HLEmptyDataSetTypeNone: text = @""; break;
        case HLEmptyDataSetTypeNoData: text = self.hl_noDataText; break;
        case HLEmptyDataSetTypeCustomError: text = self.hl_customErrorText; break;
    }
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.lineSpacing = 5;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.hl_emptyDataSetType == HLEmptyDataSetTypeNoData) {
        return self.hl_noDataImage;
    } else {
        return self.hl_customErrorImage;
    }
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    CGFloat verticalOffset = 0;
    
    // heardView
    if ([scrollView isKindOfClass:UITableView.class]) {
        UITableView *tableView = (UITableView *)scrollView;
        CGFloat heardHeight = tableView.tableHeaderView.frame.size.height;
        verticalOffset += heardHeight/2;
    }
    
    // contentOffsetY
    verticalOffset += self.hl_verticalOffset;
    
    return verticalOffset;
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return self.hl_buttonImage;
}

#pragma mark - DZNEmptyDataSetDelegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    if (self.hl_emptyDataSetBlock) {
        self.hl_emptyDataSetBlock();
    }
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    if (self.hl_emptyDataSetTapButtonBlock) {
        self.hl_emptyDataSetTapButtonBlock();
    }
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.hl_emptyDataSetType != HLEmptyDataSetTypeNone;
}

#pragma mark - Getter And Setter

static char *kHLEmptyDataSetNoDataImagekey = "kHLEmptyDataSetNoDataImagekey";
static char *kHLEmptyDataSetCustomErrorImagekey = "kHLEmptyDataSetCustomErrorImagekey";
static char *kHLEmptyDataSetNoDataTextkey = "kHLEmptyDataSetNoDataTextkey";
static char *kHLEmptyDataSetCustomErrorTextkey = "kHLEmptyDataSetCustomErrorTextkey";

static char *kHLEmptyDataSetTypekey = "kHLEmptyDataSetTypekey";
static char *kHLEmptyDataSetBlockkey = "kHLEmptyDataSetBlockkey";
static char *kHLEmptyDataSetVerticalOffsetkey = "kHLEmptyDataSetVerticalOffsetkey";

static char *kHLEmptyDataSetButtonImagekey = "kHLEmptyDataSetButtonImagekey";
static char *kHLEmptyDataSetTapButtonBlockkey = "kHLEmptyDataSetTapButtonBlockkey";

- (void)setHl_noDataImage:(UIImage *)hl_noDataImage {
    NSAssert(hl_noDataImage, @"hl_noDataImage 不能为空");
    objc_setAssociatedObject(self, &kHLEmptyDataSetNoDataImagekey, hl_noDataImage, OBJC_ASSOCIATION_RETAIN);
}

- (UIImage *)hl_noDataImage {
    return objc_getAssociatedObject(self, &kHLEmptyDataSetNoDataImagekey)?:kHLEmptyDataSetNoDataImage;
}

- (void)setHl_customErrorImage:(UIImage *)hl_customErrorImage {
    NSAssert(hl_customErrorImage, @"hl_customErrorImage 不能为空");
    objc_setAssociatedObject(self, &kHLEmptyDataSetCustomErrorImagekey, hl_customErrorImage, OBJC_ASSOCIATION_RETAIN);
}

- (UIImage *)hl_customErrorImage {
    return objc_getAssociatedObject(self, &kHLEmptyDataSetCustomErrorImagekey) ? : kHLEmptyDataSetCustomErrorImage;
}

- (void)setHl_noDataText:(NSString *)hl_noDataText {
    NSAssert(hl_noDataText, @"hl_noDataText 不能为空");
    objc_setAssociatedObject(self, &kHLEmptyDataSetNoDataTextkey, hl_noDataText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)hl_noDataText {
    return objc_getAssociatedObject(self, &kHLEmptyDataSetNoDataTextkey)?:kHLEmptyDataSetNoDataText;
}

- (void)setHl_customErrorText:(NSString *)hl_customErrorText {
    NSAssert(hl_customErrorText, @"hl_noDataText 不能为空");
    objc_setAssociatedObject(self, &kHLEmptyDataSetCustomErrorTextkey, hl_customErrorText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)hl_customErrorText {
    return objc_getAssociatedObject(self, &kHLEmptyDataSetCustomErrorTextkey)?:kHLEmptyDataSetNoDataText;
}

- (void)setHl_emptyDataSetType:(HLEmptyDataSetType)hl_emptyDataSetType {
    objc_setAssociatedObject(self, &kHLEmptyDataSetTypekey, @(hl_emptyDataSetType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self reloadEmptyDataSet];
}

- (HLEmptyDataSetType)hl_emptyDataSetType {
    NSNumber *typeNumber = objc_getAssociatedObject(self, &kHLEmptyDataSetTypekey);
    return [typeNumber integerValue];
}

- (void)setHl_emptyDataSetBlock:(void (^)(void))hl_emptyDataSetBlock {
    objc_setAssociatedObject(self, &kHLEmptyDataSetBlockkey, hl_emptyDataSetBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))hl_emptyDataSetBlock {
    return objc_getAssociatedObject(self, &kHLEmptyDataSetBlockkey);
}

- (void)setHl_verticalOffset:(CGFloat)hl_verticalOffset {
    objc_setAssociatedObject(self, &kHLEmptyDataSetVerticalOffsetkey, @(hl_verticalOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)hl_verticalOffset {
    NSNumber *verticalOffset = objc_getAssociatedObject(self, &kHLEmptyDataSetVerticalOffsetkey);
    return [verticalOffset doubleValue];
}

- (void)setHl_buttonImage:(UIImage *)hl_buttonImage {
    objc_setAssociatedObject(self, &kHLEmptyDataSetButtonImagekey, hl_buttonImage, OBJC_ASSOCIATION_RETAIN);
}

- (UIImage *)hl_buttonImage {
    return objc_getAssociatedObject(self, &kHLEmptyDataSetButtonImagekey);
}

- (void)setHl_emptyDataSetTapButtonBlock:(void (^)(void))hl_emptyDataSetTapButtonBlock {
    objc_setAssociatedObject(self, &kHLEmptyDataSetTapButtonBlockkey, hl_emptyDataSetTapButtonBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))hl_emptyDataSetTapButtonBlock {
    return objc_getAssociatedObject(self, &kHLEmptyDataSetTapButtonBlockkey);
}

@end

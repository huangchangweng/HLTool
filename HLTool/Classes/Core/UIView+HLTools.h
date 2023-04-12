//
//  UIView+HLCategory.h
//  HLCategorys
//
//  Created by JJB_iOS on 2022/5/26.
//

#import <UIKit/UIKit.h>

@interface UIView (HLTools)

#pragma mark - Frame

@property (nonatomic, assign) CGFloat hl_x;
@property (nonatomic, assign) CGFloat hl_y;
@property (nonatomic, assign) CGFloat hl_maxX;
@property (nonatomic, assign) CGFloat hl_maxY;
@property (nonatomic, assign) CGFloat hl_width;
@property (nonatomic, assign) CGFloat hl_height;
@property (nonatomic, assign) CGFloat hl_centerX;
@property (nonatomic, assign) CGFloat hl_centerY;
@property (nonatomic, assign) CGFloat hl_top;
@property (nonatomic, assign) CGFloat hl_left;
@property (nonatomic, assign) CGFloat hl_bottom;
@property (nonatomic, assign) CGFloat hl_right;
@property (nonatomic, assign) CGSize hl_size;
@property (nonatomic, assign) CGPoint hl_origin;
@property (nonatomic, readonly) UIEdgeInsets hl_safeInsets;
@property (nonatomic, readonly) CGFloat hl_safeBottom;

#pragma mark - Method

/**
 *  获取viewController
 */
- (UIViewController *)hl_viewController;

/**
 *  添加圆角
 *  corners 圆角位置
 *  cornerRadii 圆角大小
 */
- (void)hl_addBezierCorners:(UIRectCorner)corners
                cornerRadii:(CGSize)cornerRadii;

/**
 *  绘制虚线
 *  lineLength  虚线的宽度
 *  lineSpacing 虚线的间距
 *  lineColor:  虚线的颜色
 **/
- (void)hl_drawDashLine:(int)lineLength
            lineSpacing:(int)lineSpacing
              lineColor:(UIColor *)lineColor;

@end

//
//  UIView+HLCategory.m
//  HLCategorys
//
//  Created by JJB_iOS on 2022/5/26.
//

#import "UIView+HLTools.h"

@implementation UIView (HLTools)

#pragma mark - Frame

- (void)setHl_x:(CGFloat)hl_x{
    
    CGRect frame = self.frame;
    frame.origin.x = hl_x;
    self.frame = frame;
}

- (CGFloat)hl_x {
    
    return self.frame.origin.x;
}

- (void)setHl_y:(CGFloat)hl_y {
    
    CGRect frame = self.frame;
    frame.origin.y = hl_y;
    self.frame = frame;
}

- (CGFloat)hl_y {
    
    return self.frame.origin.y;
}

- (CGFloat)hl_maxX {
    
    return CGRectGetMaxX(self.frame);
}

- (void)setHl_maxX:(CGFloat)hl_maxX {}

- (CGFloat)hl_maxY {
    
    return CGRectGetMaxY(self.frame);
}

- (void)setHl_maxY:(CGFloat)hl_maxY {}

- (void)setHl_width:(CGFloat)hl_width {
    CGRect frame = self.frame;
    frame.size.width = hl_width;
    self.frame = frame;
}

- (CGFloat)hl_width {
    
    return self.frame.size.width;
}

- (void)setHl_height:(CGFloat)hl_height {
    CGRect frame = self.frame;
    frame.size.height = hl_height;
    self.frame = frame;
}

- (CGFloat)hl_height {
    
    return self.frame.size.height;
}

- (void)setHl_size:(CGSize)hl_size {
    
    CGRect frame = self.frame;
    frame.size = hl_size;
    self.frame = frame;
}

- (CGSize)hl_size {
    
    return self.frame.size;
}

- (void)setHl_origin:(CGPoint)hl_origin {
    
    CGRect frame = self.frame;
    frame.origin = hl_origin;
    self.frame = frame;
}

- (CGPoint)hl_origin {
    
    return self.frame.origin;
}

- (void)setHl_centerX:(CGFloat)hl_centerX {
    
    CGPoint center = self.center;
    center.x = hl_centerX;
    self.center = center;
}

- (CGFloat)hl_centerX {
    
    return self.center.x;
}

- (void)setHl_centerY:(CGFloat)hl_centerY {
    
    CGPoint center = self.center;
    center.y = hl_centerY;
    self.center = center;
}

- (CGFloat)hl_centerY {
    
    return self.center.y;
}

- (void)setHl_top:(CGFloat)hl_top {
    CGRect frame = self.frame;
    frame.origin.y = hl_top;
    self.frame = frame;
}

- (CGFloat)hl_top {
    return self.frame.origin.y;
}

- (void)setHl_left:(CGFloat)hl_left {
    CGRect frame = self.frame;
    frame.origin.x = hl_left;
    self.frame = frame;
}

- (CGFloat)hl_left {
    return self.frame.origin.x;
}

- (void)setHl_bottom:(CGFloat)hl_bottom {
    CGRect frame = self.frame;
    frame.origin.y = hl_bottom - self.hl_height;
    self.frame = frame;
}

- (CGFloat)hl_bottom {
    return self.frame.origin.y + self.hl_height;
}

- (void)setHl_right:(CGFloat)hl_right {
    CGRect frame = self.frame;
    frame.origin.x = hl_right - self.hl_width;
    self.frame = frame;
}

- (CGFloat)hl_right {
    return self.frame.origin.x + self.hl_width;
}

- (UIEdgeInsets)hl_safeInsets {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

- (CGFloat)hl_safeBottom {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets.bottom;
    } else {
        return 0;
    }
}

#pragma mark - Method

/**
 *  获取viewController
 */
- (UIViewController *)hl_viewController
{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    
    return nil;
}

/**
 *  添加圆角
 *  corners 圆角位置
 *  cornerRadii 圆角大小
 */
- (void)hl_addBezierCorners:(UIRectCorner)corners
                cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.frame = self.bounds;
    layer.path = path.CGPath;
    self.layer.mask = layer;
}

/**
 *  绘制虚线
 *  lineLength  虚线的宽度
 *  lineSpacing 虚线的间距
 *  lineColor:  虚线的颜色
 **/
- (void)hl_drawDashLine:(int)lineLength
            lineSpacing:(int)lineSpacing
              lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    // 设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(self.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 设置线宽，线间距
    [shapeLayer setLineDashPattern:@[@(lineLength), @(lineSpacing)]];
    // 设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    // 把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
}

@end

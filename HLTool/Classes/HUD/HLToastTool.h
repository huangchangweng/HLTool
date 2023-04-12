//
//  HLToastTool.h
//  HLTool
//
//  Created by feige on 2023/4/11.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ToastToolPosition) {
    ToastToolPositionBottom,
    ToastToolPositionCenter,
    ToastToolPositionTop,
};

@interface HLToastTool : NSObject

/// 显示提示视图, 默认显示在屏幕中间，2s后自动消失
+ (void)show:(NSString *)message;

/// 显示提示视图, 默认显示在屏幕上方，防止被软键盘覆盖，2s后自动消失
+ (void)showAtTop:(NSString *)message;

/// 显示提示视图, 默认显示在屏幕中间，2s后自动消失
+ (void)showAtCenter:(NSString *)message;

/// 显示提示视图, 默认显示在屏幕底部，2s后自动消失
+ (void)showAtBottom:(NSString *)message;

/// 显示提示视图, 默认显示在屏幕中间，4s后自动消失
+ (void)showLong:(NSString *)message;

/// 显示提示视图, 默认显示在屏幕上方，防止被软键盘覆盖，4s后自动消失
+ (void)showLongAtTop:(NSString *)message;

/// 显示提示视图, 默认显示在屏幕中间，4s后自动消失
+ (void)showLongAtCenter:(NSString *)message;

/// 显示提示视图, 默认显示在屏幕底部，4s后自动消失
+ (void)showLongAtBottom:(NSString *)message;

/// 显示提示视图
/// @param message 提示内容
/// @param position @ToastToolPosition
/// @param showTime 显示时间s
/// @param view 父视图，view=nil显示在window上
+ (void)show:(NSString *)message position:(ToastToolPosition)position showTime:(float)showTime view:(nullable UIView *)view;

/// 显示提示视图，window
+ (void)show:(NSString *)message position:(ToastToolPosition)position showTime:(float)showTime;

/// 显示提示视图，point 中心点
+ (void)show:(NSString *)message point:(CGPoint)point showTime:(float)showTime view:(nullable UIView *)view;

/// 加载view
+ (void)showActivity:(UIView *)view;

@end

NS_ASSUME_NONNULL_END

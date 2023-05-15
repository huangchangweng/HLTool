//
//  HLHUD.h
//  HLHUD
//
//  Created by JJB_iOS on 2022/5/25.
//

#import <UIKit/UIKit.h>

@interface HLHUD : NSObject

// 显示成功样式HUD
+ (void)showSuccessMsg:(NSString *)msg;

// 显示成功样式HUD（可自定义图片）
+ (void)showSuccessMsg:(NSString *)msg
                 image:(UIImage *)image;

// 显示文字HUD
+ (void)showMsg:(NSString *)msg;

// 显示加载中HUD
+ (void)showLoading:(NSString *)msg;

// 隐藏所有HUD
+ (void)hide;

@end

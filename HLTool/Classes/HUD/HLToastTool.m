//
//  HLToastTool.m
//  HLTools
//
//  Created by feige on 2023/4/11.
//


#import "HLToastTool.h"
#import "UIWindow+HLTools.h"
#import <Toast/Toast.h>

@implementation HLToastTool

+ (void)show:(NSString *)message {
    [self show:message position:ToastToolPositionCenter showTime:2.0];
}

+ (void)showAtTop:(NSString *)message {
    [self show:message position:ToastToolPositionTop showTime:2.0];
}

+ (void)showAtCenter:(NSString *)message {
    [self show:message position:ToastToolPositionCenter showTime:2.0];
}

+ (void)showAtBottom:(NSString *)message {
    [self show:message position:ToastToolPositionBottom showTime:2.0];
}

+ (void)showLong:(NSString *)message {
    [self show:message position:ToastToolPositionCenter showTime:4.0];
}

+ (void)showLongAtTop:(NSString *)message {
    [self show:message position:ToastToolPositionTop showTime:4.0];
}

+ (void)showLongAtCenter:(NSString *)message {
    [self show:message position:ToastToolPositionCenter showTime:4.0];
}

+ (void)showLongAtBottom:(NSString *)message {
    [self show:message position:ToastToolPositionBottom showTime:4.0];
}

+ (void)show:(NSString *)message position:(ToastToolPosition)position showTime:(float)showTime {
    [self show:message position:position showTime:showTime view:nil];
}

+ (void)show:(NSString *)message position:(ToastToolPosition)position showTime:(float)showTime view:(UIView *)view {
    if (!view) {
        view = [UIWindow hl_keyWindow];
    }
    
    switch ((int)position) {
        case ToastToolPositionBottom:
            [view makeToast:message duration:showTime position:CSToastPositionBottom];
            break;
        case ToastToolPositionTop:
            [view makeToast:message duration:showTime position:CSToastPositionTop];
            break;
        case ToastToolPositionCenter:
            [view makeToast:message duration:showTime position:CSToastPositionCenter];
            break;
            
        default:
            break;
    }
}

+ (void)show:(NSString *)message point:(CGPoint)point showTime:(float)showTime view:(UIView *)view {
    if (!view) {
        view = [UIWindow hl_keyWindow];
    }
    
    NSValue *value = [NSValue valueWithCGPoint:point];
    [view makeToast:message duration:showTime position:value];

}

+ (void)showActivity:(UIView *)view {
    if (!view) {
        view = [UIWindow hl_keyWindow];
    }
    [view makeToastActivity:CSToastPositionCenter];
}

@end

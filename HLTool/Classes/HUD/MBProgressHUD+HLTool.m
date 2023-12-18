//
//  MBProgressHUD+HHTool.m
//  HLTool
//
//  Created by feige on 2023/4/11.
//


#import "MBProgressHUD+HLTool.h"
#import "UIWindow+HLTool.h"
#import "HLDefine.h"
#import "HLToolImageConfig.h"

const NSInteger hideTime = 2;

@implementation MBProgressHUD (HHTool)

+ (void)show {
    [self show:GetLocalLanguageTextValue(@"Loading")];
}

+ (void)show:(NSString *)message {
    [self show:message view:nil];
}

+ (void)show:(NSString *)message view:(UIView *)view {
    if (!view) {
        view = [UIWindow topViewController].view;
    }
    MBProgressHUD *hud = [self createMBProgressHUD:view];
    hud.label.text = message;
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
}

+ (void)showSuccess:(NSString *)success {
    [self showSuccess:success duration:hideTime];
}

+ (void)showSuccess:(NSString *)success view:(UIView *)view {
    [self showSuccess:success duration:hideTime view:view];
}

+ (void)showSuccess:(NSString *)success duration:(NSUInteger)time {
    [self showSuccess:success duration:time view:nil];
}

+ (void)showSuccess:(NSString *)success duration:(NSUInteger)time view:(UIView *)view {
    [self showCustomIcon:[HLToolImageConfig shared].hudSuccessImage ? : GetImageWithName(@"hud_success") message:success duration:time view:view];
}

+ (void)showError:(NSString *)error {
    [self showError:error duration:hideTime];
}

+ (void)showError:(NSString *)error view:(UIView *)view {
    [self showError:error duration:hideTime view:view];
}

+ (void)showError:(NSString *)error duration:(NSUInteger)time {
    [self showError:error duration:time view:nil];
}

+ (void)showError:(NSString *)error duration:(NSUInteger)time view:(UIView *)view {
    [self showCustomIcon:[HLToolImageConfig shared].hudErrorImage ? : GetImageWithName(@"hud_error") message:error duration:time view:view];
}

+ (void)showCustomIcon:(UIImage *)icon message:(NSString *)message duration:(NSUInteger)time view:(UIView *)view {
    if (!view) {
        view = [UIWindow hl_keyWindow];
    }
    [self hide];
    
    MBProgressHUD *hud = [self createMBProgressHUD:view];
    hud.label.text = message;
    hud.customView = [[UIImageView alloc] initWithImage:icon];
    hud.mode = MBProgressHUDModeCustomView;
    [hud hideAnimated:YES afterDelay:time];
}

+ (MBProgressHUD *)createMBProgressHUD:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.minSize = CGSizeMake(100, 100);
    hud.label.numberOfLines = 0;
    hud.label.textColor = [UIColor whiteColor];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (void)hide {
    [self hide:nil];
}

+ (void)hide:(UIView *)view {
    if (!view) {
        view = [UIWindow topViewController].view;
    }
    [self hideHUDForView:view animated:YES];
}

@end

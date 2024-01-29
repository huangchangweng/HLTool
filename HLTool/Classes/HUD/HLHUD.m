//
//  HLHUD.m
//  HLHUD
//
//  Created by JJB_iOS on 2022/5/25.
//

#import "HLHUD.h"
#import "UIWindow+HLTool.h"
#import "HLDefine.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "HLToolImageConfig.h"

@implementation HLHUD

#pragma mark - Private Method

+ (UIView *)inView
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (keyWindow) {
        return keyWindow;
    }
    UIView *topVCView = [UIWindow topViewController].view;
    if (topVCView) {
        return topVCView;
    }
    return nil;
}

+ (MBProgressHUD *)showUnifyHUD
{
    if (!self.inView) {
        return nil;
    }
    [self hide:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.inView animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.label.numberOfLines = 0;
    return hud;
}

+ (void)hide:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:self.inView animated:animated];
}

#pragma mark - Public Method

+ (void)showSuccessMsg:(NSString *)msg
{
    UIImage *image = [HLToolImageConfig shared].hudRightImage ? : GetImageWithName(@"hud_right");
    [self showSuccessMsg:msg image:image];
}

+ (void)showSuccessMsg:(NSString *)msg
                 image:(UIImage *)image
{
    MBProgressHUD *hud = [self showUnifyHUD];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *img = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:img];
    hud.label.text = msg;
    [hud hideAnimated:YES afterDelay:2.f];
}

+ (void)showMsg:(NSString *)msg
{
    MBProgressHUD *hud = [self showUnifyHUD];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    [hud hideAnimated:YES afterDelay:2.f];
}

+ (void)showLoading:(NSString *)msg
{
    MBProgressHUD *hud = [self showUnifyHUD];
    hud.label.text = msg == nil ? GetLocalLanguageTextValue(@"Loading") : msg;
}

+ (void)hide
{
    [self hide:YES];
}

@end

//
//  HLPopupTool.m
//  HLTool
//
//  Created by feige on 2023/4/11.
//

#import "HLPopupTool.h"
#import "HLUtils.h"
#import "HLPopupListView.h"
#import "UIWindow+HLTool.h"
#import "HLDefine.h"

@interface HLPopupTool () <YBPopupMenuDelegate>

@property (nonatomic, copy) HLPopupToolDidSelected black;

@end

@implementation HLPopupTool

static HLPopupTool *_sharedInstance = nil;
static dispatch_once_t onceToken = 0;

+ (instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

+ (void)attempDealloc {
    onceToken = 0;
    _sharedInstance = nil;
}

+ (UIViewController *)topViewController {
    return [UIWindow topViewController];
}

+ (YBPopupMenu *)showInView:(UIView *)view titles:(NSArray *)titles action:(HLPopupToolDidSelected)action {
    CGFloat maxWidth = [self size:nil titles:titles];
    return [[HLPopupTool sharedInstance] show:view point:CGPointZero titles:titles icons:nil menuWidth:maxWidth action:action];
}

+ (YBPopupMenu *)showInView:(UIView *)view titles:(NSArray *)titles icons:(NSArray *)icons action:(HLPopupToolDidSelected)action {
    CGFloat maxWidth = [self size:icons titles:titles];
    return [[HLPopupTool sharedInstance] show:view point:CGPointZero titles:titles icons:icons menuWidth:maxWidth action:action];
}

+ (YBPopupMenu *)showInView:(UIView *)view titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)menuWidth action:(HLPopupToolDidSelected)action {
    return[[HLPopupTool sharedInstance] show:view point:CGPointZero titles:titles icons:icons menuWidth:menuWidth action:action];
}

+ (YBPopupMenu *)showInPoint:(CGPoint)point titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)menuWidth action:(HLPopupToolDidSelected)action {
    return [[HLPopupTool sharedInstance] show:nil point:point titles:titles icons:icons menuWidth:menuWidth action:action];
}

- (YBPopupMenu *)show:(UIView *)view point:(CGPoint)point titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)menuWidth action:(HLPopupToolDidSelected)action {
    self.black = action;
    
    if (view) {
        return [YBPopupMenu showRelyOnView:view titles:titles icons:icons menuWidth:menuWidth otherSettings:^(YBPopupMenu *popupMenu) {
            popupMenu.delegate = self;
        }];
    } else {
        return [YBPopupMenu showAtPoint:point titles:titles icons:icons menuWidth:menuWidth otherSettings:^(YBPopupMenu *popupMenu) {
            popupMenu.delegate = self;
        }];
    }
    
}

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    if (self.black) {
        self.black(index, ybPopupMenu);
    }
    [HLPopupTool attempDealloc];
}

// TODO 默认字体15，有图片宽度36 最大60
+ (CGFloat)size:(NSArray *)icons titles:(NSArray *)titles {
    CGFloat maxWidth = 0;
    for (int i = 0; i < titles.count; i ++) {
        NSString *title = titles[i];
        CGFloat titleWidth = [HLUtils widthForString:title font:[UIFont systemFontOfSize:15] height:20];
        
        // img
        CGFloat widthImg = 0;
        if (icons.count > i) {
            UIImage *img = icons[i];
            if ([img isKindOfClass:[UIImage class]]) {
                widthImg = MIN(img.size.width*2, 60);
            } else {
                widthImg = 36;
            }
        }
        maxWidth = MAX(maxWidth, titleWidth + widthImg);
    }
    
    maxWidth += 32;
    return maxWidth;
}


+ (SPAlertController *)showPopupView:(UIView *)view {
   return [self showPopupView:view postion:HHPopupPositionCenter];
}

+ (SPAlertController *)showPopupView:(UIView *)view postion:(HHPopupPosition)postion {
    
    SPAlertControllerStyle preferredStyle = SPAlertControllerStyleAlert;
    if (postion == HHPopupPositionBottom) {
        preferredStyle = SPAlertControllerStyleActionSheet;
    }
    
    SPAlertController *alertController = [SPAlertController alertControllerWithCustomAlertView:view preferredStyle:preferredStyle animationType:SPAlertAnimationTypeDefault];
   [[self topViewController] presentViewController:alertController animated:YES completion:nil];
    return alertController;
}


+ (SPAlertController *)showPopupActionView:(UIView *)view {
    return [self showPopupActionView:view postion:HHPopupPositionCenter];
 }

 + (SPAlertController *)showPopupActionView:(UIView *)view postion:(HHPopupPosition)postion {
     return [self showPopupActionView:view title:@"" postion:postion];
 }

+ (SPAlertController *)showPopupActionView:(UIView *)view title:(NSString *)title postion:(HHPopupPosition)postion {
    SPAlertControllerStyle preferredStyle = SPAlertControllerStyleAlert;
    if (postion == HHPopupPositionBottom) {
        preferredStyle = SPAlertControllerStyleActionSheet;
    }
    
    SPAlertController *alertController = [SPAlertController alertControllerWithCustomActionSequenceView:view title:title message:@"" preferredStyle:preferredStyle animationType:SPAlertAnimationTypeDefault];
    [[self topViewController] presentViewController:alertController animated:YES completion:nil];
    return alertController;
}

+ (SPAlertController *)showPopupHeaderView:(UIView *)view {
    return [self showPopupHeaderView:view postion:HHPopupPositionBottom showCancel:YES];
};

+ (SPAlertController *)showPopupHeaderView:(UIView *)view postion:(HHPopupPosition)postion showCancel:(BOOL)showCancel {
    SPAlertControllerStyle preferredStyle = SPAlertControllerStyleAlert;
    if (postion == HHPopupPositionBottom) {
        preferredStyle = SPAlertControllerStyleActionSheet;
    }
    
    SPAlertController *alertController = [SPAlertController alertControllerWithCustomHeaderView:view preferredStyle:preferredStyle animationType:SPAlertAnimationTypeDefault];
    
    if (showCancel) {
        SPAlertAction *action = [SPAlertAction actionWithTitle:GetLocalLanguageTextValue(@"Cancel") style:SPAlertActionStyleCancel handler:nil];
        [alertController addAction:action];
    }
    
    [[self topViewController] presentViewController:alertController animated:YES completion:nil];
    return alertController;
}


+ (SPAlertController *)showPopupListTitle:(NSString *)title dataArray:(NSArray *)dataArray postion:(HHPopupPosition)postion action:(nullable HLPopupToolListDidSelected)action {
    
    HLPopupListView *view = [[HLPopupListView alloc] initWithTitle:title dataArray:dataArray];
    
    SPAlertController *alertController = [self showPopupView:view postion:postion];
    
    view.didRowBlock = ^(NSInteger index, NSString * _Nonnull text) {
        [alertController dismissViewControllerAnimated:YES completion:^{
            if (action) {
                action(index, text);
            }
        }];
        
    };
    return alertController;
}

+ (SPAlertController *)showPopupBottomListTitle:(NSString *)title dataArray:(NSArray *)dataArray action:(nullable HLPopupToolListDidSelected)action {
    return [self showPopupListTitle:title dataArray:dataArray postion:HHPopupPositionBottom action:action];
}

+ (SPAlertController *)showPopupCenterListTitle:(NSString *)title dataArray:(NSArray *)dataArray action:(nullable HLPopupToolListDidSelected)action {
    return [self showPopupListTitle:title dataArray:dataArray postion:HHPopupPositionCenter action:action];
}

@end

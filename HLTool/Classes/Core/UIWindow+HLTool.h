//
//  UIWindow+HLTool.h
//  HLTool
//
//  Created by feige on 2023/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (HLTool)

- (UIViewController *)currentTopViewController;

+ (UIWindow *)hl_keyWindow;

+ (UIViewController *)topViewController;


@end

NS_ASSUME_NONNULL_END

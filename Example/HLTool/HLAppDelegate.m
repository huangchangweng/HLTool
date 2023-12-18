//
//  HLAppDelegate.m
//  HLTool
//
//  Created by huangchangweng on 04/12/2023.
//  Copyright (c) 2023 huangchangweng. All rights reserved.
//

#import "HLAppDelegate.h"
#import <HLTool/HLTool.h>

@implementation HLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self configHlTool];
    
    return YES;
}

#pragma mark - Private Method

- (void)configHlTool
{
    NSArray *lodingImages = @[[UIImage imageNamed:@"loading_1"], [UIImage imageNamed:@"loading_2"], [UIImage imageNamed:@"loading_3"]];
    
    // EmptyDataSet
    [HLToolImageConfig shared].noDataImage = [UIImage imageNamed:@"no_content_empty"];
    // HUD
    // LoadingView
    [HLToolImageConfig shared].lodingImages = lodingImages;
    // Refresh
    [HLToolImageConfig shared].refreshLodingImages = lodingImages;
}

@end

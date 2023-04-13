//
//  HLPopupViewController.m
//  HLTool_Example
//
//  Created by feige on 2023/4/13.
//  Copyright © 2023 huangchangweng. All rights reserved.
//

#import "HLPopupViewController.h"
#import <HLTool.h>

@interface HLPopupViewController ()

@end

@implementation HLPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Response Event

- (IBAction)navRightAction:(UIButton *)sender {
    [HLPopupTool showInView:sender
                     titles:@[@"标题一", @"标题二", @"标题三", @"标题四"]
                     action:^(NSInteger index, YBPopupMenu * _Nonnull popupMenu) {
        
    }];
}

- (IBAction)popupAction:(UIButton *)sender {
    NSMutableArray *icons = [NSMutableArray new];
    for (int i=1; i<5; i++) {
        [icons addObject:[UIImage imageNamed:[NSString stringWithFormat:@"chat_client_%d", i]]];
    }
    [HLPopupTool showInView:sender
                     titles:@[@"标题一", @"标题二", @"标题三", @"标题四"]
                      icons:icons
                  menuWidth:150
                     action:^(NSInteger index, YBPopupMenu * _Nonnull popupMenu) {
        
    }];
}

- (IBAction)popupListAction:(UIButton *)sender {
    [HLPopupTool showPopupBottomListTitle:@"标题"
                                dataArray:@[@"内容一", @"内容二", @"内容三", @"内容四", @"内容五", ]
                                   action:^(NSInteger index, NSString * _Nonnull text) {
        
    }];
}

@end

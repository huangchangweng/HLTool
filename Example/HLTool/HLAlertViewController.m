//
//  HLAlertViewController.m
//  HLTool_Example
//
//  Created by feige on 2023/4/13.
//  Copyright © 2023 huangchangweng. All rights reserved.
//

#import "HLAlertViewController.h"
#import <HLTool.h>

@interface HLAlertViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation HLAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 系统-警示框
    if (indexPath.row == 0) {
        [HLAlertTool alertWithMessage:@"这是一个简单的“系统-警示框”"];
    }
    // 系统-多按钮
    else if (indexPath.row == 1) {
        [HLAlertTool alertWithTitle:@"提示"
                            message:@"我是系统-多按钮"
                        cancelTitle:@"取消"
                       buttonTitles:@[@"按钮1", @"按钮2"]
                       actionsBlock:^(NSInteger buttonIndex, NSString * _Nonnull buttonTitle) {
            HLLog(@"buttonIndex:%ld", buttonIndex);
        }];
    }
    // 系统-Sheet
    else if (indexPath.row == 2) {
        [HLAlertTool sheetWithTitle:@"Sheet"
                            message:@"Sheet message"
                        cancelTitle:@"取消"
                   destructiveTitle:nil
                       buttonTitles:@[@"按钮1", @"按钮2"]
                       actionsBlock:^(NSInteger buttonIndex, NSString * _Nonnull buttonTitle) {
            HLLog(@"buttonIndex:%ld", buttonIndex);
        }];
    }
    // 自定义-警示框
    else if (indexPath.row == 3) {
        [HLAlertCustomTool alertWithMessage:@"这是一个简单的“系统-警示框”"];
    }
    // 自定义-多按钮
    else if (indexPath.row == 4) {
        [HLAlertCustomTool alertWithTitle:@"提示"
                                  message:@"我是“自定义-多按钮”"
                              cancelTitle:@"取消"
                             buttonTitles:@[@"按钮1", @"按钮2"]
                             actionsBlock:^(NSInteger buttonIndex, NSString * _Nonnull buttonTitle) {
            HLLog(@"buttonIndex:%ld", buttonIndex);
        }];
    }
    // 自定义-Sheet
    else if (indexPath.row == 5) {
        [HLAlertCustomTool sheetWithTitle:@"Sheet"
                                  message:@"Sheet message"
                              cancelTitle:@"取消"
                         destructiveTitle:nil
                             buttonTitles:@[@"按钮1", @"按钮2"]
                             actionsBlock:^(NSInteger buttonIndex, NSString * _Nonnull buttonTitle) {
            HLLog(@"buttonIndex:%ld", buttonIndex);
        }];
    }
}


#pragma mark - Getter

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"系统-警示框", @"系统-多按钮", @"系统-Sheet", @"自定义-警示框", @"自定义-多按钮", @"自定义-Sheet"];
    }
    return _dataArray;
}

@end

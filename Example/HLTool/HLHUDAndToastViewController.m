//
//  HLHUDAndToastViewController.m
//  HLTool_Example
//
//  Created by feige on 2023/4/13.
//  Copyright © 2023 huangchangweng. All rights reserved.
//

#import "HLHUDAndToastViewController.h"
#import <HLTool.h>

@interface HLHUDAndToastViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation HLHUDAndToastViewController

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
    
    // + (void)show
    if (indexPath.row == 0) {
        [MBProgressHUD show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 2), dispatch_get_main_queue(), ^{
            [MBProgressHUD hide];
        });
    }
    // + (void)show:(NSString *)message
    else if (indexPath.row == 1) {
        [MBProgressHUD show:@"加载中..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 2), dispatch_get_main_queue(), ^{
            [MBProgressHUD hide];
        });
    }
    // + (void)showSuccess:(NSString *)success
    else if (indexPath.row == 2) {
        [MBProgressHUD showSuccess:@"加载成功"];
    }
    // + (void)showError:(NSString *)error
    else if (indexPath.row == 3) {
        [MBProgressHUD showError:@"加载失败"];
    }
    // 【Toast】+ (void)show:(NSString *)message
    else if (indexPath.row == 4) {
        [HLToastTool show:@"我是一个Toast"];
    }
    // 【Toast】+ (void)showAtBottom:(NSString *)message
    else if (indexPath.row == 5) {
        [HLToastTool showAtBottom:@"我是一个Toast"];
    }
}


#pragma mark - Getter

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"+ (void)show", @"+ (void)show:(NSString *)message", @"+ (void)showSuccess:(NSString *)success", @"+ (void)showError:(NSString *)error", @"【Toast】+ (void)show:(NSString *)message", @"【Toast】+ (void)showAtBottom:(NSString *)message"];
    }
    return _dataArray;
}

@end

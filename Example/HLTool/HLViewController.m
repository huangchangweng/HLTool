//
//  HLViewController.m
//  HLTool
//
//  Created by huangchangweng on 04/12/2023.
//  Copyright (c) 2023 huangchangweng. All rights reserved.
//

#import "HLViewController.h"

@interface HLViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation HLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    
    // Alert
    if (indexPath.row == 0) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HLAlertViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    // EmptyDataSet & Refresh
    else if (indexPath.row == 1) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HLAlertViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    // HUD & Toast
    else if (indexPath.row == 2) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HLHUDAndToastViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    // IBInspectable
    else if (indexPath.row == 3) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HLAlertViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    // LoadingView
    else if (indexPath.row == 4) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HLAlertViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    // Photo
    else if (indexPath.row == 5) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HLPhotoViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    // Popup
    else if (indexPath.row == 6) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HLAlertViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark - Getter

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"Alert", @"EmptyDataSet & Refresh", @"HUD & Toast", @"IBInspectable", @"LoadingView", @"Photo", @"Popup"];
    }
    return _dataArray;
}

@end

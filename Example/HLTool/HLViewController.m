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
    
    NSString *text = self.dataArray[indexPath.row];
    if ([text isEqualToString:@"Alert"]) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HLAlertViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark - Getter

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"Alert", @"EmptyDataSet & Refresh", @"HUD", @"IBInspectable", @"LoadingView", @"Photo", @"Popup"];
    }
    return _dataArray;
}

@end

//
//  HLLoadingViewController.m
//  HLTool_Example
//
//  Created by feige on 2023/4/13.
//  Copyright © 2023 huangchangweng. All rights reserved.
//

#import "HLLoadingViewController.h"
#import <HLTool.h>

@interface HLLoadingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) HLLoadingView *loadingView;
@end

@implementation HLLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self requestData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.loadingView.frame = self.view.bounds;
}

#pragma mark - Private Method

- (void)setupSubviews
{
    WEAK_SELF
    
    // loadingView
    self.loadingView = [[HLLoadingView alloc] initWithFrame:self.view.bounds];
    self.loadingView.JHUDReloadButtonClickedBlock = ^(){
        [weakSelf requestData];
    };
}

- (void)requestData
{
    [self.loadingView showLoadingAtView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 2), dispatch_get_main_queue(), ^{
        NSMutableArray *arr = [self mockData];
        self.dataArray = arr;
        [self.tableView reloadData];
        
        if (arc4random() % 2 == 0) {
            [self.loadingView hide];
        } else {
            [self.loadingView showFailureAtView:self.view];
        }
    });
}

- (NSMutableArray *)mockData
{
    NSMutableArray *arr = [NSMutableArray new];
    for (int i=0; i<20; i++) {
        [arr addObject:[NSString stringWithFormat:@"我是内容%d", i]];
    }
    return arr;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

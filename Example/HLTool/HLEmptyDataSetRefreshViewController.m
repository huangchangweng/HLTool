//
//  HLEmptyDataSetRefreshViewController.m
//  HLTool_Example
//
//  Created by feige on 2023/4/13.
//  Copyright © 2023 huangchangweng. All rights reserved.
//

#import "HLEmptyDataSetRefreshViewController.h"
#import <HLTool.h>

@interface HLEmptyDataSetRefreshViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int page;
@end

@implementation HLEmptyDataSetRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupRefresh];
}

#pragma mark - Private Method

- (void)setupRefresh
{
    WEAK_SELF
//    [self.tableView hl_setRefreshWithHeaderBlock:^{ // 菊花样式
    [self.tableView hl_setGifRefreshWithHeaderBlock:^{ // git样式
        STRONG_SELF
        strongSelf.page = 0;
        [strongSelf requestData];
    } footerBlock:^{
        STRONG_SELF
        strongSelf.page ++;
        [strongSelf requestData];
    }];
    
    // 自动下拉刷新
    [self.tableView hl_headerBeginRefreshing];
    
    self.tableView.hl_buttonImage = [UIImage imageNamed:@"button"];
    [self.tableView hl_emptyDataSetTapButtonBlock:^{
        NSLog(@"点击了按钮");
    }];
    
    // 空数据占位点击回调，只用调用了此方法才会用空数据占位视图
    [self.tableView hl_emptyDataSetBlock:^{
        STRONG_SELF
        [strongSelf.tableView hl_headerBeginRefreshing];
    }];
}

- (void)requestData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 2), dispatch_get_main_queue(), ^{
        NSMutableArray *arr = [self mockData:self.page];
        if (self.page == 0) {
            self.dataArray = arr;
        } else {
            [self.dataArray addObjectsFromArray:arr];
        }
        
        if (self.dataArray.count == 0) {
            self.tableView.hl_emptyDataSetType = HLEmptyDataSetTypeNoData;
            [self.tableView hl_footerNoData];
        } else {
//            [self.tableView hl_footerNoMoreData];
            [self.tableView hl_footerEndRefreshing];
        }
        [self.tableView reloadData];
        [self.tableView hl_headerEndRefreshing];
        
    });
}

- (NSMutableArray *)mockData:(int)page
{
    if (page == 0 && arc4random() % 2 == 0) {
        return @[].mutableCopy;
    }
    
    NSMutableArray *arr = [NSMutableArray new];
    for (int i=page; i<(page+20); i++) {
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

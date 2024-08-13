//
//  HLPhotoViewController.m
//  HLTool_Example
//
//  Created by feige on 2023/4/13.
//  Copyright © 2023 huangchangweng. All rights reserved.
//

#import "HLPhotoViewController.h"
#import <HLTool.h>
#import <UIImageView+AFNetworking.h>

@interface HLPhotoViewController ()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *imageUrls;
@end

@implementation HLPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageUrls = @[@"https://p.ipic.vip/y642rg.jpg", @"https://p.ipic.vip/qpipwh.png", @"https://p.ipic.vip/js5g69.jpeg"];
    
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageView setImageWithURL:[NSURL URLWithString:self.imageUrls[idx]]];
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
    }];
}

#pragma mark - Resposne Event

- (void)tapImageView:(UITapGestureRecognizer *)sender
{
    UIImageView *imageView = (UIImageView *)sender.view;
    
    NSMutableArray *urls = [NSMutableArray new];
    for (NSString *url in self.imageUrls) {
        [urls addObject:[NSURL URLWithString:url]];
    }
    
    [HLPhotoTool showImageWithController:self
                                  source:urls
                                previews:self.imageViews
                                   index:imageView.tag];
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
    
    // 选择头像
    if (indexPath.row == 0) {
        [HLPhotoTool sheetPortraitWithController:self
                                           title:@"头像"
                                      completion:^(HLPhotoModel * _Nonnull model) {
            
        }];
    }
    // sheet 相册|拍照
    else if (indexPath.row == 1) {
        [HLPhotoTool sheetImagePickerWithController:self
                                              title:@"相册|拍照"
                                              count:1
                                               edit:NO
                                         completion:^(NSArray<HLPhotoModel *> * _Nonnull images) {
            
        }];
    }
    // 单张
    else if (indexPath.row == 2) {
        [HLPhotoTool imagePickerSingleWithController:self 
                                          openCamera:YES
                                        seletedVideo:YES
                                                edit:NO
                                          completion:^(HLPhotoModel * _Nonnull model) {
            
        }];
    }
    // 选择多张图片
    else if (indexPath.row == 3) {
        [HLPhotoTool imagePickerMultipleWithController:self 
                                            openCamera:YES
                                                 count:3
                                          seletedVideo:YES
                                            completion:^(NSArray<HLPhotoModel *> * _Nonnull images) {
            
        }];
    }
    
}

#pragma mark - Getter

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"选择头像", @"sheet 相册|拍照", @"单张", @"选择多张图片"];
    }
    return _dataArray;
}

@end

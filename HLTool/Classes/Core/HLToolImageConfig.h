//
//  HLToolImageConfig.h
//  HLTool
//
//  Created by 黄常翁 on 2023/12/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLToolImageConfig : NSObject

+ (instancetype)shared;

// EmptyDataSet
@property (nonatomic, strong) UIImage *noDataImage;
@property (nonatomic, strong) UIImage *customErrorImage;
// HUD
@property (nonatomic, strong) UIImage *hudRightImage;   ///< 白色背景
@property (nonatomic, strong) UIImage *hudSuccessImage; ///< 黑色半透明背景
@property (nonatomic, strong) UIImage *hudErrorImage;   ///< 黑色半透明背景
// LoadingView
@property (nonatomic, strong) NSArray<UIImage *> *lodingImages; ///< 加载中图片
@property (nonatomic, strong) UIImage *failureImage;            ///< 网络问题图片
@property (nonatomic, strong) UIImage *loadingCustomErrorImage; ///< 自定义图片
@property (nonatomic, strong) UIImage *backImage;               ///< 左上角返回按钮图片
// Refresh
@property (nonatomic, strong) NSArray<UIImage *> *refreshLodingImages;  ///< 加载中图片
@end

NS_ASSUME_NONNULL_END

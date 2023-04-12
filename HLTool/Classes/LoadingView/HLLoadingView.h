//
//  HLLoadingView.h
//  HLLoadingView
//
//  Created by JJB_iOS on 2022/5/27.
//

#import <JHUD/JHUD.h>

@interface HLLoadingView : JHUD

@property (nonatomic, strong) NSArray<UIImage *> *lodingImages UI_APPEARANCE_SELECTOR;  ///< 加载中图片
@property (nonatomic, strong) UIImage *failureImage UI_APPEARANCE_SELECTOR;             ///< 网络问题图片
@property (nonatomic, strong) UIImage *customErrorImage UI_APPEARANCE_SELECTOR;         ///< 自定义图片
@property (nonatomic, strong) UIImage *backImage UI_APPEARANCE_SELECTOR;                ///< 左上角返回按钮图片

/// 刷新按钮标题，默认“重试”
@property (nonatomic, copy) NSString *refreshButtonTitle UI_APPEARANCE_SELECTOR;
/// 刷新按钮标题颜色，默认0x4181FE
@property (nonatomic, strong) UIColor *refreshButtonTitleColor UI_APPEARANCE_SELECTOR;
/// 刷新按钮标题字体大小，[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]
@property (nonatomic, strong) UIFont *refreshButtonTitleFont UI_APPEARANCE_SELECTOR;
/// 刷新按钮边框颜色，默认0x4181FE
@property (nonatomic, strong) UIColor *refreshButtonBorderColor UI_APPEARANCE_SELECTOR;
/// 刷新按钮边框宽度，默认0.5f
@property (nonatomic, assign) CGFloat refreshButtonBorderWidth UI_APPEARANCE_SELECTOR;
/// 刷新按钮圆角大小，默认17.5f
@property (nonatomic, assign) CGFloat refreshButtonCornerRadius UI_APPEARANCE_SELECTOR;
/// 中间消息标签颜色，默认[UIColor lightGrayColor]
@property (nonatomic, strong) UIColor *messageLabelColor UI_APPEARANCE_SELECTOR;
/// 中间消息标签字体大小，默认[UIFont systemFontOfSize:16]
@property (nonatomic, strong) UIFont *messageLabelFont UI_APPEARANCE_SELECTOR;


/**
 *  可选初始化方法
 *  @param frame 位置大小
 *  @param lodingImages 加载中图片数组
 *  @param failureImage 失败图片
 *  @param customErrorImage 自定义错误图片（这里传了，在showErrorAtView:image:message:就可不传了）
 *  @param backImage 返回按钮图片
 */
- (instancetype)initWithFrame:(CGRect)frame
                 lodingImages:(NSArray<UIImage *> *)lodingImages
                 failureImage:(UIImage *)failureImage
             customErrorImage:(UIImage *)customErrorImage
                    backImage:(UIImage *)backImage;

/**
 *  显示加载中的样式
 */
- (void)showLoadingAtView:(UIView *)view;
/**
 *  显示网络问题的样式
 */
- (void)showFailureAtView:(UIView *)view;
/**
 *  显示自定义错误样式
 *  image 自定义错误图片（可不传）
 *  message 自定义错误消息
 */
- (void)showErrorAtView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message;

/// 设置了该block左上角就会显示返回按钮
@property (nonatomic, copy) void(^backButtonClickedBlock)(void);

@end

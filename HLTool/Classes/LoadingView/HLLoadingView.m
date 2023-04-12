//
//  HLLoadingView.m
//  HLLoadingView
//
//  Created by JJB_iOS on 2022/5/27.
//

#import "HLLoadingView.h"
#import "HLDefine.h"

@interface HLLoadingView()
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation HLLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    
    NSMutableArray *lodingImages = [NSMutableArray array];
    for (int index = 1; index<=3; index++) {
        UIImage *lodingImage = GetImageWithName([NSString stringWithFormat:@"loading_%d.png",index]);
        [lodingImages addObject:lodingImage];
    }
    
    UIImage *failureImage = GetImageWithName(@"no_notwork");
    UIImage *customErrorImage = GetImageWithName(@"server_error");
    UIImage *backImage = GetImageWithName(@"nav_back_black");
    
    return [self initWithFrame:frame
                  lodingImages:lodingImages
                  failureImage:failureImage
              customErrorImage:customErrorImage
                     backImage:backImage];
}

- (instancetype)initWithFrame:(CGRect)frame
                 lodingImages:(NSArray<UIImage *> *)lodingImages
                 failureImage:(UIImage *)failureImage
             customErrorImage:(UIImage *)customErrorImage
                    backImage:(UIImage *)backImage;
{
    if (self = [super initWithFrame:frame]) {
        // image
        _lodingImages = lodingImages;
        _failureImage = failureImage;
        _customErrorImage = customErrorImage;
        _backImage = backImage;
        // other
        UIColor *defaultColor = UIColorFromHEX(0x4181FE);
        _refreshButtonTitle = GetLocalLanguageTextValue(@"Retry");
        _refreshButtonTitleColor = defaultColor;
        _refreshButtonTitleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _refreshButtonBorderColor = defaultColor;
        _refreshButtonBorderWidth = 0.5f;
        _refreshButtonCornerRadius = 17.5f;
        _messageLabelColor = [UIColor lightGrayColor];
        _messageLabelFont = [UIFont systemFontOfSize:16];
        
        self.backgroundColor = [UIColor whiteColor];
        // backButton
        [self.backButton setImage:_backImage forState:UIControlStateNormal];
        [self addSubview:self.backButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // messageLabel
    self.messageLabel.textColor = _messageLabelColor;
    self.messageLabel.font = _messageLabelFont;
    // refreshButton
    self.refreshButton.layer.borderColor = _refreshButtonBorderColor.CGColor;
    self.refreshButton.layer.borderWidth = _refreshButtonBorderWidth;
    self.refreshButton.layer.cornerRadius = _refreshButtonCornerRadius;
    self.refreshButton.titleLabel.font = _refreshButtonTitleFont;
    [self.refreshButton setTitle:_refreshButtonTitle forState:UIControlStateNormal];
    [self.refreshButton setTitleColor:_refreshButtonTitleColor forState:UIControlStateNormal];
}

#pragma mark - Public Method

- (void)showLoadingAtView:(UIView *)view
{
    self.indicatorViewSize = self.lodingImages.firstObject.size;
    self.customAnimationImages = self.lodingImages;
    self.messageLabel.text = nil;
    [self showAtView:view hudType:JHUDLoadingTypeCustomAnimations];
}

- (void)showFailureAtView:(UIView *)view
{
    self.indicatorViewSize = self.failureImage.size;
    self.messageLabel.text = GetLocalLanguageTextValue(@"NetworkError");
    self.customImage = self.failureImage;

    [self showAtView:view hudType:JHUDLoadingTypeFailure];
}

- (void)showErrorAtView:(UIView *)view
                  image:(UIImage *)image
                message:(NSString *)message
{
    if (!image) {
        image = self.customErrorImage;
    }
    self.indicatorViewSize = image.size;
    self.messageLabel.text = message;
    [self.refreshButton setTitle:GetLocalLanguageTextValue(@"Retry") forState:UIControlStateNormal];
    self.customImage = image;

    [self showAtView:view hudType:JHUDLoadingTypeFailure];
}

#pragma mark - Response Event

- (void)backAction
{
    if (self.backButtonClickedBlock) {
        self.backButtonClickedBlock();
    }
}

#pragma mark - Getter

- (UIButton *)backButton {
    if (!_backButton) {
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton sizeToFit];
        [backButton addTarget:self
                       action:@selector(backAction)
             forControlEvents:UIControlEventTouchUpInside];
        backButton.frame = CGRectMake(0, kStatusBarHeight, 44, 44);
        backButton.hidden = YES;
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _backButton = backButton;
    }
    return _backButton;
}

- (void)setBackButtonClickedBlock:(void (^)(void))backButtonClickedBlock {
    _backButtonClickedBlock = backButtonClickedBlock;
    _backButton.hidden = _backButtonClickedBlock==nil;
}

@end

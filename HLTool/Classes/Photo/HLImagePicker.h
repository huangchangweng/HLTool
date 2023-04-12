//
//  HLImagePicker.h
//  HLTool
//
//  Created by feige on 2023/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HLImagePickerType) {
    HLImagePickerTypePhoto, // 照片
    HLImagePickerTypeCamera = 0, // 拍照
    HLImagePickerTypeTake,  // 拍摄
};

typedef void(^CallBackBlock)( NSDictionary * _Nullable infoDict, BOOL isCancel);  // 回调


@interface HLImagePicker : NSObject

/// 相机视频录制最大秒数  -  默认60s
@property (nonatomic, assign) NSTimeInterval videoMaximumDuration;

+ (instancetype)shareInstance; // 单例

- (void)presentPicker:(HLImagePickerType)pickerType target:(UIViewController *)vc callBackBlock:(CallBackBlock)callBackBlock;

@end

NS_ASSUME_NONNULL_END

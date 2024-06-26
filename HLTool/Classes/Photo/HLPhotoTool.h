//
//  HLPhotoTool.h
//  HLTool
//
//  Created by feige on 2023/4/11.
//

#import <Foundation/Foundation.h>
@class HLPhotoModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HLPhotoModelMediaType) {
    HLPhotoModelMediaTypePhoto          = 0,    //!< 照片
    HLPhotoModelMediaTypeLivePhoto      = 1,    //!< LivePhoto
    HLPhotoModelMediaTypePhotoGif       = 2,    //!< gif图
    HLPhotoModelMediaTypeVideo          = 3,    //!< 视频
    HLPhotoModelMediaTypeAudio          = 4,    //!< 预留
    HLPhotoModelMediaTypeCameraPhoto    = 5,    //!< 通过相机拍的临时照片、本地/网络图片
    HLPhotoModelMediaTypeCameraVideo    = 6,    //!< 通过相机录制的视频、本地视频
    HLPhotoModelMediaTypeCamera         = 7     //!< 跳转相机
};

typedef void (^HLPhotoToolCompletion)(HLPhotoModel *model);
typedef void (^HLPhotoToolMultipleCompletion)(NSArray <HLPhotoModel *> *images);

@interface HLPhotoTool : NSObject


/// 选择头像图片，裁剪正方形
+ (void)sheetPortraitWithController:(UIViewController *)vc title:(NSString *)title completion:(HLPhotoToolCompletion)completion;


/// sheet 相册|拍照
+ (void)sheetImagePickerWithController:(UIViewController *)vc title:(NSString *)title count:(NSInteger)count edit:(BOOL)edit completion:(HLPhotoToolMultipleCompletion)completion;


/// 单张
+ (void)imagePickerSingleWithController:(UIViewController *)vc openCamera:(BOOL)openCamera seletedVideo:(BOOL)seletedVideo edit:(BOOL)edit completion:(HLPhotoToolCompletion)completion;


/// 选择多张图片
+ (void)imagePickerMultipleWithController:(UIViewController *)vc openCamera:(BOOL)openCamera count:(NSInteger)count seletedVideo:(BOOL)seletedVideo completion:(HLPhotoToolMultipleCompletion)completion;


/// 拍照|视频 默认可编辑
+ (void)cameraWithController:(UIViewController *)vc video:(BOOL)video system:(BOOL)system completion:(HLPhotoToolCompletion)completion;
+ (void)cameraWithController:(UIViewController *)vc video:(BOOL)video edit:(BOOL)edit system:(BOOL)system completion:(HLPhotoToolCompletion)completion;


/// 预览图片
/// @param vc sender
/// @param source 3种类型 NSURL UIImage NSString(路径)
/// @param previews 小图imageView
/// @param index 第几张
+ (void)showImageWithController:(UIViewController *)vc source:(NSArray *)source previews:(nullable NSArray *)previews index:(NSInteger)index;

/// 预览视频
/// @param vc sender
/// @param videoURL 视频地址URL
/// @param converURL 缩略图地址URL
/// @param videoDuration 视频时间
/// @param preview 小图imageView
+ (void)showVideoWithController:(UIViewController *)vc videoURL:(NSURL *)videoURL coverURL:(nullable NSURL *)converURL videoDuration:(NSTimeInterval)videoDuration preview:(nullable UIView *)preview;

/// 编辑图片|视频
/// @param vc sender
/// @param source 2种类型 NSURL UIImage
/// @param isVideo 是否是视频
/// @param completion 回调
+ (void)editImageWithController:(UIViewController *)vc source:(id)source isVideo:(BOOL)isVideo completion:(HLPhotoToolCompletion)completion;


/// 保存图片到相册 可保存gif路径图片
+ (BOOL)saveToAlbum:(id)image;
+ (BOOL)saveToAlbumAtPath:(NSString *)path;
+ (BOOL)saveToAlbumAtFileURL:(NSURL *)fileURL;
+ (BOOL)saveToAlbumAtImage:(UIImage *)image;
+ (BOOL)saveToAlbumAtVideoURL:(NSURL *)videoURL;

@end


@interface HLPhotoModel : NSObject

@property (nonatomic, strong) UIImage * _Nullable image;
@property (nonatomic, strong) NSURL * _Nullable videoURL;

@property (nonatomic, strong) NSData * _Nullable data;

@property (nonatomic, assign) HLPhotoModelMediaType type;

+ (instancetype)modelWithImage:(nullable UIImage *)image video:(nullable NSURL *)video data:(nullable NSData *)data type:(HLPhotoModelMediaType)type;

@end

NS_ASSUME_NONNULL_END

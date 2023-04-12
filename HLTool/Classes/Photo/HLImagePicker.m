//
//  HLImagePicker.m
//  HLTool
//
//  Created by feige on 2023/4/11.
//

#import "HLImagePicker.h"
#import "HLAlertTool.h"
#import "HLDefine.h"
#import <CoreServices/CoreServices.h>


@interface HLImagePicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController     *_imgPickC;
    UIViewController            *_vc;
    CallBackBlock                _callBackBlock;
}

@end

@implementation HLImagePicker

+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static HLImagePicker *pickManager;
    dispatch_once(&once, ^{
        pickManager = [[HLImagePicker alloc] init];
    });
    
    return pickManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if(!_imgPickC) {
            _imgPickC = [[UIImagePickerController alloc] init];  // 初始化 _imgPickC
            _videoMaximumDuration = 60;
        }
    }
    return self;
}

- (void)presentPicker:(HLImagePickerType)pickerType target:(UIViewController *)vc callBackBlock:(CallBackBlock)callBackBlock {
    _vc = vc;
    _callBackBlock = callBackBlock;
    if(pickerType == HLImagePickerTypeCamera || pickerType == HLImagePickerTypeTake) {
        // 拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _imgPickC.delegate = self;
            _imgPickC.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imgPickC.showsCameraControls = YES;
            
            // 录制
            if (pickerType == HLImagePickerTypeTake) {
                _imgPickC.mediaTypes = @[(NSString *)kUTTypeMovie];
                _imgPickC.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
                _imgPickC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                _imgPickC.videoMaximumDuration = self.videoMaximumDuration;
                
                _imgPickC.allowsEditing = YES;

            } else {
                _imgPickC.allowsEditing = NO;

            }
            
            UIView *view = [[UIView  alloc] init];
            view.backgroundColor = [UIColor grayColor];
            _imgPickC.cameraOverlayView = view;
            [_vc presentViewController:_imgPickC animated:YES completion:nil];
        } else {
            [HLAlertTool alertWithMessage:GetLocalLanguageTextValue(@"CameraNotAvailable")];
        }
    } else if (pickerType == HLImagePickerTypePhoto) {
        // 相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            _imgPickC.delegate = self;
            _imgPickC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            _imgPickC.allowsEditing = YES;
            [_vc presentViewController:_imgPickC animated:YES completion:nil];
        } else {
            [HLAlertTool alertWithMessage:GetLocalLanguageTextValue(@"CameraNotAvailable")];
        }

    }
}

#pragma mark ---- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [_vc dismissViewControllerAnimated:YES completion:^{
        self->_callBackBlock(info, NO); // block回调
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_vc dismissViewControllerAnimated:YES completion:^{
        self->_callBackBlock(nil, YES); // block回调
    }];
}

@end

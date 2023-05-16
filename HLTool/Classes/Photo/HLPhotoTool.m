//
//  HLPhotoTool.m
//  HLTool
//
//  Created by feige on 2023/4/11.
//

#import "HLPhotoTool.h"
#import <HXPhotoPicker/HXPhotoPicker.h>
#import "HLToastTool.h"
#import "HLDefine.h"
#import "HLImagePicker.h"

@implementation HLPhotoTool

+ (NSInteger)getLanaguage {
    HLLanguageType type = [[[NSUserDefaults standardUserDefaults] valueForKey:HLLanguageTypeKey] integerValue];
    return type;
}

+ (void)getPhoto:(HXPhotoModel *)model success:(void(^)(HLPhotoModel *photo))success failed:(HXModelFailedBlock)failed {
    
    if (model.subType == HXPhotoModelMediaSubTypePhoto) {
        if (model.type == HXPhotoModelMediaTypePhotoGif) {
            // gif
            [[PHImageManager defaultManager] requestImageDataForAsset:model.asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                
                HLPhotoModel *pModel = [HLPhotoModel modelWithImage:nil video:nil data:imageData type:HLPhotoModelMediaTypePhotoGif];
                if (success) {
                    success(pModel);
                }
                
             }];
        } else {
            // image
            [model getImageWithSuccess:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                
                HLPhotoModel *pModel = [HLPhotoModel modelWithImage:image video:nil data:nil type:HLPhotoModelMediaTypePhoto];

                if (success) {
                    success(pModel);
                }

            } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                NSLog(@"failed: %@", info);
                if (failed) {
                    failed(info, model);
                }
            }];
            
        }
        
    } else {
        [model getVideoURLWithSuccess:^(NSURL * _Nullable URL, HXPhotoModelMediaSubType mediaType, BOOL isNetwork, HXPhotoModel * _Nullable model) {
            
            HLPhotoModel *pModel = [HLPhotoModel modelWithImage:nil video:URL data:nil type:HLPhotoModelMediaTypeVideo];

            if (success) {
                success(pModel);
            }

        } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
            NSLog(@"failed: %@", info);
            if (failed) {
                failed(info, model);
            }
        }];
    }
    
}

+ (void)sheetPortraitWithController:(UIViewController *)vc title:(NSString *)title completion:(HLPhotoToolCompletion)completion {
    
    HXPhotoBottomViewModel *model1 = [[HXPhotoBottomViewModel alloc] init];
    model1.title = title;
    model1.titleColor = [UIColor hx_colorWithHexStr:@"#999999"];
    model1.cellHeight = 40.f;
    model1.titleFont = [UIFont systemFontOfSize:13];
    model1.canSelect = NO;
    
    HXPhotoBottomViewModel *model2 = [[HXPhotoBottomViewModel alloc] init];
    model2.title = GetLocalLanguageTextValue(@"TakePicture");
    
    HXPhotoBottomViewModel *model3 = [[HXPhotoBottomViewModel alloc] init];
    model3.title = GetLocalLanguageTextValue(@"SelectFromPhoneAlbum");
    
    HXPhotoManager *photoManager = [HXPhotoManager managerWithType:HXPhotoManagerSelectedTypePhoto];
    
    photoManager.configuration.type = HXConfigurationTypeWXChat;
    photoManager.configuration.languageType = [self getLanaguage];
    
    photoManager.configuration.singleJumpEdit = YES;
    photoManager.configuration.singleSelected = YES;
    photoManager.configuration.lookGifPhoto = NO;
    photoManager.configuration.lookLivePhoto = NO;
    photoManager.configuration.openCamera = NO;
    photoManager.configuration.photoEditConfigur.aspectRatio = HXPhotoEditAspectRatioType_1x1;
    photoManager.configuration.photoEditConfigur.onlyCliping = YES;
    
    [HXPhotoBottomSelectView showSelectViewWithModels:@[model1, model2, model3] selectCompletion:^(NSInteger index, HXPhotoBottomViewModel * _Nonnull model) {
        
        if (index == 1) {
            // 拍照
            [vc hx_presentCustomCameraViewControllerWithManager:photoManager done:^(HXPhotoModel *model, HXCustomCameraViewController *viewController) {
                
                [self getPhoto:model success:completion failed:nil];

            } cancel:nil];
        } else if (index == 2) {
            // 相册
            [vc hx_presentSelectPhotoControllerWithManager:photoManager didDone:^(NSArray<HXPhotoModel *> * _Nullable allList, NSArray<HXPhotoModel *> * _Nullable photoList, NSArray<HXPhotoModel *> * _Nullable videoList, BOOL isOriginal, UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
                
                [self getPhoto:allList.firstObject success:completion failed:nil];

            } cancel:nil];
        }
    } cancelClick:nil];
    
}

+ (void)sheetImagePickerWithController:(UIViewController *)vc title:(NSString *)title count:(NSInteger)count edit:(BOOL)edit completion:(HLPhotoToolMultipleCompletion)completion {
    
    HXPhotoBottomViewModel *model1 = [[HXPhotoBottomViewModel alloc] init];
    model1.title = title;
    model1.titleColor = [UIColor hx_colorWithHexStr:@"#999999"];
    model1.cellHeight = 40.f;
    model1.titleFont = [UIFont systemFontOfSize:13];
    model1.canSelect = NO;
    
    HXPhotoBottomViewModel *model2 = [[HXPhotoBottomViewModel alloc] init];
    model2.title = GetLocalLanguageTextValue(@"TakePicture");
    
    HXPhotoBottomViewModel *model3 = [[HXPhotoBottomViewModel alloc] init];
    model3.title = GetLocalLanguageTextValue(@"SelectFromPhoneAlbum");
    
    HXPhotoManager *photoManager = [HXPhotoManager managerWithType:HXPhotoManagerSelectedTypePhoto];
    
    photoManager.configuration.type = HXConfigurationTypeWXChat;
    photoManager.configuration.languageType = [self getLanaguage];
    
    photoManager.configuration.lookGifPhoto = NO;
    photoManager.configuration.lookLivePhoto = NO;
    photoManager.configuration.openCamera = NO;
    
    photoManager.configuration.maxNum = count;
    photoManager.configuration.singleSelected = count == 1;
    
    photoManager.configuration.photoCanEdit = edit;

    [HXPhotoBottomSelectView showSelectViewWithModels:@[model1, model2, model3] selectCompletion:^(NSInteger index, HXPhotoBottomViewModel * _Nonnull model) {
        
        if (index == 1) {
            // 拍照
            [vc hx_presentCustomCameraViewControllerWithManager:photoManager done:^(HXPhotoModel *model, HXCustomCameraViewController *viewController) {
                
                HLPhotoModel *pModel = [HLPhotoModel modelWithImage:model.previewPhoto video:nil data:nil type:HLPhotoModelMediaTypePhoto];

                if (completion && pModel) {
                    completion(@[pModel]);
                    return;
                }
                
                [self getPhoto:model success:^(HLPhotoModel *photo) {
                    if (completion) {
                        completion(@[photo]);
                    }
                } failed:nil];

            } cancel:nil];
        } else if (index == 2) {
            // 相册
            [vc hx_presentSelectPhotoControllerWithManager:photoManager didDone:^(NSArray<HXPhotoModel *> * _Nullable allList, NSArray<HXPhotoModel *> * _Nullable photoList, NSArray<HXPhotoModel *> * _Nullable videoList, BOOL isOriginal, UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
                
                NSMutableArray *mArr = [NSMutableArray array];
                for (int i = 0; i < allList.count; i++) {
                    [self getPhoto:allList[i] success:^(HLPhotoModel *photo) {
                        
                        [mArr addObject:photo];
                        
                        if (mArr.count == allList.count) {
                            if (completion) {
                                completion(mArr);
                            }
                        }
                        
                    } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                        // TODO
                    }];
                }
                
            } cancel:nil];
        }
    } cancelClick:nil];
    
}

+ (void)imagePickerSingleWithController:(UIViewController *)vc seletedVideo:(BOOL)seletedVideo edit:(BOOL)edit completion:(HLPhotoToolCompletion)completion {
    
    HXPhotoManager *photoManager = [HXPhotoManager managerWithType:seletedVideo?HXPhotoManagerSelectedTypePhotoAndVideo:HXPhotoManagerSelectedTypePhoto];
    photoManager.configuration.maxNum = 1;
    photoManager.configuration.singleSelected = YES;
    photoManager.configuration.openCamera = NO;
    photoManager.configuration.videoAutoPlayType = YES;
    photoManager.configuration.photoCanEdit = edit;
    photoManager.configuration.videoCanEdit = edit;
    
    photoManager.configuration.type = HXConfigurationTypeWXChat;
    photoManager.configuration.languageType = [self getLanaguage];

    [vc hx_presentSelectPhotoControllerWithManager:photoManager didDone:^(NSArray<HXPhotoModel *> * _Nullable allList, NSArray<HXPhotoModel *> * _Nullable photoList, NSArray<HXPhotoModel *> * _Nullable videoList, BOOL isOriginal, UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        
        NSSLog(@"block - all - %@", allList);

        HXPhotoModel *model = allList.firstObject;

        [self getPhoto:model success:completion failed:nil];
                
    } cancel:^(UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        
    }];
    
}

+ (void)imagePickerMultipleWithController:(UIViewController *)vc count:(NSInteger)count seletedVideo:(BOOL)seletedVideo completion:(HLPhotoToolMultipleCompletion)completion {
    
    HXPhotoManager *photoManager = [HXPhotoManager managerWithType:seletedVideo?HXPhotoManagerSelectedTypePhotoAndVideo:HXPhotoManagerSelectedTypePhoto];
    
    photoManager.configuration.type = HXConfigurationTypeWXChat;
    photoManager.configuration.languageType = [self getLanaguage];

    photoManager.configuration.videoAutoPlayType = YES;
    photoManager.configuration.maxNum = count;
    photoManager.configuration.openCamera = NO;
    photoManager.configuration.singleSelected = count == 1;

    [vc hx_presentSelectPhotoControllerWithManager:photoManager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        
        NSSLog(@"block - all - %@", allList);

        NSMutableArray *mArr = [NSMutableArray array];
        for (int i = 0; i < allList.count; i++) {
            [self getPhoto:allList[i] success:^(HLPhotoModel *photo) {
                
                [mArr addObject:photo];
                
                if (mArr.count == allList.count) {
                    if (completion) {
                        completion(mArr);
                    }
                }
                
            } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                // TODO
                
            }];
        }
        
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        NSSLog(@"block - 取消了");
    }];
}


/// 拍照
+ (void)cameraWithController:(UIViewController *)vc video:(BOOL)video system:(BOOL)system completion:(HLPhotoToolCompletion)completion {
    [self cameraWithController:vc video:video edit:YES system:system completion:completion];
}


+ (void)cameraWithController:(UIViewController *)vc video:(BOOL)video edit:(BOOL)edit system:(BOOL)system completion:(HLPhotoToolCompletion)completion {
    
    if (system) {
        
        [[HLImagePicker shareInstance] presentPicker:(video ? HLImagePickerTypeTake : HLImagePickerTypeCamera) target:vc callBackBlock:^(NSDictionary * _Nullable infoDict, BOOL isCancel) {
            
            if (isCancel) {
                return;
            }
            
            if (video) {
                NSURL *url = [infoDict objectForKey:UIImagePickerControllerMediaURL]; // 视频路径
                if (completion && url) {
                    HLPhotoModel *pModel = [HLPhotoModel modelWithImage:nil video:url data:nil type:HLPhotoModelMediaTypeVideo];
                    completion(pModel);
                }
            } else {
                UIImage *image = [infoDict valueForKey:UIImagePickerControllerOriginalImage];
                if (completion && image) {
                    HLPhotoModel *pModel = [HLPhotoModel modelWithImage:image video:nil data:nil type:HLPhotoModelMediaTypePhoto];
                    completion(pModel);
                }
            }
            
        }];
        
        return;
    }
    
    HXPhotoManager *photoManager = [HXPhotoManager managerWithType:video?HXPhotoManagerSelectedTypePhotoAndVideo:HXPhotoManagerSelectedTypePhoto];
    
    photoManager.configuration.type = HXConfigurationTypeWXChat;
    photoManager.configuration.languageType = [self getLanaguage];
    
    photoManager.configuration.photoCanEdit = edit;
    photoManager.configuration.videoCanEdit = edit;

    [vc hx_presentCustomCameraViewControllerWithManager:photoManager done:^(HXPhotoModel *model, HXCustomCameraViewController *viewController) {
        
        [self getPhoto:model success:completion failed:nil];

    } cancel:nil];
}


/// 预览图片
+ (void)showImageWithController:(UIViewController *)vc source:(NSArray *)source previews:(NSArray *)previews index:(NSInteger)index {
    
    NSMutableArray *arrImages = [NSMutableArray array];

    for (int i = 0; i < source.count; i ++) {
        id obj = source[i];
        if ([obj isKindOfClass:[NSURL class]]) {
            // 网络图片
            HXCustomAssetModel *model = [HXCustomAssetModel assetWithNetworkImageURL:obj selected:YES];
            [arrImages  addObject:model];
            
        } else if ([obj isKindOfClass:[NSString class]]) {
            // 路径
            HXCustomAssetModel *model = [HXCustomAssetModel assetWithImagePath:[NSURL fileURLWithPath:obj] selected:YES];
            [arrImages addObject:model];
            
        } else if ([obj isKindOfClass:[UIImage class]]) {
            HXCustomAssetModel *model = [HXCustomAssetModel assetWithLocalImage:obj selected:YES];
            [arrImages addObject:model];
        }
    }
    
    if (arrImages.count == 0) {
        return;
    }
    
    HXPhotoManager *photoManager = [HXPhotoManager managerWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
    photoManager.configuration.saveSystemAblum = YES;
    photoManager.configuration.photoMaxNum = 0;
    photoManager.configuration.videoMaxNum = 0;
    photoManager.configuration.maxNum = 10;
    photoManager.configuration.selectTogether = YES;
    photoManager.configuration.photoCanEdit = NO;
    photoManager.configuration.videoCanEdit = NO;
    photoManager.configuration.videoAutoPlayType = HXVideoAutoPlayTypeAll;

    photoManager.configuration.languageType = [self getLanaguage];
    
    // 长按事件
    photoManager.configuration.previewRespondsToLongPress = ^(UILongPressGestureRecognizer *longPress, HXPhotoModel *photoModel, HXPhotoManager *manager, HXPhotoPreviewViewController *previewViewController) {
        HXPhotoBottomViewModel *model = [[HXPhotoBottomViewModel alloc] init];
        model.title = GetLocalLanguageTextValue(@"Save");
        [HXPhotoBottomSelectView showSelectViewWithModels:@[model] headerView:nil cancelTitle:nil selectCompletion:^(NSInteger index, HXPhotoBottomViewModel * _Nonnull model) {
            if (index == 0) {
                // 保存
                if (photoModel.subType == HXPhotoModelMediaSubTypePhoto) {
                    // gif
                    if (photoModel.cameraPhotoType == HXPhotoModelMediaTypeCameraPhotoTypeLocalGif && photoModel.imageURL) {
                        [HLPhotoTool saveToAlbum:photoModel.imageURL];
                    } else {
                        [HLPhotoTool saveToAlbum:photoModel.previewPhoto];
                    }

                } else {
                    // 视频
                    [HLPhotoTool saveToAlbumAtVideoURL:photoModel.videoURL];
                }
                
            }
        } cancelClick:nil];
    };
    
    [photoManager addCustomAssetModel:arrImages];
    
    // 跳转预览界面时动画起始的view
    photoManager.configuration.customPreviewFromView = ^UIView *(NSInteger currentIndex) {
        if (!previews || previews.count <= currentIndex || ![previews[currentIndex] isKindOfClass:[UIView class]]) {
            return nil;
        }
        return previews.count > currentIndex ? previews[currentIndex] : nil;
    };
    // 跳转预览界面时展现动画的image
    photoManager.configuration.customPreviewFromImage = ^UIImage *(NSInteger currentIndex) {
        if (!previews || previews.count <= currentIndex || ![previews[currentIndex] isKindOfClass:[UIView class]]) {
            return nil;
        }
        if ([previews[currentIndex] isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)previews[currentIndex];
            return imageView.image;
        }
        return nil;
    };
    // 退出预览界面时终点view
    photoManager.configuration.customPreviewToView = ^UIView *(NSInteger currentIndex) {
        if (!previews || previews.count <= currentIndex || ![previews[currentIndex] isKindOfClass:[UIView class]]) {
            return nil;
        }
        return previews.count > currentIndex ? previews[currentIndex] : nil;
    };

    [vc hx_presentPreviewPhotoControllerWithManager:photoManager
                                         previewStyle:HXPhotoViewPreViewShowStyleDark
                                         currentIndex:index
                                            photoView:nil];
}


/// 预览视频
+ (void)showVideoWithController:(UIViewController *)vc videoURL:(NSURL *)videoURL coverURL:(NSURL *)converURL videoDuration:(NSTimeInterval)videoDuration preview:(UIView *)preview {
    
    HXCustomAssetModel *model = [HXCustomAssetModel assetWithNetworkVideoURL:videoURL videoCoverURL:converURL videoDuration:videoDuration selected:YES];
    
    HXPhotoManager *photoManager = [HXPhotoManager managerWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
    photoManager.configuration.saveSystemAblum = YES;
    photoManager.configuration.photoMaxNum = 0;
    photoManager.configuration.videoMaxNum = 0;
    photoManager.configuration.maxNum = 10;
    photoManager.configuration.selectTogether = YES;
    photoManager.configuration.photoCanEdit = NO;
    photoManager.configuration.videoCanEdit = NO;
    photoManager.configuration.videoAutoPlayType = HXVideoAutoPlayTypeAll;
    photoManager.configuration.languageType = [self getLanaguage];
    
    [photoManager addCustomAssetModel:@[model]];
    
    // 长按事件
    photoManager.configuration.previewRespondsToLongPress = ^(UILongPressGestureRecognizer *longPress, HXPhotoModel *photoModel, HXPhotoManager *manager, HXPhotoPreviewViewController *previewViewController) {
        HXPhotoBottomViewModel *model = [[HXPhotoBottomViewModel alloc] init];
        model.title = GetLocalLanguageTextValue(@"Save");
        [HXPhotoBottomSelectView showSelectViewWithModels:@[model] headerView:nil cancelTitle:nil selectCompletion:^(NSInteger index, HXPhotoBottomViewModel * _Nonnull model) {
            if (index == 0) {
                // 保存
                [HLPhotoTool saveToAlbumAtVideoURL:photoModel.videoURL];
            }
        } cancelClick:nil];
    };
    
    // 跳转预览界面时动画起始的view
    photoManager.configuration.customPreviewFromView = ^UIView *(NSInteger currentIndex) {
        return preview;
    };
    // 跳转预览界面时展现动画的image
    photoManager.configuration.customPreviewFromImage = ^UIImage *(NSInteger currentIndex) {
        if ([preview isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)preview;
            return imageView.image;
        }
        return nil;
    };
    // 退出预览界面时终点view
    photoManager.configuration.customPreviewToView = ^UIView *(NSInteger currentIndex) {
        return preview;
    };

    [vc hx_presentPreviewPhotoControllerWithManager:photoManager
                                         previewStyle:HXPhotoViewPreViewShowStyleDark
                                         currentIndex:0
                                            photoView:nil];

}


/// 编辑图片|视频
+ (void)editImageWithController:(UIViewController *)vc source:(id)source isVideo:(BOOL)isVideo completion:(HLPhotoToolCompletion)completion {
        
    // 照片  视频url
    
    HXPhotoModel *model = nil;
    if (isVideo) {
        model = [HXPhotoModel photoModelWithVideoURL:source];
    } else {
        if ([source isKindOfClass:[UIImage class]]) {
            model = [HXPhotoModel photoModelWithImage:source];
        } else if ([source isKindOfClass:[NSURL class]]) {
            model = [HXPhotoModel photoModelWithImage:source];
        }
    }
    
    if (!model) {
        return;
    }
    
    // 使用仿微信编辑功能
    HXPhotoManager *photoManager = [HXPhotoManager managerWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
    photoManager.configuration.languageType = [self getLanaguage];

    [vc hx_presentWxPhotoEditViewControllerWithConfiguration:photoManager.configuration.photoEditConfigur photoModel:model delegate:nil finish:^(HXPhotoEdit * _Nonnull photoEdit, HXPhotoModel * _Nonnull photoModel, HX_PhotoEditViewController * _Nonnull viewController) {
        
        if (completion) {
            
            [self getPhoto:photoModel success:completion failed:nil];

        }
        
    } cancel:^(HX_PhotoEditViewController * _Nonnull viewController) {
        // 取消
    }];

}

+ (BOOL)saveToAlbum:(id)image {
    if (!image) {
        return NO;
    }
    if ([image isKindOfClass:[UIImage class]]) {
        [self saveToAlbumAtImage:image];
        return YES;
    } else if ([image isKindOfClass:[NSURL class]]) {
        return [self saveToAlbumAtFileURL:image];
    } else if ([image isKindOfClass:[NSString class]]) {
        return [self saveToAlbumAtPath:image];
    }
    return NO;
}

+ (BOOL)saveToAlbumAtPath:(NSString *)path {
    if (!path) {
        return NO;
    }
    return [self saveToAlbumAtFileURL:[NSURL fileURLWithPath:path]];
}

+ (BOOL)saveToAlbumAtFileURL:(NSURL *)fileURL {
    if (!fileURL) {
        return NO;
    }
    __block NSString *createdAssetID = nil; // 唯一标识，可以用于图片资源获取
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetID = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:fileURL].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    BOOL success = createdAssetID && !error;
    if (success) {
        [HLToastTool showAtCenter:GetLocalLanguageTextValue(@"SaveSuccess")];
    } else {
        [HLToastTool showAtCenter:GetLocalLanguageTextValue(@"SaveFailed")];
    }
    return success;
}

+ (BOOL)saveToAlbumAtImage:(UIImage *)image {
    if (!image) {
        return NO;
    }
    [HXPhotoTools savePhotoToCustomAlbumWithName:nil photo:image location:nil complete:^(HXPhotoModel * _Nullable model, BOOL success) {
        if (success) {
            [HLToastTool showAtCenter:GetLocalLanguageTextValue(@"SaveSuccess")];
        } else {
            [HLToastTool showAtCenter:GetLocalLanguageTextValue(@"SaveFailed")];
        }
    }];
    return YES;
}

+ (BOOL)saveToAlbumAtVideoURL:(NSURL *)videoURL {
    if (!videoURL) {
        return NO;
    }
    [HXPhotoTools saveVideoToCustomAlbumWithName:nil videoURL:videoURL location:nil complete:^(HXPhotoModel * _Nullable model, BOOL success) {
        if (success) {
            [HLToastTool showAtCenter:GetLocalLanguageTextValue(@"SaveSuccess")];
        } else {
            [HLToastTool showAtCenter:GetLocalLanguageTextValue(@"SaveFailed")];
        }
    }];
    return YES;
}

@end


@implementation HLPhotoModel

+ (instancetype)modelWithImage:(UIImage *)image video:(NSURL *)video data:(NSData *)data type:(HLPhotoModelMediaType)type {
    HLPhotoModel *model = [[HLPhotoModel alloc] init];
    model.image = image;
    model.videoURL = video;
    model.data = data;
    model.type = type;
    return model;
}

@end

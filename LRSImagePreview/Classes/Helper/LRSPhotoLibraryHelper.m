//
//  LRSPhotoLibraryHelper.m
//  LRSPhotoLibraryHelper
//
//  Created by sama 刘 on 2021/8/13.
//

#import "LRSPhotoLibraryHelper.h"

@implementation LRSPhotoLibraryHelper

+ (void)requestLibraryAuthorization:(void (^)(PHAuthorizationStatus, BOOL))handler {
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            /// 权限不足
            /// 1. 家长控制
            /// 2. 拒绝
            ///
            handler(status, status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied);
        }];
    } else {
        handler(authStatus, !(authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied));
    }
}

+ (void)creationRequestWithData:(NSData *)data options:(nullable PHAssetResourceCreationOptions *)options completionHandler:(void (^)(BOOL, NSError * _Nullable))handler {
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    [library performChanges:^{
        [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
    } completionHandler:handler];
}


@end

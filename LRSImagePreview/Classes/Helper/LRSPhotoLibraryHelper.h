//
//  LRSPhotoLibraryHelper.h
//  LRSPhotoLibraryHelper
//
//  Created by sama 刘 on 2021/8/13.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRSPhotoLibraryHelper : NSObject

+ (void)requestLibraryAuthorization:(void(^)(PHAuthorizationStatus status, BOOL enable))handler;

+ (void)creationRequestWithData:(NSData *)data options:(nullable PHAssetResourceCreationOptions *)options completionHandler:(void (^)(BOOL, NSError * _Nullable))handler;

@end

NS_ASSUME_NONNULL_END

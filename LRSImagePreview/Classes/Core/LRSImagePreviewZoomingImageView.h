//
//  LRSImagePreviewZoomingImageView.h
//  LRSImagePreview
//
//  Created by 刘sama on 08/13/2021.
//  Copyright (c) 2021 刘sama. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class LRSImagePreviewModel;
@class SDAnimatedImageView;
@interface LRSImagePreviewZoomingImageView : UIView

/// 初始化方法
/// @param frame frame
/// @param configure configure
+ (instancetype)zoomingViewWithFrame:(CGRect)frame configure:(LRSImagePreviewModel *)configure;

@property (nonatomic, readonly) BOOL isViewing;
@property (nonatomic, readonly) NSData *data;
@property (nonatomic, strong) SDAnimatedImageView *imageView;
@property (nonatomic, strong, readonly) LRSImagePreviewModel *model;

@end
NS_ASSUME_NONNULL_END

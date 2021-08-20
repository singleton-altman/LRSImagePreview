//
//  LRSImagePreviewer.h
//  LRSImagePreview
//
//  Created by 刘sama on 08/13/2021.
//  Copyright (c) 2021 刘sama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRSImagePreviewModel.h"

NS_ASSUME_NONNULL_BEGIN
@class LRSImagePreviewer;

@protocol LRSImageViewerDelegate <NSObject>

@optional
- (void)imageViewer:(LRSImagePreviewer *)imageViewer willDismissWithSelectedView:(__kindof UIView *)selectedView;
- (void)imageViewer:(LRSImagePreviewer *)imageViewer didDismissWithSelectedView:(__kindof UIView *)selectedView;
- (void)imageViewer:(LRSImagePreviewer *)imageViewer didChangeToImageView:(__kindof UIView *)selectedView;
- (void)imageViewer:(LRSImagePreviewer *)imageViewer didChangeToIndex:(NSInteger)selectedIndex;

@end

@protocol LRSImageViewerToastDelegate <NSObject>

@optional
- (void)imageViewer:(LRSImagePreviewer *)imageViewer errorMessage:(NSString *)message;
- (void)imageViewer:(LRSImagePreviewer *)imageViewer successMessage:(NSString *)message;
- (void)imageViewerLoading:(LRSImagePreviewer *)imageViewer;

@end

@interface LRSImagePreviewer : UIView

/// delegate
@property (nonatomic, weak) id<LRSImageViewerDelegate> delegate;

@property (nonatomic, weak) id<LRSImageViewerToastDelegate> toastDelegate;

/// 背景缩放, 需要配合`disableTouchDismiss`使用
/// 默认0.95
@property (nonatomic, assign) CGFloat backgroundScale;

/// 是否允许点击回收,
/// 默认true
@property (nonatomic, assign) BOOL disableTouchDismiss;

/// 控制保存按钮是否显示
/// 默认true
@property (nonatomic, assign) BOOL isSaveButtonShow;

/// 是否显示当前页数
/// 默认false
@property (nonatomic, assign) BOOL isShowNumberLabel;

/// 是否允许背景动画缩放
/// 默认false
@property (nonatomic) BOOL needWindowAnimation;


/// 初始化方法, 默认frame: UIApplication.sharedApplication.delegate.window.bounds
/// @param delegate delegate
/// @param toastDelegate toastDelegate
+ (instancetype)previewWithDelegate:(nullable id<LRSImageViewerDelegate>)delegate
                      toastDelegate:(nullable id<LRSImageViewerToastDelegate>)toastDelegate;

/// 展示
/// @param configures configures
/// @param index 当前第几页
/// @param fromReact 用于做展示/回收动画的初始 react
- (void)showImageViewWithConfigures:(NSArray<LRSImagePreviewModel *> *)configures
                      selectedIndex:(NSInteger)index
                          fromReact:(CGRect)fromReact;

/// 插入顶部
/// @param configures configures
- (void)insertImageViewWithConfigures:(NSArray <LRSImagePreviewModel *>*)configures;

/// 插入尾部
/// @param configures configures
- (void)addImageViewWithConfigures:(NSArray <LRSImagePreviewModel *>*)configures;

@end
NS_ASSUME_NONNULL_END

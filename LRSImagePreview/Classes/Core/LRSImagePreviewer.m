//
//  LRSImagePreviewer.m
//  LRSImagePreview
//
//  Created by 刘sama on 08/13/2021.
//  Copyright (c) 2021 刘sama. All rights reserved.
//

#import "LRSImagePreviewer.h"
#import "LRSImagePreviewZoomingImageView.h"
#import <SDWebImage/SDAnimatedImageView.h>
#import <SDWebImage/UIImage+MultiFormat.h>
#import <LRSImagePreview/LRSPhotoLibraryHelper.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface LRSImagePreviewer () <UIScrollViewDelegate> {
    CGRect fromReact_;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<LRSImagePreviewZoomingImageView *> *zoomingViews;
@property (nonatomic, readonly, assign)BOOL dismissing;

@property (nonatomic, strong) UIButton *saveImageButton;
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation LRSImagePreviewer

CGFloat image_previewer_screen_width(void) {
    return UIApplication.sharedApplication.delegate.window.bounds.size.width;
}

CGFloat image_previewer_screen_height(void) {
    return UIApplication.sharedApplication.delegate.window.bounds.size.height;
}

+ (instancetype)previewWithDelegate:(id<LRSImageViewerDelegate>)delegate toastDelegate:(id<LRSImageViewerToastDelegate>)toastDelegate {
    LRSImagePreviewer *previewer = [[LRSImagePreviewer alloc] initWithFrame:UIApplication.sharedApplication.delegate.window.bounds];
    previewer.delegate = delegate;
    previewer.toastDelegate = toastDelegate;
    return previewer;
}

- (id)init {
    self = [self initWithFrame:UIApplication.sharedApplication.delegate.window.bounds];
    if (self) {
        [self _setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:UIApplication.sharedApplication.delegate.window.bounds];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    self.backgroundColor = [UIColor blackColor];
    self.backgroundScale = 0.95;
    self.isSaveButtonShow = true;
    CGRect scrollViewFrame = self.bounds;
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:1];
        _scrollView.alpha = 0;
        _scrollView.delegate = self;
    }
    
    [self insertSubview:_scrollView atIndex:0];
    [self addSubview:self.numberLabel];
    [self addSubview:self.saveImageButton];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(tappedScrollView:)];
    [self.scrollView addGestureRecognizer:gesture];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)showImageViewWithConfigures:(NSArray<LRSImagePreviewModel *> *)configures selectedIndex:(NSInteger)index fromReact:(CGRect)fromReact {
    for (LRSImagePreviewZoomingImageView *view in self.zoomingViews) {
        [view removeFromSuperview];
    }
    LRSImagePreviewModel *model = configures[index];
    __weak typeof(self) weakSelf = self;
    /// animatingView
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    CGRect convertReact = [window convertRect:fromReact toView:self];
    CGPoint convertCenter = CGPointMake(convertReact.origin.x + 0.5 * convertReact.size.width, convertReact.origin.y + 0.5 * convertReact.size.height);
    CGSize size = CGSizeZero;
    if (model.placeholderImage) {
        size = model.placeholderImage.size;
        CGFloat ratio = MIN(fromReact.size.width / size.width, fromReact.size.height / size.height);
        CGFloat W = ratio * size.width;
        CGFloat H = ratio * size.height;
        size = CGSizeMake(W, H);
    } else {
        size = CGSizeMake(200, 200);
    }
    fromReact_ = CGRectMake(convertCenter.x - 0.5 * size.width, convertCenter.y - 0.5 * size.height, size.width, size.height);
    SDAnimatedImageView *animatedView = [[SDAnimatedImageView alloc] initWithFrame:fromReact_];
    [animatedView sd_setImageWithURL:model.hightURL placeholderImage:model.placeholderImage];
    [self addSubview:animatedView];
    [self animationSelectedView:animatedView completion:^(BOOL finished) {
        [weakSelf handleIndexLabel_];
        NSArray<LRSImagePreviewZoomingImageView *> *layoutViews = [weakSelf relayoutSubviewsWithConfigures_:configures fromX:0];
        weakSelf.zoomingViews = [NSMutableArray arrayWithArray:layoutViews];
        weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.zoomingViews.count * image_previewer_screen_width(), self.scrollView.contentSize.height);
        weakSelf.scrollView.contentOffset = CGPointMake(index * image_previewer_screen_width(), 0);
        [animatedView removeFromSuperview];
    }];
}

- (void)insertImageViewWithConfigures:(NSArray<LRSImagePreviewModel *> *)configures {
    NSArray<LRSImagePreviewZoomingImageView *> *layoutViews = [self relayoutSubviewsWithConfigures_:configures fromX:0];
    for (LRSImagePreviewZoomingImageView *view in self.zoomingViews) {
        CGRect frame = view.frame;
        frame.origin.x += configures.count * image_previewer_screen_width();
        view.frame = frame;
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange: NSMakeRange(0, configures.count)];
    [self.zoomingViews insertObjects:layoutViews atIndexes:indexSet];
    
    self.scrollView.contentSize = CGSizeMake(self.zoomingViews.count * image_previewer_screen_width(), self.scrollView.contentSize.height);
    
    CGFloat insertWidth = layoutViews.count * image_previewer_screen_width();
    self.scrollView.contentOffset = CGPointMake(insertWidth, 0);
    
    [self handleIndexLabel_];
}

- (void)addImageViewWithConfigures:(NSArray<LRSImagePreviewModel *> *)configures {
    NSArray<LRSImagePreviewZoomingImageView *> *layoutViews = [self relayoutSubviewsWithConfigures_:configures fromX:self.zoomingViews.count * image_previewer_screen_width()];
    [self.zoomingViews addObjectsFromArray:layoutViews];
    
    self.scrollView.contentSize = CGSizeMake(configures.count * image_previewer_screen_width(), self.scrollView.contentSize.height);
    
    [self handleIndexLabel_];
}

- (void)handleIndexLabel_ {
    if (_isShowNumberLabel) {
        NSInteger index = self.scrollView.contentOffset.x / image_previewer_screen_width();
        self.numberLabel.text = [NSString stringWithFormat:@"%zd/%zd", index + 1, self.zoomingViews.count];
    }
}

- (NSArray<LRSImagePreviewZoomingImageView *> *)relayoutSubviewsWithConfigures_:(NSArray<LRSImagePreviewModel *> *)models fromX:(CGFloat)x{
    NSMutableArray *subviews = [NSMutableArray arrayWithCapacity:models.count];
    for (LRSImagePreviewModel *configures in models) {
        NSInteger index = [models indexOfObject:configures];
        LRSImagePreviewZoomingImageView *tmp = [LRSImagePreviewZoomingImageView zoomingViewWithFrame:
                                                CGRectMake(index * image_previewer_screen_width() + x,
                                                           0,
                                                           image_previewer_screen_width(),
                                                           image_previewer_screen_height()) configure:configures];
        [self.scrollView addSubview:tmp];
        [subviews addObject:tmp];
    }
    return subviews;
}

- (NSData *)currentImageData_ {
    return [self currentView].data;
}

#pragma mark - Properties

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[backgroundColor colorWithAlphaComponent:0]];
}

- (NSInteger)pageIndex {
    return (_scrollView.contentOffset.x / _scrollView.frame.size.width);
}


#pragma mark - View management

- (nullable LRSImagePreviewZoomingImageView *)currentView {
    if ([self pageIndex] < self.zoomingViews.count) {
        return [self.zoomingViews objectAtIndex:self.pageIndex];
    }
    return nil;
}

- (void)animationSelectedView:(__kindof UIImageView *)selectedView completion:(void(^)(BOOL finished))animationCompletion {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [UIView animateWithDuration:0.3
                     animations:^{
        self.scrollView.alpha = 1;
        if (self.needWindowAnimation) {
            window.rootViewController.view.transform = CGAffineTransformMakeScale(self.backgroundScale, self.backgroundScale);
        }
        selectedView.transform = CGAffineTransformIdentity;
        
        CGSize size = (selectedView.image) ? selectedView.image.size
        : selectedView.frame.size;
        CGFloat ratio = MIN(image_previewer_screen_width() / size.width, image_previewer_screen_height() / size.height);
        CGFloat W = ratio * size.width;
        CGFloat H = ratio * size.height;
        selectedView.frame = CGRectMake((image_previewer_screen_width() - W) / 2, (image_previewer_screen_height() - H) / 2, W, H);
        selectedView.alpha = 1;
        self.saveImageButton.alpha = 1;
    } completion:animationCompletion];
}

- (void)prepareToDismiss {
    LRSImagePreviewZoomingImageView *currentView = [self currentView];
    
    if ([self.delegate respondsToSelector:@selector(imageViewer:willDismissWithSelectedView:)]) {
        [self.delegate imageViewer:self willDismissWithSelectedView:currentView];
    }
    self.saveImageButton.hidden = YES;
    self.numberLabel.hidden = YES;
}

- (void)dismissWithAnimate {
    
    if(self.dismissing){
        return;
    }
    
    _dismissing = YES;
    
    SDAnimatedImageView *currentView = [self currentView].imageView;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rct = currentView.frame;
    currentView.transform = CGAffineTransformIdentity;
    currentView.frame = [window convertRect:rct fromView:currentView.superview];
    [window addSubview:currentView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.alpha = 0;
        if (self.needWindowAnimation) {
            window.rootViewController.view.transform = CGAffineTransformIdentity;
        }
        CGRect rect = [window convertRect:self->fromReact_ toView:self];
        currentView.frame = CGRectMake(rect.origin.x, rect.origin.y, self->fromReact_.size.width, self->fromReact_.size.height);
        currentView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            for (LRSImagePreviewZoomingImageView *view in self.zoomingViews) {
                [view removeFromSuperview];
            }
            if ([self.delegate
                 respondsToSelector:@selector(imageViewer:didDismissWithSelectedView:)]) {
                [self.delegate imageViewer:self
                didDismissWithSelectedView:currentView];
            }
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Gesture events

- (void)tappedScrollView:(UITapGestureRecognizer *)sender {
    if (self.disableTouchDismiss) {
        return;
    }
    [self prepareToDismiss];
    [self dismissWithAnimate];
}

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)sender {
    if (self.disableTouchDismiss || self.dismissing) {
        return;
    }
    static LRSImagePreviewZoomingImageView *currentView = nil;
    if (sender.state == UIGestureRecognizerStateBegan) {
        currentView = [self currentView];
        if (currentView.isViewing) {
            currentView = nil;
        } else {
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            currentView.frame = [window convertRect:currentView.frame fromView:currentView.superview];
            [window addSubview:currentView];
            [self prepareToDismiss];
        }
    }
    
    if (currentView) {
        if (sender.state == UIGestureRecognizerStateEnded) {
            if (_scrollView.alpha > 0.5) {
                [self showImageViewWithConfigures:[self.zoomingViews mutableArrayValueForKeyPath:@"model"] selectedIndex:[self pageIndex] fromReact:self->fromReact_];
            } else {
                [self dismissWithAnimate];
            }
            currentView = nil;
        } else {
            CGPoint p = [sender translationInView:self];
            
            CGAffineTransform transform = CGAffineTransformMakeTranslation(p.x, p.y);
            CGFloat value = 1 - (MAX(fabs(p.x), fabs(p.y))) / 1000;
            transform = CGAffineTransformScale(transform, value,
                                               value);
            currentView.transform = transform;
            
            CGFloat r = 1 - fabs(p.y) / 200;
            _scrollView.alpha = MAX(0, MIN(1, r));
        }
    }
}

- (UIButton *)saveImageButton {
    if (!_saveImageButton) {
        _saveImageButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _saveImageButton.frame = CGRectMake(image_previewer_screen_width() - 45 - 15, image_previewer_screen_height() - 30 - 15 - self.safeAreaInsets.bottom, 45, 30);
        [_saveImageButton setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.3]];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"保存" attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:13],
            NSForegroundColorAttributeName: [UIColor blackColor]
        }];
        [_saveImageButton setAttributedTitle:title forState:(UIControlStateNormal)];
        _saveImageButton.layer.cornerRadius = 3.0f;
        _saveImageButton.layer.masksToBounds = YES;
        [_saveImageButton addTarget:self action:@selector(savePhoto) forControlEvents:(UIControlEventTouchUpInside)];
        _saveImageButton.hidden = true;
    }
    return _saveImageButton;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        self.numberLabel = [UILabel new];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.frame = CGRectMake(0, 20, image_previewer_screen_width(), 44);
        _numberLabel.hidden = true;
    }
    return _numberLabel;
}
// 保存图片到相册
- (void)savePhoto {
    NSData *imageData = [self currentImageData_];
    if (!imageData) {
        [self toast:@"图片尚未加载完成, 请稍候..."];
        return;
    }
    [LRSPhotoLibraryHelper requestLibraryAuthorization:^(PHAuthorizationStatus status, BOOL enable) {
        if (!enable) {
            [self toast:@"保存到相册失败"];
        } else {
            [self loading];
            [LRSPhotoLibraryHelper creationRequestWithData:imageData options:nil completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    [self toast:@"成功保存到相册" status:true];
                } else {
                    [self toast:error.localizedDescription];
                }
            }];
        }
    }];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self handleIndexLabel_];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(imageViewer:didChangeToImageView:)]) {
        [self.delegate imageViewer:self didChangeToImageView:[self currentView]];
    }
    
    if ([self.delegate respondsToSelector:@selector(imageViewer:didChangeToIndex:)]) {
        [self.delegate imageViewer:self didChangeToIndex:self.pageIndex];
    }
}

- (void)toast:(nullable NSString *)message status:(BOOL)success {
    if (self.toastDelegate) {
        if (success && [self.toastDelegate respondsToSelector:@selector(imageViewer:successMessage:)]) {
            [self.toastDelegate imageViewer:self successMessage:message];
        }
        if (!success && [self.toastDelegate respondsToSelector:@selector(imageViewer:errorMessage:)]) {
            [self.toastDelegate imageViewer:self errorMessage:message];
        }
    }
}

- (void)toast:(nullable NSString *)message {
    [self toast:message status:false];
}

- (void)loading {
    if (self.toastDelegate && [self.toastDelegate respondsToSelector:@selector(imageViewerLoading:)]) {
        [self.toastDelegate imageViewerLoading:self];
    }
}

- (NSMutableArray<LRSImagePreviewZoomingImageView *> *)zoomingViews {
    if (!_zoomingViews) {
        _zoomingViews = [NSMutableArray arrayWithCapacity:0];
    }
    return _zoomingViews;
}
@end

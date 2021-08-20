//
//  LRSImagePreviewZoomingImageView.m
//  LRSImagePreview
//
//  Created by 刘sama on 08/13/2021.
//  Copyright (c) 2021 刘sama. All rights reserved.
//

#import "LRSImagePreviewZoomingImageView.h"
#import "LRSImagePreviewModel.h"
#import <SDWebImage/SDAnimatedImageView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+MultiFormat.h>

@interface LRSImagePreviewZoomingImageView () <UIScrollViewDelegate>
@property (nonatomic, readwrite, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong, readwrite) LRSImagePreviewModel *model;
@end

@implementation LRSImagePreviewZoomingImageView

+ (instancetype)zoomingViewWithFrame:(CGRect)frame configure:(LRSImagePreviewModel *)configure{
    LRSImagePreviewZoomingImageView *view = [[LRSImagePreviewZoomingImageView alloc] initWithFrame:(frame)];
    view.model = configure;
    CGSize size = CGSizeZero;
    if (configure.placeholderImage) {
        size = configure.placeholderImage.size;
    } else {
        size = CGSizeMake(200, 200);
    }
    [view resizeSubviewsWithImageSize:size];
    [view.scrollView addSubview:view.containerView];
    [view.containerView addSubview:view.imageView];
    view.imageView.image = configure.placeholderImage;
    if (configure.hightURL) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(frame.size.width / 2 + frame.origin.x, frame.size.height / 2 + frame.origin.y, 40, 40)];
        indicator.hidesWhenStopped = true;
        [view.imageView addSubview:indicator];
        [indicator startAnimating];
        [[SDWebImageManager sharedManager] loadImageWithURL:configure.hightURL options:(SDWebImageHighPriority | SDWebImageDelayPlaceholder) progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (finished && image) {
                view.imageView.image = image;
                [view resizeSubviewsWithImageSize:image.size];
            }
            [indicator stopAnimating];
        }];
    }
    return view;
}

- (void)resizeSubviewsWithImageSize:(CGSize)size {
    CGFloat ratio = MIN(self.bounds.size.width / size.width, self.bounds.size.height / size.height);
    CGFloat W = ratio * size.width;
    CGFloat H = ratio * size.height;
    CGRect imageFrame = CGRectMake((self.bounds.size.width - W) / 2, (self.bounds.size.height - H) / 2, W, H);
    self.containerView.frame = imageFrame;
    self.imageView.frame = CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height);
}

- (void)_setup {
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.scrollView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _setup];
    }
    return self;
}

#pragma mark- Properties
- (BOOL)isViewing {
    return (_scrollView.zoomScale != _scrollView.minimumZoomScale);
}

#pragma mark- Scrollview delegate

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _containerView;
}

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_scrollView.frame.size.width > _scrollView.contentSize.width) ? ((_scrollView.frame.size.width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.frame.size.height > _scrollView.contentSize.height) ? ((_scrollView.frame.size.height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.containerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.zoomScale = 1;
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 2;
    }
    return _scrollView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (SDAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[SDAnimatedImageView alloc] init];
    }
    return _imageView;
}

- (NSData *)data {
    return self.imageView.image.sd_imageData;
}
@end

//
//  UIImage+LRSImagePreview.h
//  LRSImagePreview
//
//  Created by sama 刘 on 2021/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LRSImagePreview)
+ (UIImage *)lrs_preview_imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)lrs_preview_imageWithColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END

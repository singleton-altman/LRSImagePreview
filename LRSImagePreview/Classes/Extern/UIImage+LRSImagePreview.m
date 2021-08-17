//
//  UIImage+LRSImagePreview.m
//  LRSImagePreview
//
//  Created by sama 刘 on 2021/8/13.
//

#import "UIImage+LRSImagePreview.h"

@implementation UIImage (LRSImagePreview)
+ (UIImage *)lrs_preview_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(1, 1);
    }
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)lrs_preview_imageWithColor:(UIColor *)color {
    return [self lrs_preview_imageWithColor:color size:CGSizeMake(1, 1)];
}
@end

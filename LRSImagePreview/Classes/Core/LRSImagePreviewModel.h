//
//  LRSImagePreviewAutoLayoutModel.h
//  LRSImagePreview
//
//  Created by 刘sama on 08/13/2021.
//  Copyright (c) 2021 刘sama. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface LRSImagePreviewModel : NSObject

@property (nonatomic, copy, nullable) NSURL *hightURL;
@property (nonatomic, copy, nullable) UIImage *placeholderImage;

@end
NS_ASSUME_NONNULL_END

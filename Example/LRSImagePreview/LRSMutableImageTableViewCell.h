//
//  LRSMutableImageTableViewCell.h
//  LRSMutableImageTableViewCell
//
//  Created by sama 刘 on 2021/8/17.
//  Copyright © 2021 刘sama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDAnimatedImageView.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRSMutableImageTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet SDAnimatedImageView *imageIns;
@end

NS_ASSUME_NONNULL_END

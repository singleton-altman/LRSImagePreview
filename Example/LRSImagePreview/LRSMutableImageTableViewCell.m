//
//  LRSMutableImageTableViewCell.m
//  LRSMutableImageTableViewCell
//
//  Created by sama 刘 on 2021/8/17.
//  Copyright © 2021 刘sama. All rights reserved.
//

#import "LRSMutableImageTableViewCell.h"

@interface LRSMutableImageTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;
@end

@implementation LRSMutableImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.left.constant = arc4random() % 50 + 10;
    // Initialization code
}

- (void)setImage:(UIImage *)image {
    self.imageIns.image = image;
    self.imageH.constant = image.size.height / image.size.width * 184;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

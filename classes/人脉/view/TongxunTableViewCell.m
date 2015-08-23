//
//  TongxunTableViewCell.m
//  时时投
//
//  Created by 熊良军 on 15/7/31.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "TongxunTableViewCell.h"

@implementation TongxunTableViewCell
- (void)layoutSubviews{
    [super layoutSubviews];
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = 4;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

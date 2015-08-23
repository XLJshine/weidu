//
//  TongXunTableViewCell2.m
//  时时投
//
//  Created by 熊良军 on 15/8/3.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "TongXunTableViewCell2.h"

@implementation TongXunTableViewCell2
- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(10, 10, 40, 40);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 4;
    self.textLabel.frame = CGRectMake(60, 22, 150, 16);
    self.textLabel.font = [UIFont systemFontOfSize:15.0];
    self.textLabel.textColor = [UIColor colorWithWhite:0.2196 alpha:1];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

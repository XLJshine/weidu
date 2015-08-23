//
//  JiFenTableViewCell.m
//  时时投
//
//  Created by h on 15/7/25.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "JiFenTableViewCell.h"

@implementation JiFenTableViewCell
- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

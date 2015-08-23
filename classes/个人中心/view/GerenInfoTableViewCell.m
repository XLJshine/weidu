//
//  GerenInfoTableViewCell.m
//  时时投
//
//  Created by 熊良军 on 15/7/27.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "GerenInfoTableViewCell.h"

@implementation GerenInfoTableViewCell
- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(10, 8, self.bounds.size.width - 50, 14);
    self.textLabel.font = [UIFont systemFontOfSize:11.0];
    self.textLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1];
    
    self.detailTextLabel.frame = CGRectMake(self.bounds.size.width - 200, 8, 190, 14);
    self.detailTextLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    self.detailTextLabel.font = [UIFont systemFontOfSize:11.0];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

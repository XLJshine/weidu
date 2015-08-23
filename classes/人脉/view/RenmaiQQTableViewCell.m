//
//  RenmaiQQTableViewCell.m
//  时时投
//
//  Created by 熊良军 on 15/7/29.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "RenmaiQQTableViewCell.h"

@implementation RenmaiQQTableViewCell
- (void)layoutSubviews{
    [super layoutSubviews];
    
}
- (void)addButton:(NSInteger)tag{
    _tianjiaButton = nil;
    _tianjiaButton = [[UIButton alloc]initWithFrame:CGRectMake(self.contentView.bounds.size.width - 50, 20, 45, 25)];
    _tianjiaButton.tag = tag;
    [_tianjiaButton setImage:[UIImage imageNamed:@"renmaitianjia@2x"] forState:UIControlStateNormal];
    [self.contentView addSubview:_tianjiaButton];
    [_tianjiaButton addTarget:self action:@selector(tianjiaButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)tianjiaButtonAction:(UIButton *)button{
    //NSLog(@"----%li",(long)button.tag);
    if ([_delegate respondsToSelector:@selector(QQtableViewCell:index:)]) {
        [_delegate QQtableViewCell:self  index:button.tag];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

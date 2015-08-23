//
//  RenmaiTuijianTableViewCell.m
//  时时投
//
//  Created by 熊良军 on 15/7/29.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "RenmaiTuijianTableViewCell.h"

@implementation RenmaiTuijianTableViewCell
- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
   
    
}
- (void)addButton:(NSInteger)tag{
    
    _tianjiaButton = nil;
    _tianjiaButton = [[UIButton alloc]initWithFrame:CGRectMake(_backgroundview.bounds.size.width - 35, 20, 25, 25)];
    _tianjiaButton.tag = tag;
    [_tianjiaButton setImage:[UIImage imageNamed:@"renmaijiajia@2x"] forState:UIControlStateNormal];
    [_backgroundview addSubview:_tianjiaButton];
    [_tianjiaButton addTarget:self action:@selector(tianjiaButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)tianjiaButtonAction:(UIButton *)button{
    //NSLog(@"----%li",(long)button.tag);
    if ([_delegate respondsToSelector:@selector(TuijiantableViewCell:index:)]) {
        [_delegate TuijiantableViewCell:self  index:button.tag];
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

//
//  DongTaiTableViewCell.m
//  时时投
//
//  Created by h on 15/8/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "DongTaiTableViewCell.h"

@implementation DongTaiTableViewCell

- (void)awakeFromNib {
    // Initialization code

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(DongTaiModel *)model{
    _model = model;
    _timeLabel.text = _model.timeStr;
    //NSLog(@"_model.xinxiLabelHeight==%f",_model.xinxiLabelHeight);
    //    _xinxiImageView.frame = CGRectMake(78,8,228, _model.xinxiImageViewHeight);
    //_xinxiLabel.frame = CGRectMake(85, 13, 221, _model.xinxiLabelHeight+700);
//    _xinxiLabel.text = _model.xinxiStr;
    //    _xinxiLabel.backgroundColor = [UIColor redColor];
    //[self addSubview:_xinxiLabel];
    //NSLog(@"_model.xinxiImageViewHeight==%f",_model.xinxiImageViewHeight);
    //    UILabel * xinxiLabel = [[UILabel alloc]initWithFrame:CGRectMake(83, 14, 222, _model.xinxiLabelHeight)];
    //    xinxiLabel.numberOfLines = 0;
    //    xinxiLabel.text = _model.xinxiStr;
    //    xinxiLabel.font = [UIFont systemFontOfSize:13];
    //    xinxiLabel.backgroundColor = [UIColor whiteColor];
    //    [self addSubview:xinxiLabel];
    
}

@end

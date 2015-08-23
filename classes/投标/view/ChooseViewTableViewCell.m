//
//  ChooseViewTableViewCell.m
//  时时投
//
//  Created by 熊良军 on 15/8/19.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "ChooseViewTableViewCell.h"

@implementation ChooseViewTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        
    }
    return self;
}

- (void)colorBool:(NSString *)colorBool  indexPath:(NSInteger)indexpath block:(blockCellSelect)block{
    [_cellButton removeFromSuperview];
    
    _cellButton = [[ChooseViewCellButton alloc]initWithFrame:CGRectMake(5, 0, 100, 33)];
    _cellButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_cellButton setTitleColor:[UIColor colorWithWhite:0.15 alpha:1] forState:UIControlStateNormal];
    [_cellButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    if ([colorBool isEqualToString:@"1"]) {
        _cellButton.selected = YES;
    }else{
        _cellButton.selected = NO;
    }
    [_cellButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_cellButton];
    _cellButton.tag = indexpath;
    
    _block = block;

}
- (void)buttonAction:(ChooseViewCellButton *)button1{
    button1.selected = !button1.selected;
    if (button1.selected == YES) {
        _block(1,button1.tag);
    }else{
        _block(0,button1.tag);
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

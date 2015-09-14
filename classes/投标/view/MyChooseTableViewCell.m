//
//  MyChooseTableViewCell.m
//  时时投
//
//  Created by 熊良军 on 15/9/5.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "MyChooseTableViewCell.h"

@implementation MyChooseTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,320 - 135, 33)];
        _view.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = _view;
        _deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(170, 0, 40, 33)];
        [self.contentView addSubview:_deleteButton];
        
        
    }
    return self;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

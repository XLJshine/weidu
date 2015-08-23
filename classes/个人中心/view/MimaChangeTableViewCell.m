//
//  MimaChangeTableViewCell.m
//  时时投
//
//  Created by 熊良军 on 15/8/17.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "MimaChangeTableViewCell.h"

@implementation MimaChangeTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title1  backgroundimage:(UIImage *)backgroundimage1{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self title:title1 backgroundimage:backgroundimage1];
    }
    return self;
}
- (void)title:(NSString *)title1  backgroundimage:(UIImage *)backgroundimage1{
    NSArray *subViewArr = self.contentView.subviews;
    for (UIView *view in subViewArr) {
        [view removeFromSuperview];
    }
    UIImageView *backgroundimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 20, 50)];
    backgroundimage.image = backgroundimage1;
    [self.contentView addSubview:backgroundimage];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 15, self.contentView.bounds.size.width - 40, 20)];
    _textField.delegate = self;
    _textField.placeholder = title1;
    _textField.textColor = [UIColor colorWithWhite:0.15 alpha:1];
    _textField.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_textField];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignFirstResponder];
    return YES;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(10, 0, self.bounds.size.width - 20, 50);
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

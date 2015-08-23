//
//  AddMoreTableViewCell.m
//  时时投
//
//  Created by 熊良军 on 15/7/27.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "AddMoreTableViewCell.h"

@implementation AddMoreTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self cellReuse];
    }
    return self;
}
- (void)cellReuse{
    NSArray *subViewArr = self.contentView.subviews;
    for (UIView *view in subViewArr) {
        [view removeFromSuperview];
    }
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width * 0.5 - 40, 5, 20, 20)];
    imageview.image = [UIImage imageNamed:@"jiaohao_geren@2x"];
    [self.contentView addSubview:imageview];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(imageview.frame.origin.x + 30, 8, 100, 14)];
    lable.font = [UIFont systemFontOfSize:11.0];
    lable.text = @"继续添加";
    lable.textAlignment = NSTextAlignmentLeft;
    lable.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    [self.contentView addSubview:lable];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     //Configure the view for the selected state
}

@end

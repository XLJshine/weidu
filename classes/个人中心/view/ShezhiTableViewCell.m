//
//  ShezhiTableViewCell.m
//  时时投
//
//  Created by 熊良军 on 15/7/23.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "ShezhiTableViewCell.h"
#define seplineColor  [UIColor colorWithWhite:0.8745 alpha:1]
@implementation ShezhiTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  image:(UIImage *)image title:(NSString *)title1  backgroundimage:(UIImage *)backgroundimage1{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self image:image title:title1 backgroundimage:backgroundimage1];
    }
    return self;
}
- (void)image:(UIImage *)image title:(NSString *)title1  backgroundimage:(UIImage *)backgroundimage1{
    NSArray *subViewArr = self.contentView.subviews;
    for (UIView *view in subViewArr) {
        [view removeFromSuperview];
    }
    UIImageView *backgroundimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 20, 50)];
    backgroundimage.image = backgroundimage1;
    [self.contentView addSubview:backgroundimage];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 17, 16, 16)];
    imageView.image = image;
    [self.contentView addSubview:imageView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(imageView.bounds.size.width + 25, 15, 100, 20)];
    title.text = title1;
    title.textColor = [UIColor colorWithWhite:0.15 alpha:1];
    title.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:title];
    
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

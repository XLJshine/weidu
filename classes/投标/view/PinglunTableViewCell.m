//
//  PinglunTableViewCell.m
//  时时投
//
//  Created by 熊良军 on 15/8/13.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "PinglunTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation PinglunTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier userImage:(NSString *)imgUrl username:(NSString *)userName content:(NSMutableAttributedString *)content time:(NSString *)time buttonBlock:(BlockButtonAction)block{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _childArray = [NSMutableArray array];
      }
    return self;

}

- (void)userImage:(NSString *)imgUrl username:(NSString *)userName content:(NSMutableAttributedString *)content time:(NSString *)time buttonBlock:(BlockButtonAction)block{
     _childArray = [NSMutableArray array];
    _block = block;
     [_userImageView removeFromSuperview];
     [_userNameLable removeFromSuperview];
     [_detailLable removeFromSuperview];
     [_timeLable removeFromSuperview];
     [_zanbtn removeFromSuperview];
    
    
    _zanbtn = [[ZanButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - 50 ,20, 50, 40)];
    [_zanbtn addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_zanbtn];
    
    _userImageView = [[UIImageView alloc]init];
    _userImageView.frame = CGRectMake(10, 12, 37, 37);
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.cornerRadius = 4;
    [_userImageView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:placeImage];
    [self.contentView addSubview:_userImageView];
    
    _userNameLable = [[UILabel alloc]initWithFrame:CGRectMake(_userImageView.frame.origin.x + _userImageView.bounds.size.width + 10, _userImageView.frame.origin.y, 150, 10)];
    _userNameLable.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    _userNameLable.font = [UIFont systemFontOfSize:12];
    _userNameLable.text = userName;
    [self.contentView addSubview:_userNameLable];
    
    _detailLable = [[UILabel alloc]init];
    _detailLable.textColor = [UIColor colorWithWhite:0.15 alpha:1];
    _detailLable.font = [UIFont systemFontOfSize:14];
    _detailLable.numberOfLines = 0;
    NSString *content1 = [content string];
    CGSize size = [content1 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake( self.bounds.size.width - _userNameLable.frame.origin.x - 10, MAXFLOAT)];
    _detailLable.frame = CGRectMake(_userNameLable.frame.origin.x, _userNameLable.frame.origin.y + _userNameLable.bounds.size.height + 10, self.bounds.size.width - _userNameLable.frame.origin.x - 50, size.height);
    _detailLable.attributedText = content;
   [self.contentView addSubview:_detailLable];
   
    _addOneLable = [[UILabel alloc]initWithFrame:CGRectMake(_zanbtn.frame.origin.x + 25, _zanbtn.frame.origin.y, 30, 15)];
    _addOneLable.text = @"+1";
    _addOneLable.textColor = [UIColor colorWithRed:0.2667 green:0.6941 blue:0.9059 alpha:1];
    _addOneLable.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_addOneLable];
    _addOneLable.alpha = 0;
    
    _timeLable = [[UILabel alloc]init];
    _timeLable.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    _timeLable.font = [UIFont systemFontOfSize:12.0];
    _timeLable.frame = CGRectMake(_detailLable.frame.origin.x, _detailLable.frame.origin.y + _detailLable.bounds.size.height + 10, 100, 10);
    _timeLable.text = time;
    [self.contentView addSubview:_timeLable];
 
}
- (void)zanAction:(ZanButton *)btn{
    _block(btn.tag);
}
- (void)hideAddOneLable{
    [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(hideAddOneLable1) userInfo:nil repeats:NO];
}
- (void)hideAddOneLable1{
    [UIView animateWithDuration:1.5 animations:^{_addOneLable.alpha = 0;} completion:nil];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

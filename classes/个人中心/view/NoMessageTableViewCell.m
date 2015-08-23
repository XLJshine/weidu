//
//  NoMessageTableViewCell.m
//  时时投
//
//  Created by 熊良军 on 15/7/24.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "NoMessageTableViewCell.h"

@implementation NoMessageTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title1  detail:(NSString *)detail backgroundimage:(UIImage *)backgroundimage1 indexRow:(int)indexNum  messageNum:(NSString *)messageNum{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self title:title1 detail:detail backgroundimage:backgroundimage1 indexRow:indexNum  messageNum:messageNum];
    }
    return self;
}
- (void)title:(NSString *)title1 detail:(NSString *)detail backgroundimage:(UIImage *)backgroundimage1 indexRow:(int)indexNum  messageNum:(NSString *)messageNum{
    NSArray *subViewArr = self.contentView.subviews;
    for (UIView *view in subViewArr) {
        [view removeFromSuperview];
    }
    //_indexNum = indexNum;
    //_messageNum = messageNum;
    UIImageView *backgroundimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 20, 50)];
    backgroundimage.image = backgroundimage1;
    [self.contentView addSubview:backgroundimage];
    
    _title = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 150, 20)];
    _title.text = title1;
    _title.textColor = [UIColor colorWithWhite:0.15 alpha:1];
    _title.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_title];
    
    _detailtitle = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width * 0.5, 15, self.bounds.size.width * 0.5 - 30, 20)];
    _detailtitle.textAlignment = NSTextAlignmentRight;
    _detailtitle.text = detail;
    _detailtitle.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    _detailtitle.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_detailtitle];
    
    
    if ([messageNum isEqualToString:@"1"]) {
        self.chooseImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width - 48, 18, 14, 14)];
        [self.chooseImage1 setImage:[UIImage imageNamed:@"greengou@2x"]];
        [self.contentView addSubview:self.chooseImage1];
        [self.contentView bringSubviewToFront:self.chooseImage1];
        
    }
  
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(10, 0, self.bounds.size.width - 20, 50);
    self.contentView.backgroundColor = [UIColor clearColor];
}
- (void)awakeFromNib {
    // Initialization code
}

/*- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected == YES) {
         self.chooseImage.hidden = NO;
         [self.contentView bringSubviewToFront:self.chooseImage];
        if (_indexNum == 0&&_messageNum == 2) {
            self.chooseImage1.hidden = YES;
            
        }else if (_indexNum == 1&&_messageNum == 1){
             self.chooseImage1.hidden = YES;
        
        }else if(_indexNum == 2&&_messageNum == 0){
             self.chooseImage1.hidden = YES;
        }
    }else{
         self.chooseImage.hidden = YES;
    }
    
  
    // Configure the view for the selected state
}
*/
@end

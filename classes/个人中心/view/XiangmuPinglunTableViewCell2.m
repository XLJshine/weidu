//
//  XiangmuPinglunTableViewCell2.m
//  时时投
//
//  Created by 熊良军 on 15/8/8.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "XiangmuPinglunTableViewCell2.h"

@implementation XiangmuPinglunTableViewCell2
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  fromName:(NSString *)name1 toName:(NSString *)name2 content:(NSString *)content{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSString *text = [NSString stringWithFormat:@"%@回复%@：%@",name1,name2,content];
        _textLable = [[LableXLJ alloc]initWithFrame:CGRectMake(45, 5, 260, 10) text:text textColor:[UIColor blackColor] font:11 numberOfLines:0 lineSpace:5];
        NSInteger lengthName = name1.length;
        NSInteger lengthName2 = name2.length;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.3922 green:0.7333 blue:0.9098 alpha:1] range:NSMakeRange(0,lengthName)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.3922 green:0.7333 blue:0.9098 alpha:1] range:NSMakeRange(lengthName + 2,lengthName2)];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5];
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
        [_textLable setAttributedText:str];
        [_textLable sizeToFit];
        //_textLable.attributedText = str;
        
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 20, _textLable.bounds.size.height + 10)];
        view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1];
        [self addSubview:view];
        
        [self addSubview:_textLable];
    }
    return self;
    
}
- (void)fromName:(NSString *)name1 toName:(NSString *)name2 content:(NSString *)content{
    NSString *text = [NSString stringWithFormat:@"%@回复%@：%@",name1,name2,content];
    _textLable.frame = CGRectMake(45, 5, 260, 10);
    NSInteger lengthName = name1.length;
     NSInteger lengthName2 = name2.length;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.3922 green:0.7333 blue:0.9098 alpha:1] range:NSMakeRange(0,lengthName)];
     [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.3922 green:0.7333 blue:0.9098 alpha:1] range:NSMakeRange(lengthName + 2,lengthName2)];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
    [_textLable setAttributedText:str];
    [_textLable sizeToFit];
    //_textLable.attributedText = str;
    
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 20, _textLable.bounds.size.height + 10)];
    view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1];
    [self addSubview:view];
    
    [self addSubview:_textLable];

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

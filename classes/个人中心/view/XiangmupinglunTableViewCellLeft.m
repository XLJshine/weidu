//
//  XiangmupinglunTableViewCell.m
//  时时投
//
//  Created by 熊良军 on 15/8/8.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "XiangmupinglunTableViewCellLeft.h"

@implementation XiangmupinglunTableViewCellLeft
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  fromName:(NSString *)name1 content:(NSString *)content{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //文字中不同颜色设置
        /*NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:detail];
         [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
         [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
         [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
         [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:13.0] range:NSMakeRange(0, 5)];
         [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0] range:NSMakeRange(6, 12)];
         [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:13.0] range:NSMakeRange(19, 6)];
         _detail.attributedText = str;*/
        NSString *text = [NSString stringWithFormat:@"%@：%@",name1,content];
        _textLable = [[LableXLJ alloc]initWithFrame:CGRectMake(45, 5, 260, 10) text:text textColor:[UIColor blackColor] font:11 numberOfLines:0 lineSpace:5];
        NSInteger lengthName = name1.length;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.3922 green:0.7333 blue:0.9098 alpha:1] range:NSMakeRange(0,lengthName)];
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
- (void)fromName:(NSString *)name1 content:(NSString *)content{
    NSString *text = [NSString stringWithFormat:@"%@：%@",name1,content];
    _textLable.frame = CGRectMake(45, 5, 260, 10);
    NSInteger lengthName = name1.length;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.3922 green:0.7333 blue:0.9098 alpha:1] range:NSMakeRange(0,lengthName)];
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

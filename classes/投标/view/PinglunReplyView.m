//
//  PinglunReplyView.m
//  时时投
//
//  Created by 熊良军 on 15/9/8.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "PinglunReplyView.h"

@implementation PinglunReplyView
- (instancetype)initWithFrame:(CGRect)frame firstName:(NSString *)firstName secondName:(NSString *)secondName content:(NSString *)content{
    self = [super initWithFrame:frame];
    if (self) {
        UIFont *font  = [UIFont systemFontOfSize:13];
        CGSize size = [firstName sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 12)];
        UIButton *firstButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, size.width, 12)];
        firstButton.titleLabel.font = font;
        [firstButton setTitleColor:[UIColor colorWithRed:0.2078 green:0.5804 blue:0.9804 alpha:1] forState:UIControlStateNormal];
        [firstButton setTitle:firstName forState:UIControlStateNormal];
        [firstButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        firstButton.tag = 0;
        [self addSubview:firstButton];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(firstButton.frame.origin.x + firstButton.bounds.size.width, firstButton.frame.origin.y,28, 12)];
        lable.font = font;
        lable.text = @"回复";
        lable.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [self addSubview:lable];
        
        CGSize size2 = [secondName sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 12)];
        UIButton *secondButton = [[UIButton alloc]initWithFrame:CGRectMake(lable.frame.origin.x + lable.bounds.size.width, 0, size2.width, 12)];
         secondButton.titleLabel.font = font;
        [secondButton setTitleColor:[UIColor colorWithRed:0.2078 green:0.5804 blue:0.9804 alpha:1] forState:UIControlStateNormal];
        [secondButton setTitle:[NSString stringWithFormat:@"%@",secondName] forState:UIControlStateNormal];
         [secondButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        secondButton.tag = 1;
        [self addSubview:secondButton];
        
        UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(secondButton.frame.origin.x + secondButton.bounds.size.width, secondButton.frame.origin.y, 5, 12)];
        lable2.text = @"：";
        lable2.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [self addSubview:lable2];
        
        CGSize size3 = [content sizeWithFont:font constrainedToSize:CGSizeMake(250, MAXFLOAT)];
        UILabel *contentLable = [[UILabel alloc]initWithFrame:CGRectMake(0, lable2.frame.origin.y + lable2.bounds.size.height, 250, size3.height)];
        contentLable.text = content;
        contentLable.font = font;
        contentLable.numberOfLines = 0;
        contentLable.textColor = [UIColor colorWithWhite:0.15 alpha:1];
        [self addSubview:contentLable];
        
        
        contentLable.userInteractionEnabled = YES;
        contentLable.tag = 2;
       [contentLable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectaction1:)]];
        
        
    }
    return self;
}
- (void)selectAction:(UIButton *)button{
    if ([_delegate respondsToSelector:@selector(pinglunReplyView:buttonAtIndex:)]) {
        [_delegate pinglunReplyView:self buttonAtIndex:button.tag];
    }
}
- (void)selectaction1:(UITapGestureRecognizer *)tap{
    if ([_delegate respondsToSelector:@selector(pinglunReplyView:buttonAtIndex:)]) {
        [_delegate pinglunReplyView:self buttonAtIndex:tap.view.tag];
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

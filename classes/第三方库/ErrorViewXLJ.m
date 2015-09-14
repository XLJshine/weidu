//
//  ErrorViewXLJ.m
//  时时投
//
//  Created by 熊良军 on 15/9/5.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "ErrorViewXLJ.h"

@implementation ErrorViewXLJ
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //_block = block;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"error_view_img"];
        [self addSubview:imageView];
        
        UIButton *reloadButton = [[UIButton alloc]initWithFrame:CGRectMake(93, self.bounds.size.height * 0.85, 32, 15)];
        reloadButton.tag = 0;
        [reloadButton setTitleColor:[UIColor colorWithRed:0.4196 green:0.7451 blue:0.9137 alpha:1] forState:UIControlStateNormal];
        [reloadButton setTitleColor:[UIColor colorWithRed:0.1451 green:0.5412 blue:0.9804 alpha:1] forState:UIControlStateHighlighted];
        [reloadButton setTitle:@"刷新" forState:UIControlStateNormal];
        reloadButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [reloadButton addTarget:self action:@selector(errorAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:reloadButton];
        
        UIButton *returnButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - 93 - 32, self.bounds.size.height * 0.85, 32, 15)];
        returnButton.tag = 1;
        [returnButton setTitleColor:[UIColor colorWithRed:0.4196 green:0.7451 blue:0.9137 alpha:1] forState:UIControlStateNormal];
        [returnButton setTitleColor:[UIColor colorWithRed:0.1451 green:0.5412 blue:0.9804 alpha:1] forState:UIControlStateHighlighted];
        [returnButton addTarget:self action:@selector(errorAction:)  forControlEvents:UIControlEventTouchUpInside];
        [returnButton setTitle:@"返回" forState:UIControlStateNormal];
        returnButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:returnButton];
    }
    return self;
}

- (void)errorAction:(UIButton *)button{
    if ([_delegate respondsToSelector:@selector(errorView:buttonAtIndex:)]) {
        [_delegate errorView:self buttonAtIndex:button.tag];
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

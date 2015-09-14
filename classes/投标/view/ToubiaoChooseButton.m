//
//  ToubiaoChooseButton.m
//  dayang
//
//  Created by 熊良军 on 15/7/21.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "ToubiaoChooseButton.h"

@implementation ToubiaoChooseButton
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor colorWithWhite:0.2275 alpha:1] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setImage:[UIImage imageNamed:@"shaixuan1@2x"] forState:UIControlStateSelected];
         [self setImage:[UIImage imageNamed:@"shaixuan2@2x"] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat x = self.bounds.size.width*0.8;
    CGFloat y = 14;
    CGFloat w = 12;
    CGFloat h = 12;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat x = 3;
    CGFloat y = 13;
    CGFloat w = self.bounds.size.width * 0.8;
    CGFloat h = 14;
    return CGRectMake(x, y, w, h);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

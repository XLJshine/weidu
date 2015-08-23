//
//  XiangmuPinglinButton.m
//  时时投
//
//  Created by 熊良军 on 15/8/8.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "XiangmuPinglinButton.h"

@implementation XiangmuPinglinButton
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        
    }
    return self;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.bounds.size.height;
    CGFloat h = self.bounds.size.height;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat x = self.bounds.size.height + 4;
    CGFloat y = 0;
    CGFloat w = self.bounds.size.width - (self.bounds.size.height + 4);
    CGFloat h = self.bounds.size.height;
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

//
//  ShareButton.m
//  乐邦美食
//
//  Created by jimmy on 15/6/16.
//  Copyright (c) 2015年 jimmy. All rights reserved.
//

#import "ShareButton.h"

@implementation ShareButton
- (id)initWithFrame:(CGRect)frame  image:(UIImage *)image title:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = self.imageView.bounds.size.width * 0.5;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font  = [UIFont systemFontOfSize:14.0];
        [self setTitleColor:[UIColor colorWithRed:0.5765 green:0.5765 blue:0.5765 alpha:1] forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
    }
    return self;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat x =  self.bounds.size.width * 0.3;
    CGFloat y =  self.bounds.size.height * 0.2;
    CGFloat w = self.bounds.size.width * 0.4;
    CGFloat h = w;
    return CGRectMake(x, y, w, h);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat x =  0;
    CGFloat y =  self.bounds.size.height * 0.7;
    CGFloat w = self.bounds.size.width;
    CGFloat h = 15;
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

//
//  RemaiButton.m
//  时时投
//
//  Created by 熊良军 on 15/7/20.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "RemaiButton.h"

@implementation RemaiButton
- (id)initWithFrame:(CGRect)frame normalimage:(UIImage *)normalimage hImage:(UIImage *)hImage SImage:(UIImage *)SImage{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:normalimage forState:UIControlStateNormal];
        [self setImage:hImage forState:UIControlStateHighlighted];
        [self setImage:SImage forState:UIControlStateSelected];
    }
    return self;
}
//重写hightlight方法来覆盖原有效果,点击按钮时,按钮会直接选中
- (void)setHighlighted:(BOOL)highlighted
{
    
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat x = 20 + 27;
    CGFloat y = 10;
    CGFloat w = 20;
    CGFloat h = 20;
    return CGRectMake(x, y, w, h);
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat x = 47 + 27;
    CGFloat y = 12;
    CGFloat w = 45;
    CGFloat h = 16;
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

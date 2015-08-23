//
//  YoukeButton.m
//  dayang
//
//  Created by 熊良军 on 15/7/21.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "YoukeButton.h"

@implementation YoukeButton
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat x = self.bounds.size.width * 0.5 + 26;
    CGFloat y = 9;
    CGFloat w =  12;
    CGFloat h = 12;
    
    return CGRectMake(x, y, w, h);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat x = self.bounds.size.width * 0.5 - 40;
    CGFloat y = 10;
    CGFloat w =  65;
    CGFloat h = 10;
    
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

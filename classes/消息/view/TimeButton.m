//
//  TimeButton.m
//  时时投
//
//  Created by 熊良军 on 15/8/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "TimeButton.h"

@implementation TimeButton
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w =  12;
    CGFloat h = 12;
    
    return CGRectMake(x, y, w, h);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat x = 15;
    CGFloat y = 0;
    CGFloat w =  self.bounds.size.width - 15;
    CGFloat h = 12;
    
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

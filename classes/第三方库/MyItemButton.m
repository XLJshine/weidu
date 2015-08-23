//
//  MyItemButton.m
//  时时投
//
//  Created by 熊良军 on 15/8/6.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "MyItemButton.h"

@implementation MyItemButton
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat x = contentRect.size.width * 0.2;
    CGFloat y = contentRect.size.width * 0.2;
    CGFloat w =  contentRect.size.width * 0.6;
    CGFloat h = contentRect.size.width * 0.6;
    
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

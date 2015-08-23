//
//  DockItem.m
//  Created by xionglj on 14-10-10.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//  一个选项卡标签

#import "DockItem.h"
#define kTitleRatio 0.3
@implementation DockItem
#pragma mark 调整内部ImageView的frame
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        //self.titleLabel.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:[UIColor colorWithWhite:0.3333 alpha:1] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:0.2902 green:0.6980 blue:0.8980 alpha:1] forState:UIControlStateSelected];
        //图片居中
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        //设置DockItem的背景图片
        //[self setBackgroundImage:[UIImage imageNamed:@"tabbar_slider.png"] forState:UIControlStateSelected];
        //self.imageView.backgroundColor = [UIColor whiteColor];
        //[self setBackgroundImage:[UIImage imageNamed:@"图标颜色.jpg"] forState:UIControlStateSelected];
    }
    return self;
}
//重写hightlight方法来覆盖原有效果,点击按钮时,按钮会直接选中
- (void)setHighlighted:(BOOL)highlighted
{
    
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = contentRect.size.width*(0.35);
    CGFloat imageheight = contentRect.size.height *(0.63)* (1 - kTitleRatio) + 2;
    CGFloat imageY = 7;
    CGFloat imageWidth = contentRect.size.width*(0.3);
    return CGRectMake(imageX, imageY, imageWidth, imageheight);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleHeight = contentRect.size.height * kTitleRatio;
    CGFloat titleY = contentRect.size.height - titleHeight - 2;
    CGFloat titleWidth = contentRect.size.width;
    
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}
@end

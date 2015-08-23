//
//  ChooseViewCellButton.m
//  时时投
//
//  Created by 熊良军 on 15/8/19.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "ChooseViewCellButton.h"

@implementation ChooseViewCellButton
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return self;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return contentRect;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

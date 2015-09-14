//
//  InterNetError.m
//  时时投
//
//  Created by 熊良军 on 15/9/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "InterNetError.h"

@implementation InterNetError
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 15)];
        title.text = @"网络不佳，请重试！";
        title.font = [UIFont systemFontOfSize:14.0];
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
        _timeNum = 0;
        [UIView animateWithDuration:2 animations:^{self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];} completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removeNetErrorView) userInfo:nil repeats:NO];
    }
    return self;
}
- (void)removeNetErrorView{
//    if (_timeNum == 1) {
//       
//    }
//    _timeNum ++;
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

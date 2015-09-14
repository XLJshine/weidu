//
//  LoadingViewXLJ.m
//  时时投
//
//  Created by 熊良军 on 15/9/2.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "LoadingViewXLJ.h"

@implementation LoadingViewXLJ
- (instancetype)initWithFrame:(CGRect)frame  title:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        //loadingView = [[UIView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 200)*0.5, (self.view.bounds.size.height - 150)*0.5, 200,150)];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        
        UILabel *lableloding = [[UILabel alloc]initWithFrame:CGRectMake(0, 27, self.bounds.size.width, 15)];
        lableloding.backgroundColor = [UIColor clearColor];
        lableloding.textAlignment = NSTextAlignmentCenter;
        lableloding.text = title;
        //@"正在加载，请稍后。。。"
        lableloding.textColor = [UIColor whiteColor];
        lableloding.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:lableloding];
        UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        aiv.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height/ 2.0f + 15);
        [self addSubview:aiv];
        [aiv startAnimating];
        
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

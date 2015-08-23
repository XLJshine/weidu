//
//  ShareView.m
//  乐邦美食
//
//  Created by jimmy on 15/6/16.
//  Copyright (c) 2015年 jimmy. All rights reserved.
//

#import "ShareView.h"
#import "ShareButton.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
@implementation ShareView
- (id)initWithFrame:(CGRect)frame  buttonBlock:(BlockButton)block{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.block = block;
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake((self.bounds.size.width - 70)*0.5, 10, 70, 20)];
        [self addSubview:headView];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 14, 14)];
        imageview.image = [UIImage imageNamed:@"share_bt"];
        [headView addSubview:imageview];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, headView.bounds.size.width - imageview.bounds.size.width, 20)];
        lable.text = @"分享到";
        lable.font = [UIFont systemFontOfSize:14.0];
        lable.textColor = [UIColor colorWithRed:0.5804 green:0.5804 blue:0.5804 alpha:1];
        lable.backgroundColor = [UIColor clearColor];
        [headView addSubview:lable];
        
        NSArray *imageArray = [NSArray arrayWithObjects:@"shareqqkongjian_1",@"shareqq.png_1",@"shareweixin_1",@"shareqqweibo_1",@"sharepengyouquan_1", nil];
        NSArray *titleArray = [NSArray arrayWithObjects:@"QQ空间",@"QQ好友",@"微信好友",@"微博",@"朋友圈", nil];
        for (int i = 0; i < 5; i ++) {
            int x = i%3;
            int y = i/3;
            if (i < 3) {
                ShareButton * shareBtn = [[ShareButton alloc]initWithFrame:CGRectMake(self.bounds.size.width*0.333*x, 40 + 100*y, self.bounds.size.width * 0.333, 100) image:[UIImage imageNamed:[imageArray objectAtIndex:i]] title:[titleArray objectAtIndex:i]];
                shareBtn.tag = i;
                [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:shareBtn];
            }else{
                ShareButton * shareBtn = [[ShareButton alloc]initWithFrame:CGRectMake(self.bounds.size.width*0.333*x + 50, 40 + 100*y, self.bounds.size.width * 0.333, 100) image:[UIImage imageNamed:[imageArray objectAtIndex:i]] title:[titleArray objectAtIndex:i]];
                shareBtn.tag = i;
                [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:shareBtn];
            
            
            }
           
                
            
        }
        
        
        
        UIView *sepline1 = [[UIView alloc]initWithFrame:CGRectMake(8, 40, self.bounds.size.width - 16, 0.5)];
        sepline1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [self addSubview:sepline1];
        UIView *sepline2 = [[UIView alloc]initWithFrame:CGRectMake(8, 140, self.bounds.size.width - 16, 0.5)];
        sepline2.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [self addSubview:sepline2];
    }
    return self;
}
- (void)shareAction:(ShareButton *)button{
     self.block(button.tag);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

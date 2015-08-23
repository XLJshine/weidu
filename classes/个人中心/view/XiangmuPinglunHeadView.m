//
//  XiangmuPinglunHeadView.m
//  时时投
//
//  Created by 熊良军 on 15/8/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "XiangmuPinglunHeadView.h"
#import "XiangmuPinglinButton.h"
@implementation XiangmuPinglunHeadView
- (instancetype)initWithFrame:(CGRect)frame  title:(NSString *)title detail:(NSString *)detail   block:(Buttonblock)block{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _detail = detail;
        
        _headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 145)];
        _headview.backgroundColor = [UIColor whiteColor];
        [self addSubview:_headview];
        
        _titleLable = [[LableXLJ alloc]initWithFrame:CGRectMake(10, 10, self.bounds.size.width - 20, 10) text:title textColor:[UIColor colorWithWhite:0.15 alpha:1] font:14 numberOfLines:0 lineSpace:3];
        [_headview addSubview:_titleLable];
        
        _detailLable = [[LableXLJ alloc]initWithFrame:CGRectMake(10, _titleLable.frame.origin.y + _titleLable.bounds.size.height + 5, self.bounds.size.width -20, 10) text:detail textColor:[UIColor colorWithWhite:0.3 alpha:1] font:11 numberOfLines:0 lineSpace:3];
        [_headview addSubview:_detailLable];
        
        _bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, _headview.bounds.size.height, self.bounds.size.width, 65)];
        _bottomview.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomview];
        
        UIButton *quanwenButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 40, 15)];
        [quanwenButton setTitle:@"全文" forState:UIControlStateNormal];
        quanwenButton.selected = NO;
        [quanwenButton setTitle:@"收起" forState:UIControlStateSelected];
        [quanwenButton setTitleColor:[UIColor colorWithRed:0.3922 green:0.7333 blue:0.9098 alpha:1] forState:UIControlStateNormal];
        quanwenButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [quanwenButton addTarget:self action:@selector(quanwenAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomview addSubview:quanwenButton];
        
        
        NSArray *array = [NSArray arrayWithObjects:[UIImage imageNamed:@"zhaobiaozan@2x"],[UIImage imageNamed:@"shareImg@2x"],[UIImage imageNamed:@"zhaobiaopinglun@2x"], nil];
        for (int i = 0; i< 3; i ++) {
            XiangmuPinglinButton *zaButton = [[XiangmuPinglinButton alloc]initWithFrame:CGRectMake(55 + 50*i, 25, 50, 15)];
            [zaButton setImage:[array objectAtIndex:i] forState:UIControlStateNormal];
            zaButton.selected = NO;
            zaButton.tag = i;
            [zaButton setTitle:@"41" forState:UIControlStateNormal];
            [zaButton addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomview addSubview:zaButton];
        }
        
        
         _y = _detailLable.bounds.size.height;
        CGFloat h;
        h = _y;
        _height = [NSString stringWithFormat:@"%f",_y];
         while ((_detailLable.frame.origin.y + _detailLable.bounds.size.height) > (_bottomview.frame.origin.y + _bottomview.bounds.size.height)) {
             h = 0.96*h;
             _detailLable.frame = CGRectMake(10, _titleLable.frame.origin.y + _titleLable.bounds.size.height + 10, self.bounds.size.width -20, h);
         }
            
            
        self.frame = CGRectMake(0, 0, self.bounds.size.width, _bottomview.frame.origin.y + _bottomview.bounds.size.height);
        
        _block = block;
        
        _block(100,self.frame);
    }
    return self;
}
- (void)quanwenAction:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected == YES) {
        [_detailLable text:_detail textColor:[UIColor colorWithWhite:0.3 alpha:1] font:11 numberOfLines:0 lineSpace:3];
        CGFloat y = _detailLable.bounds.size.height;
         _detailLable.frame = CGRectMake(10, _titleLable.frame.origin.y + _titleLable.bounds.size.height + 5, self.bounds.size.width -20, y);
        
        [UIView animateWithDuration:0.2 animations:^{  _headview.frame = CGRectMake(0, 0, self.bounds.size.width, _detailLable.frame.origin.y + _detailLable.bounds.size.height);
            _bottomview.frame = CGRectMake(0, _headview.bounds.size.height, self.bounds.size.width, 65);} completion:nil];
      
    }else{
       
        [UIView animateWithDuration:0.2 animations:^{     _headview.frame = CGRectMake(0, 0, self.bounds.size.width,145);
            _bottomview.frame = CGRectMake(0, _headview.bounds.size.height, self.bounds.size.width, 65);
            CGFloat h;
            h = [_height floatValue];
            while ((h + _detailLable.frame.origin.y) > (_bottomview.frame.origin.y + _bottomview.bounds.size.height)) {
                h = 0.96*h;
                _detailLable.frame = CGRectMake(10, _titleLable.frame.origin.y + _titleLable.bounds.size.height + 10, self.bounds.size.width -20, h);
            }
           } completion:nil];
   
    }
    [self bringSubviewToFront:_bottomview];
    self.frame = CGRectMake(0, 0, self.bounds.size.width, _bottomview.frame.origin.y + _bottomview.bounds.size.height);
    _block(100,self.frame);
}
- (void)zanAction:(XiangmuPinglinButton *)button{
    _block(button.tag,self.frame);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

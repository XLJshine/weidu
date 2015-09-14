//
//  DingyueView.m
//  时时投
//
//  Created by 熊良军 on 15/8/25.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "DingyueView.h"

@implementation DingyueView
- (instancetype)initWithFrame:(CGRect)frame  titleArray:(NSMutableArray *)titleArray idArray:(NSMutableArray *)idArray block:(BlockDingyueView)block{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
        _block = block;
        _titleArray = [NSMutableArray array];
        _idArray = [NSMutableArray array];
        _titleArray = titleArray;
        _idArray = idArray;
        _imageview = [[UIImageView alloc]initWithFrame:self.bounds];
        CGFloat top = 5; // 顶端盖高度
        CGFloat bottom = 5; // 底端盖高度
        CGFloat left = 10; // 左端盖宽度
        CGFloat right = 10; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 伸缩后重新赋值
        UIImage *image = [UIImage imageNamed:@"dingyueback@2x"];
        image = [image resizableImageWithCapInsets:insets];
        _imageview.image = image;
        [self addSubview:_imageview];
        
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 25)];
        titleLable.text = @"订阅项目";
        titleLable.textColor = [UIColor colorWithWhite:0.25 alpha:1];
        titleLable.font = [UIFont systemFontOfSize:15];
        [self addSubview:titleLable];
        
        UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(10, 33, self.bounds.size.width - 20, 0.5)];
        sepLine.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
        [self addSubview:sepLine];
        
        _Backgroudview = [[UIView alloc]initWithFrame:self.bounds];
        _Backgroudview.backgroundColor = [UIColor clearColor];
        [self addSubview:_Backgroudview];
        for (int i = 0; i < titleArray.count; i++) {
            int x = i%3;  //0、1、2
            int y = i/3;   //0、0、0
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10 + ((self.bounds.size.width - 40)*0.333 + 10)*x, 40 + 30*y, (self.bounds.size.width - 40)*0.333, 25)];
           [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
           [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           button.tag = i;
           [button setBackgroundImage:[UIImage imageNamed:@"dingyueButton@2x"] forState:UIControlStateNormal];
           button.titleLabel.font = [UIFont systemFontOfSize:12.0];
           [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
           [_Backgroudview addSubview:button];
        }
        int num = (int)_titleArray.count/3;
        
        _height = 30 * num + 55;
    }
    return self;
}

- (void)frame:(CGRect)frame  titleArray:(NSMutableArray *)titleArray idArray:(NSMutableArray *)idArray{
    self.frame = frame;
    _titleArray = [NSMutableArray array];
    _idArray = [NSMutableArray array];
    [_titleArray addObjectsFromArray:titleArray];
    [_idArray addObjectsFromArray:idArray];
    NSArray *subViewArr = _Backgroudview.subviews;
    for (UIView *view in subViewArr) {
        [view removeFromSuperview];
    }
    
    _Backgroudview.frame =  self.bounds;
    [_imageview removeFromSuperview];
    _imageview = [[UIImageView alloc]initWithFrame:self.bounds];
    CGFloat top = 5; // 顶端盖高度
    CGFloat bottom = 5; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 伸缩后重新赋值
    UIImage *image = [UIImage imageNamed:@"dingyueback@2x"];
    image = [image resizableImageWithCapInsets:insets];
    _imageview.image = image;
    [self addSubview:_imageview];
    
    [self addSubview:_Backgroudview];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 25)];
    titleLable.text = @"订阅项目";
    titleLable.textColor = [UIColor colorWithWhite:0.25 alpha:1];
    titleLable.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLable];
    
    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(10, 33, self.bounds.size.width - 20, 0.5)];
    sepLine.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
    [self addSubview:sepLine];
    NSLog(@"_Backgroudview.frame = %f",_Backgroudview.frame.size.height);
    NSLog(@"_titleArray = %@",_titleArray);
     NSLog(@"titleArray = %@",titleArray);
    for (int i = 0; i < _titleArray.count; i++) {
        int x = i%3;  //0、1、2
        int y = i/3;   //0、0、0
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10 + ((self.bounds.size.width - 40)*0.333 + 10)*x, 40 + 30*y, (self.bounds.size.width - 40)*0.333, 25)];
        [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.tag = i;
        [button setBackgroundImage:[UIImage imageNamed:@"dingyueButton@2x"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_Backgroudview addSubview:button];
    }
    
}

- (void)buttonAction:(UIButton *)button{
    NSLog(@"button.tag = %li",(long)button.tag);
    _block(button.tag);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

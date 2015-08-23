//
//  BiaoqianView.m
//  时时投
//
//  Created by 熊良军 on 15/7/25.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "BiaoqianView.h"

@implementation BiaoqianView
- (id)initWithFrame:(CGRect)frame title:(NSString *)title btnTitle:(NSString *)btnTitle viewtag:(int)viewtag BlockButton:(BlockButton) block{
    self = [super initWithFrame:frame];
    if (self) {
        _controlNum = 0;
        
        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width - self.bounds.size.height, self.bounds.size.height)];
        leftLable.backgroundColor = [UIColor colorWithRed:0.2667 green:0.5882 blue:0.8549 alpha:1];
        leftLable.text = title;
        leftLable.textColor = [UIColor whiteColor];
        leftLable.font = [UIFont systemFontOfSize:12];
        leftLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:leftLable];
        
        _numButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - self.bounds.size.height, 0, self.bounds.size.height, self.bounds.size.height)];
        [_numButton setBackgroundColor:[UIColor colorWithRed:0.5373 green:0.7765 blue:0.9255 alpha:1]];
        [_numButton setTitle:btnTitle forState:UIControlStateNormal];
        [_numButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _numButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_numButton addTarget:self action:@selector(numAdd:) forControlEvents:UIControlEventTouchUpInside];
        _numButton.tag = viewtag;
        [self addSubview:_numButton];
        
        _block = block;
    }
    return self;
}
- (void)numAdd:(UIButton *)button{
    if (_controlNum == 0) {
        NSString *numStr = button.titleLabel.text;
        int num = [numStr intValue];
        num = num + 1;
        [button setTitle:[NSString stringWithFormat:@"%i",num] forState:UIControlStateNormal];
        _controlNum ++;
    }
   _block((int)button.tag,button.titleLabel.text);

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  Dock.m
//  Created by xionglj on 14-10-10.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "Dock.h"

@implementation Dock
{
    DockItem *_selectedItem;
}
@synthesize delegate = _delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //dock背景填充颜色
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dibu1@2x"]];
        //self.backgroundColor = [UIColor whiteColor];
//        UIView *sepline = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.bounds.size.width, 1)];
//        sepline.backgroundColor = [UIColor grayColor];
//        [self addSubview:sepline];
    }
    return self;
}
#pragma mark 添加
- (void)addItemWithIcon:(NSString *)icon1  selectIcon:(NSString *)sIcon  title:(NSString *)title;
{
     DockItem *item = [[DockItem alloc]init];
    [item setTitle:title forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:icon1] forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:sIcon] forState:UIControlStateSelected];
    [item addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:item];
    
    //调整所有item的位置
    
   [UIView beginAnimations:nil context:nil];//动画
    
    int count = (int)self.subviews.count;
    
    //设置默认选中
    if (count == 1) {
       [self change:item];
    }
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width/count;
    
    for (int i = 0; i < count; i ++) {
        DockItem *dockItem = [self.subviews  objectAtIndex:i];
        dockItem.tag = i;
        dockItem.frame = CGRectMake(width * i, 0, width, height);
        if (i == 5) {
            DockItem *dockItem = [self.subviews  objectAtIndex:i];
            dockItem.tag = i;
            dockItem.frame = CGRectMake(width * i, 0, width, height);
            [dockItem setBackgroundImage:[UIImage imageNamed:@"down_img"] forState:UIControlStateNormal];
            [dockItem setBackgroundImage:[UIImage imageNamed:@"down_img"] forState:UIControlStateSelected];
            [dockItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [dockItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
        }else{
            DockItem *dockItem = [self.subviews  objectAtIndex:i];
            dockItem.tag = i;
            dockItem.frame = CGRectMake(width * i, 0, width, height);
        }
    }
    [UIView commitAnimations];
}

- (void)change:(DockItem *)item
{
    //0.通知代理
    if ([_delegate respondsToSelector:@selector(dock:itemSelectedFrom:to:)]) {
        [_delegate dock:self itemSelectedFrom:(int)_selectedItem.tag to:(int)item.tag];
    }
    //1.取消选中当前选中的item
    _selectedItem.selected = NO;
    //2.选中点击的item
    item.selected = YES;
    //3.赋值
    _selectedItem = item;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

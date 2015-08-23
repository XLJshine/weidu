//
//  XiangmuPinglunHeadView.h
//  时时投
//
//  Created by 熊良军 on 15/8/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LableXLJ.h"
typedef void(^Buttonblock)(NSInteger,CGRect);
@interface XiangmuPinglunHeadView : UIView
@property(nonatomic,strong) UIView *headview ;
@property(nonatomic,strong) UIView *bottomview ;
@property(nonatomic,strong) LableXLJ *titleLable;
@property(nonatomic,strong) LableXLJ *detailLable;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *detail;
@property(nonatomic,strong) __block Buttonblock block;
@property(nonatomic,assign) CGFloat y;
@property(nonatomic,strong) NSString *height;
- (instancetype)initWithFrame:(CGRect)frame  title:(NSString *)title detail:(NSString *)detail  block:(Buttonblock)block;
@end

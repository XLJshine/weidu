//
//  MyDingyueView.h
//  时时投
//
//  Created by 熊良军 on 15/8/25.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BlockMyDingyueView)(NSInteger);
@interface MyDingyueView : UIView
@property (nonatomic ,strong)__block BlockMyDingyueView  block;
@property (nonatomic ,strong)NSMutableArray *titleArray;
@property (nonatomic ,strong)NSMutableArray *idArray;
@property (nonatomic ,assign)NSInteger height;
@property (nonatomic ,strong)UIView *Backgroudview;
@property (nonatomic ,strong)UIImageView *imageview;
- (instancetype)initWithFrame:(CGRect)frame  titleArray:(NSMutableArray *)titleArray  block:(BlockMyDingyueView)block;
- (void)frame:(CGRect)frame  titleArray:(NSMutableArray *)titleArray; //刷新数据
@end

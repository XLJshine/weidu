//
//  BiaoqianView.h
//  时时投
//
//  Created by 熊良军 on 15/7/25.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BlockButton)(int,NSString *);
@interface BiaoqianView : UIView
@property (nonatomic ,strong)BlockButton  block;
@property (nonatomic ,strong)UIButton *numButton;
@property (nonatomic ,assign)int controlNum;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title btnTitle:(NSString *)btnTitle  viewtag:(int)viewtag BlockButton:(BlockButton) block;
@end

//
//  ToubiaoTableViewCell.h
//  时时投
//
//  Created by 熊良军 on 15/7/20.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LableXLJ.h"
#import "ZanButton.h"
typedef void(^BlockButtonAction)(NSInteger);
@interface ToubiaoTableViewCell : UITableViewCell
@property (nonatomic ,strong)LableXLJ *title;
@property (nonatomic ,strong)UILabel *hangye;
@property (nonatomic ,strong)UILabel *location;
@property (nonatomic ,strong)UILabel *time;
@property (nonatomic ,strong)LableXLJ *detail;
@property (nonatomic ,strong)ZanButton *zanbtn;
@property (nonatomic ,strong)ZanButton *liulanbtn;
@property (nonatomic ,strong)ZanButton *pinglunbtn;
@property (nonatomic ,strong)ZanButton *morebtn;
@property (nonatomic ,strong)__block  BlockButtonAction  block;
@property (nonatomic ,strong)UIView * tanChuangView;
@property (nonatomic ,assign)NSInteger number;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  title:(NSString *)title hangye:(NSString *)hangye location:(NSString *)location time:(NSString *)time detail:(NSString *)detail;
- (void)title:(NSString *)title hangye:(NSString *)hangye location:(NSString *)location time:(NSString *)time detail:(NSString *)detail;
- (void)blockButtonAction:(BlockButtonAction)block;
- (void)reloadview;
@end

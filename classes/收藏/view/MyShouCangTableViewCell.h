//
//  MyShouCangTableViewCell.h
//  时时投
//
//  Created by 熊良军 on 15/7/28.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "ShouCangTableViewCell.h"
#import "LableXLJ.h"
#import "ZanButton.h"
typedef void(^BlockButtonAction)(NSInteger,NSInteger);
@interface MyShouCangTableViewCell : ShouCangTableViewCell
@property (nonatomic ,strong)UILabel *title;
@property (nonatomic ,strong)UILabel *hangye;
@property (nonatomic ,strong)UILabel *location;
@property (nonatomic ,strong)UILabel *time;
@property (nonatomic ,strong)UILabel *detail;
@property (nonatomic ,strong)ZanButton *zanbtn;
@property (nonatomic ,strong)ZanButton *liulanbtn;
@property (nonatomic ,strong)ZanButton *pinglunbtn;
@property (nonatomic ,strong)ZanButton *morebtn;
@property (nonatomic ,strong)__block UILabel *addOneLable;
@property (nonatomic ,strong)UIView *  tanChuangView;
@property (nonatomic ,strong)__block  BlockButtonAction  block;
- (void)hideAddOneLable;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  title:(NSString *)title hangye:(NSString *)hangye location:(NSString *)location time:(NSString *)time detail:(NSString *)detail   titleFont:(NSInteger)font1 lableFont:(NSInteger)font2 titleSepFont:(NSInteger)font4;
- (void)title:(NSString *)title hangye:(NSString *)hangye location:(NSString *)location time:(NSString *)time detail:(NSString *)detail   titleFont:(NSInteger)font1 lableFont:(NSInteger)font2 titleSepFont:(NSInteger)font4;
- (void)blockButtonAction:(BlockButtonAction)block;
@end

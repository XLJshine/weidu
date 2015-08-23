//
//  ChooseView_shaixuanView.h
//  时时投
//
//  Created by 熊良军 on 15/8/19.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaTableView.h"
#import "ChooseViewfirstTableView.h"
#import "ChooseViewsecondTableView.h"
@interface ChooseView_shaixuanView : UIView
@property (nonatomic ,strong)__block  ChooseViewfirstTableView  *firstTableView;
@property (nonatomic ,strong)__block AreaTableView * areaTableView;
@property (nonatomic ,strong)__block ChooseViewsecondTableView * secondTableView;
@property (strong, nonatomic)NSMutableDictionary *ArticleDic;  //初始化数据
@property (strong, nonatomic)NSDictionary *areaDic;  //地区数据
@property (strong, nonatomic)NSDictionary *hangyeDic;  //行业数据
@property (strong, nonatomic)NSDictionary *leibieDic;  //类别数据
@property (strong, nonatomic)NSDictionary *fenleiDic;  //分类数据
@end

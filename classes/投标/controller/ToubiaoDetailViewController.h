//
//  ToubiaoDetailViewController.h
//  时时投
//
//  Created by 熊良军 on 15/8/12.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToubiaoDetailViewController : UIViewController
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;
@property (nonatomic ,strong)NSString *toubiaoID;
@property (nonatomic ,strong)NSString *time;
@property (nonatomic ,strong)NSString *ifShowPinglun;
@property (nonatomic ,strong)NSString *ifFromToubiao;

@property (assign, nonatomic)NSInteger titleFont;    //标题字号
@property (assign, nonatomic)NSInteger lableFont;    //标签字号
@property (assign, nonatomic)NSInteger detailFont;      //内容字号
@property (assign, nonatomic)NSInteger titleSepFont;    //标题间距
@property (assign, nonatomic)NSInteger detailSepFont;      //内容间距
@end

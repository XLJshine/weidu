//
//  ShareViewController.h
//  乐邦美食
//
//  Created by jimmy on 15/6/16.
//  Copyright (c) 2015年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
@interface ShareViewController : UIViewController
@property (nonatomic ,strong)NSDictionary *shareDic;
@property (nonatomic ,strong)NSString *type;       //类型
@property (nonatomic ,strong)NSString *urlStr;     //图片链接
@property (nonatomic ,strong)NSString *content;    //内容
@property (nonatomic ,strong)NSString *imageUrl;   //图片链接
@property (nonatomic ,strong)NSString *mytitle;   //标题
@property (nonatomic ,strong)NSString * defaultContent;  //默认内容

@end

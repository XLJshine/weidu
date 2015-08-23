//
//  XiaoXiViewController.h
//  dayang
//
//  Created by chendong on 15/7/20.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XiaoXiViewController : UIViewController
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;
@property (nonatomic ,strong)NSString *ifModelNavigation;
+ (id)shareInstance;
@end

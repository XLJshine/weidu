//
//  ShouCangViewController.h
//  dayang
//
//  Created by chendong on 15/7/20.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShouCangViewController : UIViewController
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;
@property (nonatomic ,strong)NSString *ifModelNavigation;
//+ (id)shareInstance;
+ (id)shareInstanceWithToken:(NSString *)token uid:(NSString *)uid;
@end

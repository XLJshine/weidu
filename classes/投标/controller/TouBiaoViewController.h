//
//  TouBiaoViewController.h
//  dayang
//
//  Created by chendong on 15/7/20.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouBiaoViewController : UIViewController
@property (nonatomic ,strong)__block NSString  *token;
@property (nonatomic ,strong)NSString *uid;
@property (nonatomic ,strong)UIControl *grayView;
@property (nonatomic ,strong)NSString *ifModelNavigation;
+ (id)shareInstanceWithToken:(NSString *)token uid:(NSString *)uid;

@end

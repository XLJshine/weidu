//
//  AppDelegate.h
//  时时投
//
//  Created by 熊良军 on 15/8/3.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRSideViewController.h"
#import "WXApi.h"
#import "WeiboSDK.h"
@class MainViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainViewController *viewController;
@property(strong,nonatomic)YRSideViewController *siderViewController;
@end


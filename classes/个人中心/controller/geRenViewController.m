//
//  geRenViewController.m
//  时时投
//
//  Created by h on 15/8/6.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "geRenViewController.h"
#import "ShezhiViewController.h"
#import "UIImageView+MJWebCache.h"
#import "FangkeViewController.h"
#import "JiFenViewController.h"
#import "GerenInfo_My_ViewController.h"
#import "GongsiViewController.h"
#import "LoginViewController.h"
#import "MyNavigationController.h"
@interface geRenViewController ()

@end

@implementation geRenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人";
    _userImage.userInteractionEnabled = YES;
    [_userImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserImage:)]];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tapUserImage:(UITapGestureRecognizer *)tap{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"mycenter" userInfo:nil];
}
- (IBAction)dongTaiButton:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"dongtai" userInfo:nil];
    
}
- (IBAction)LoginOut:(id)sender {
    //登录模态视图
    LoginViewController *controller1 = [[LoginViewController alloc] init];
    MyNavigationController *controller = [[MyNavigationController alloc]initWithRootViewController:controller1];
    [controller.navigationBar setBarTintColor:[UIColor colorWithRed:0.2902 green:0.6980 blue:0.8980 alpha:1]];
    //controller.navigationBarHidden = YES;
    controller.navigationBar.translucent = NO;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        controller.providesPresentationContextTransitionStyle = YES;
        controller.definesPresentationContext = YES;
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:controller animated:NO completion:nil];
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }

}

- (IBAction)fangKeButton:(id)sender {
      [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"fangke" userInfo:nil];
}

- (IBAction)xiaoXiButton:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"xiaoxi" userInfo:nil];
}

- (IBAction)pingLunButton:(id)sender {
      [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"xiangmu" userInfo:nil];
}

- (IBAction)sheZhiButton:(id)sender {
    //设置
    [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"shezhi" userInfo:nil];
}
@end

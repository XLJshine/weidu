//
//  MyNavigationController.m
//  时时投
//
//  Created by 熊良军 on 15/7/28.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = YES; //隐藏底部标签栏
    //设置导航控制器中当前控制器通过push到下一个控制器的返回按钮内容
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toumingBackItem@2x"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [backButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"dingbu6@2x"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.visibleViewController.navigationItem.backBarButtonItem = backButtonItem;
    [super pushViewController:viewController animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end

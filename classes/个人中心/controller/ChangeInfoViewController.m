//
//  ChangeInfoViewController.m
//  时时投
//
//  Created by 熊良军 on 15/7/31.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "ChangeInfoViewController.h"

@interface ChangeInfoViewController ()

@end

@implementation ChangeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *sepLineview = [[UIView alloc]initWithFrame:CGRectMake(5, 62, self.view.bounds.size.width - 10, 1)];
    sepLineview.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    [self.view addSubview:sepLineview];
    
    
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

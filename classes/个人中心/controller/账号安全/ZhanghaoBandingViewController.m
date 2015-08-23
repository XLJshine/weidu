//
//  ZhanghaoBandingViewController.m
//  时时投
//
//  Created by h on 15/8/12.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "ZhanghaoBandingViewController.h"

@interface ZhanghaoBandingViewController ()

@end

@implementation ZhanghaoBandingViewController{

    NSInteger t;
    NSTimer*_myTimer;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"账号绑定";
        
        _zhangHaoTextField.delegate=self;
        
        
        /*UIButton *lestButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
         [lestButton setImage:[UIImage imageNamed:@"fanhuix@2x"] forState:UIControlStateNormal];
         [lestButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
         UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:lestButton];
         self.navigationItem.leftBarButtonItem = leftItem;*/
        
    }
    return self;
}


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)zhangHaoBanDingButton:(id)sender {
}

#pragma MARK-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end

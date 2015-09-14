//
//  YanZhengMaViewController.m
//  时时投
//
//  Created by h on 15/7/27.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "YanZhengMaViewController.h"
#import <SMS_SDK/SMS_SDK.h>
@interface YanZhengMaViewController ()<UITextFieldDelegate>

@end

@implementation YanZhengMaViewController{
  AFHTTPRequestOperationManager *manager;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"填写验证码";
        
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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"YanZhengMaViewController"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"YanZhengMaViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _textview.delegate = self;
    _theNewPhoneNum.text = [NSString stringWithFormat:@"+86 %@",_phoneNum];
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

- (IBAction)shouBuDaoYanZhengMaButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"重发验证码" message:@"确定重新发送验证码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (IBAction)tijiaoAction:(id)sender {
    [SMS_SDK commitVerifyCode:_yanzhenmaText.text result:^(enum SMS_ResponseState state) {
        if (state == 1) {
            NSLog(@"state = %i,验证通过",state);
            if (_yanzhenmaText.text.length > 0) {
                NSString *urlStr = [NSString stringWithFormat:@"%@account/bind-mobile?mobile=%@&access-token=%@",ApiUrlHead,_phoneNum,_token];
                NSLog(@"urlStr = %@",urlStr);
                manager = [AFHTTPRequestOperationManager manager];
                [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                    if ([code isEqualToString:@"0"]) {
                        NSDictionary * Data = [responseObject objectForKey:@"data"];
                        NSLog(@"Data = %@",Data);
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号更改成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }else if (![code isEqualToString:@"0"]){
                        NSString *error = [responseObject objectForKey:@"err"];
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    
                    
                }];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码错误或失效，请重新获取验证码" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }
    }];
}
@end

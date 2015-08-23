//
//  YouxiangBangdingViewController.m
//  时时投
//
//  Created by h on 15/8/8.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "YouxiangBangdingViewController.h"
#import <SMS_SDK/SMS_SDK.h>

@interface YouxiangBangdingViewController ()<UIAlertViewDelegate>

@end

@implementation YouxiangBangdingViewController{

    NSInteger t;
    NSTimer*_myTimer;
    AFHTTPRequestOperationManager *manager;
    NSString *_VerifyCode;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"邮箱绑定";
        
        /*UIButton *lestButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
         [lestButton setImage:[UIImage imageNamed:@"fanhuix@2x"] forState:UIControlStateNormal];
         [lestButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
         UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:lestButton];
         self.navigationItem.leftBarButtonItem = leftItem;*/
    
    }
    return self;
}


- (void)action{
    t --;
    if (t == 59) {
        if ([YouxiangBangdingViewController validateEmail:_YouXiangNumTextField.text]) {
            NSString *urlStr = [NSString stringWithFormat:@"%@account/bind-email-send-vcode?email=%@&access-token=%@",ApiUrlHead,_YouXiangNumTextField.text,_token];
            NSLog(@"urlStr = %@",urlStr);
            manager = [AFHTTPRequestOperationManager manager];
            [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                if ([code isEqualToString:@"0"]) {
                    NSDictionary * Data = [responseObject objectForKey:@"data"];
                    NSLog(@"Data = %@",Data);
                    
                }else if (![code isEqualToString:@"0"]){
                    NSString *error = [responseObject objectForKey:@"err"];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                
            }];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"邮箱格式不对！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
        
        
        }
       
    [_youXiangHuoQuButton setTitle:[NSString stringWithFormat:@"%lds",(long)t] forState:UIControlStateNormal];
    
    if (t <=0) {
        
        if ([_myTimer isValid]) {
            [_myTimer invalidate];
        }
        [_youXiangHuoQuButton setTitle:@"重发验证码" forState:UIControlStateNormal];
        _youXiangHuoQuButton.enabled=YES;
        [_youXiangHuoQuButton addTarget:self action:@selector(Chongfa) forControlEvents:UIControlEventTouchUpInside];
     }
}
-(void)Chongfa{
    // [_huoqueButton setTitle:@"重发验证码" forState:UIControlStateNormal];
    
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _YouXiangNumTextField.delegate=self;
    _yanzhenmaTextFeild.delegate=self;
    
    
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

- (IBAction)youXiangHuoQuButton:(id)sender {
    t = 60;
    _myTimer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(action) userInfo:nil repeats:YES];
    

}

- (IBAction)youxiangBangDingButton:(id)sender {
    if (_YouXiangNumTextField.text.length > 0&&_yanzhenmaTextFeild.text.length > 0) {
        NSString *urlStr = [NSString stringWithFormat:@"%@account/bind-email?email=%@&vcode=%@&access-token=%@",ApiUrlHead,_YouXiangNumTextField.text,_yanzhenmaTextFeild.text,_token];
        NSLog(@"urlStr = %@",urlStr);
        manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                //NSDictionary * Data = [responseObject objectForKey:@"data"];
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"绑定成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不能为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    
    }
   
    
    
}
//邮箱正则表达式
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma MARK-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -- 获取验证码

@end

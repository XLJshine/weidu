//
//  MailJieBang_ViewController.m
//  时时投
//
//  Created by 熊良军 on 15/8/18.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "MailJieBang_ViewController.h"

@interface MailJieBang_ViewController ()<UITextFieldDelegate>

@end

@implementation MailJieBang_ViewController{
    NSInteger t;
    NSTimer*_myTimer;
    AFHTTPRequestOperationManager *manager;
    NSInteger controlNum;   //控制，防止重复获取验证码

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MailJieBangViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)bangdingAction:(id)sender {
    if (_youxiangTextFeild.text.length > 0&&_yanzhengmaTextFeild.text.length > 0) {
        NSString *urlStr = [NSString stringWithFormat:@"%@account/bind-email?email=%@&vcode=%@&access-token=%@",ApiUrlHead,_youxiangTextFeild.text,_yanzhengmaTextFeild.text,_token];
        NSLog(@"urlStr = %@",urlStr);
        manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
      [MobClick endLogPageView:@"MailJieBangViewController"];
    //通知刷新我的个人中心
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyInfo" object:nil userInfo:nil];
    
}
- (void)action{
    t --;
    [_yanzhengmaButton setTitle:[NSString stringWithFormat:@"%lds",(long)t] forState:UIControlStateNormal];
    
    if (t <=0) {
        
        if ([_myTimer isValid]) {
            [_myTimer invalidate];
        }
        [_yanzhengmaButton setTitle:@"重发验证码" forState:UIControlStateNormal];
        _yanzhengmaButton.enabled=YES;
        
        controlNum = 0;
    }
    
}

- (IBAction)HuoquYanzhengma:(id)sender {
    if (controlNum == 0) {
       
        if ([MailJieBang_ViewController validateEmail:_youxiangTextFeild.text]) {
            NSString *urlStr = [NSString stringWithFormat:@"%@account/bind-email-send-vcode?email=%@&access-token=%@",ApiUrlHead,_youxiangTextFeild.text,_token];
            NSLog(@"urlStr = %@",urlStr);
            manager = [AFHTTPRequestOperationManager manager];
            [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                if ([code isEqualToString:@"0"]) {
                    NSDictionary * Data = [responseObject objectForKey:@"data"];
                    NSLog(@"Data = %@",Data);
                    
                    t = 60;
                    _myTimer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(action) userInfo:nil repeats:YES];
                    controlNum ++;
                    
                }else if (![code isEqualToString:@"0"]){
                    NSString *error = [responseObject objectForKey:@"err"];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    controlNum = 0;
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                controlNum = 0;
            
            }];
        }else{
            NSString *urlStr = [NSString stringWithFormat:@"%@account/bind-email-send-vcode?email=%@&access-token=%@",ApiUrlHead,_youxiangTextFeild.text,_token];
            NSLog(@"urlStr = %@",urlStr);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"邮箱格式不对！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            controlNum = 0;
        }
    }else{
        
        
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
@end

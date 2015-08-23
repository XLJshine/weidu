//
//  PhoneBangdingViewController.m
//  时时投
//
//  Created by h on 15/8/8.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "MailJiebangViewController.h"
#import <SMS_SDK/SMS_SDK.h>
@interface MailJiebangViewController ()

@end

@implementation MailJiebangViewController{
    NSInteger t;
    NSTimer*_myTimer;
    AFHTTPRequestOperationManager *manager;
    NSInteger controlNum;   //控制，防止重复获取验证码
    
    NSString* _str;
    
    
    NSMutableArray* _areaArray;
    NSString* _defaultCode;
    NSString* _defaultCountryName;
    NSString* _VerifyCode;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"邮箱解绑";
        

        
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
    [_PhoneHuoquButton setTitle:[NSString stringWithFormat:@"%lds",(long)t] forState:UIControlStateNormal];
    
    if (t <=0) {
        
        if ([_myTimer isValid]) {
            [_myTimer invalidate];
        }
        [_PhoneHuoquButton setTitle:@"重发验证码" forState:UIControlStateNormal];
        _PhoneHuoquButton.enabled=YES;
        [_PhoneHuoquButton addTarget:self action:@selector(Chongfa) forControlEvents:UIControlEventTouchUpInside];
        controlNum = 0;
        
        
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
    controlNum = 0 ;
    
    _PhoneNumTextFiled.delegate=self;
    _PhoneYanZhengMa.delegate=self;
    
    //_huoqueButton验证码的获取，时间倒计时
    [_PhoneHuoquButton addTarget:self action:@selector(Jishi) forControlEvents:UIControlEventTouchUpInside];
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

- (IBAction)PhoneHuoquButton:(id)sender {
    if (controlNum == 0) {
        t = 60;
        _myTimer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(action) userInfo:nil repeats:YES];
        controlNum ++;
        if ([MailJiebangViewController validateEmail:_PhoneNumTextFiled.text]) {
            NSString *urlStr = [NSString stringWithFormat:@"%@account/bind-email-send-vcode?email=%@&access-token=%@",ApiUrlHead,_PhoneNumTextFiled.text,_token];
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
                    controlNum = 0;
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                controlNum = 0;
                
            }];
        }else{
            NSString *urlStr = [NSString stringWithFormat:@"%@account/bind-email-send-vcode?email=%@&access-token=%@",ApiUrlHead,_PhoneNumTextFiled.text,_token];
            NSLog(@"urlStr = %@",urlStr);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"邮箱格式不对！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            controlNum = 0;
        }
    }else{
    
    
    }
    
}



- (IBAction)PhoneBandingButton:(id)sender {
    NSLog(@"解除邮箱绑定");
    
    
       
   
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


#pragma mark -- 获取验证码


@end

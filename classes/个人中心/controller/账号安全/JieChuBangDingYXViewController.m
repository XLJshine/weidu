//
//  JieChuBangDingYXViewController.m
//  时时投
//
//  Created by h on 15/9/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "JieChuBangDingYXViewController.h"

@interface JieChuBangDingYXViewController ()<UIAlertViewDelegate>

@end

@implementation JieChuBangDingYXViewController{
    AFHTTPRequestOperationManager *manager;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JieChuBangDingYXViewController"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JieChuBangDingYXViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"解除绑定";
    
    _yanzhengMaText.delegate=self;
    
    _youxiangJBLable.text = [NSString stringWithFormat:@"您当前邮箱:%@",_youxiangNum];

  
    // Do any additional setup after loading the view from its nib.
}
//点return处收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
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

- (IBAction)huoQuYZM:(id)sender {
    
if([JieChuBangDingYXViewController validateEmail:_youxiangNum]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@account/bind-email-send-vcode?email=%@&access-token=%@",ApiUrlHead,_youxiangNum,_token];
        NSLog(@"urlStr = %@",urlStr);
        manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSDictionary * Data = [responseObject objectForKey:@"data"];
                NSLog(@"Data = %@",Data);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码发送成功，请到邮箱激活" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                //_myTimer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(action) userInfo:nil repeats:YES];
                
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"邮箱格式不对！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
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

- (IBAction)jieChuBD:(id)sender {
    
    if (_yanzhengMaText.text.length > 0&&_yanzhengMaText.text.length > 0) {
        NSString *urlStr = [NSString stringWithFormat:@"%@account/un-bind?type=email&vcode=%@&access-token=%@",ApiUrlHead,_yanzhengMaText.text,_token];
        NSLog(@"urlStr = %@",urlStr);
        manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                //NSDictionary * Data = [responseObject objectForKey:@"data"];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"解绑成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            NSLog(@"urlStr==========================================%@",urlStr);
            
            
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不能为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    
    
}
@end

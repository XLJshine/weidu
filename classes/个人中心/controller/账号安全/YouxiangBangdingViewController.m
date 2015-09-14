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


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"YouxiangBangdingViewController"];
    //通知刷新我的个人中心
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyInfo" object:nil userInfo:nil];
    
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
                    //通知刷新我的个人中心
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyInfo" object:nil userInfo:nil];
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
    _youXiangHuoQuButton.titleLabel.text = [NSString stringWithFormat:@"%lds",(long)t];
    [_youXiangHuoQuButton setTitle:[NSString stringWithFormat:@"%lds",(long)t] forState:UIControlStateNormal];
    
    _youXiangHuoQuButton.userInteractionEnabled = NO;
    
   

    
    if (t <=0) {
        
        if ([_myTimer isValid]) {
            [_myTimer invalidate];
        }
        [_youXiangHuoQuButton setTitle:@"重发验证码" forState:UIControlStateNormal];
        [_youXiangHuoQuButton addTarget:self action:@selector(Chongfa) forControlEvents:UIControlEventTouchUpInside];
        _youXiangHuoQuButton.userInteractionEnabled = YES;
    }
}
-(void)Chongfa{
    // [_huoqueButton setTitle:@"重发验证码" forState:UIControlStateNormal];
    
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"YouxiangBangdingViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _YouXiangNumTextField.delegate=self;
    _yanzhenmaTextFeild.delegate=self;
    
    //判断是否显示密码输入框
    NSString*urlString=[NSString stringWithFormat:@"%@account/is-set-pwd?access-token=%@",ApiUrlHead,_token];
    NSLog(@"urlString = %@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]];
        if ([code isEqualToString:@"1"]) {
            //设置过密码了
           _quedingBDbtn.frame = CGRectMake(10, 176, self.view.bounds.size.width - 20, 40);
            
           _rugouYouXiangLable.frame=CGRectMake(10, 103, self.view.bounds.size.width - 20, 44);
            _shuruBeijIngTu.hidden = YES;
            _shezhiMimaText.hidden = YES;
            _zaiCiShuruBeijingTu.hidden = YES;
            _zaiCiShuruText.hidden = YES;
            
            
            
        }else{
            //未设置密码
            
            _shuruBeijIngTu.hidden = NO;
            _shezhiMimaText.hidden = NO;
            _zaiCiShuruBeijingTu.hidden = NO;
            _zaiCiShuruText.hidden = NO;
            
            _shuruBeijIngTu.frame=CGRectMake(10, 104, 300, 35);
            _shezhiMimaText.frame=CGRectMake(13, 104, 297, 35);
            _zaiCiShuruText.frame=CGRectMake(13, 153, 297, 35);
            _zaiCiShuruBeijingTu.frame=CGRectMake(10, 153, 300, 35);
            _quedingBDbtn.frame = CGRectMake(10, 265, self.view.bounds.size.width - 20, 40);
            _rugouYouXiangLable.frame=CGRectMake(10, 192,  self.view.bounds.size.width - 20, 44);

            _shezhiMimaText.delegate=self;
            _zaiCiShuruText.delegate=self;
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
    

    
    
    
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
    //_myTimer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(action) userInfo:nil repeats:YES];
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
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码发送成功，请到邮箱查收" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
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

- (IBAction)youxiangBangDingButton:(id)sender {
    if (_YouXiangNumTextField.text.length > 0&&_yanzhenmaTextFeild.text.length > 0) {
        
        if ([_shezhiMimaText.text isEqualToString:_zaiCiShuruText.text]) {
            
        
        NSString *urlStr = [NSString stringWithFormat:@"%@account/bind-email?email=%@&vcode=%@&password=%@&access-token=%@",ApiUrlHead,_YouXiangNumTextField.text,_yanzhenmaTextFeild.text,_shezhiMimaText.text,_token];
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
            UIAlertView*AL=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"密码不一致" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [AL show];
        
        }
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

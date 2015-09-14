//
//  PhoneBangdingViewController.m
//  时时投
//
//  Created by h on 15/8/8.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "PhoneBangdingViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import "WBBooksManager.h"
@interface PhoneBangdingViewController ()

@end

@implementation PhoneBangdingViewController{
    NSInteger t;
    NSTimer*_myTimer;
    AFHTTPRequestOperationManager *manager;
    
    NSString* _str;
    
    
    NSMutableArray* _areaArray;
    NSString* _defaultCode;
    NSString* _defaultCountryName;
    NSString* _VerifyCode;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"手机号码绑定";
        

        
        /*UIButton *lestButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
         [lestButton setImage:[UIImage imageNamed:@"fanhuix@2x"] forState:UIControlStateNormal];
         [lestButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
         UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:lestButton];
         self.navigationItem.leftBarButtonItem = leftItem;*/
        
        
    }
    return self;
}

//发送短信验证码的时候，要他倒计时
//- (void)action{
//    t --;
//    [_PhoneHuoquButton setTitle:[NSString stringWithFormat:@"%lds",(long)t] forState:UIControlStateNormal];
//    
//    if (t <=0) {
//        
//        if ([_myTimer isValid]) {
//            [_myTimer invalidate];
//        }
//        [_PhoneHuoquButton setTitle:@"重发验证码" forState:UIControlStateNormal];
//        _PhoneHuoquButton.enabled=YES;
//        [_PhoneHuoquButton addTarget:self action:@selector(Chongfa) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        
//    }
//    
//}
//-(void)Chongfa{
//    // [_huoqueButton setTitle:@"重发验证码" forState:UIControlStateNormal];
//    
//}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PhoneBangdingViewController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PhoneBangdingViewController"];
    
    //通知刷新我的个人中心
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyInfo" object:nil userInfo:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"_token = %@",_token);
    //判断是否显示密码输入框
    NSString*urlString=[NSString stringWithFormat:@"%@account/is-set-pwd?access-token=%@",ApiUrlHead,_token];
    NSLog(@"urlString = %@",urlString);
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]];
        if ([code isEqualToString:@"1"]) {
            //设置过密码了
            _bangDingButton.frame = CGRectMake(10, 176, self.view.bounds.size.width - 20, 40);
            
            _ruguoBangDingLable.frame=CGRectMake(10, 99, self.view.bounds.size.width - 20, 44);
            _shuruBeiJIngTu.hidden = YES;
            _shuRuMimaText.hidden = YES;
            _zaiCiShuRuBeijingTu.hidden = YES;
            _zaiCiShuRuMIMAText.hidden = YES;

            
            
        }else{
        //未设置密码
        
            _shuruBeiJIngTu.hidden = NO;
            _shuRuMimaText.hidden = NO;
            _zaiCiShuRuBeijingTu.hidden = NO;
            _zaiCiShuRuMIMAText.hidden = NO;
            
            
            _shuRuMimaText.frame=CGRectMake(13, 104, 297, 35);
            _shuruBeiJIngTu.frame=CGRectMake(10, 104, 300, 35);
            _zaiCiShuRuMIMAText.frame=CGRectMake(13, 151, 297, 35);
            _zaiCiShuRuBeijingTu.frame=CGRectMake(10, 151, 300, 35);
            _bangDingButton.frame = CGRectMake(10, 264, self.view.bounds.size.width - 20, 40);
            _ruguoBangDingLable.frame=CGRectMake(10, 195,  self.view.bounds.size.width - 20, 44);
            
            _shuRuMimaText.delegate=self;
            _zaiCiShuRuMIMAText.delegate=self;
            
//            //设置密码
//            NSString*URLString=[NSString stringWithFormat:@"%@user/login?account=%@&password=%@",ApiUrlHead,,_mima.text];
//            NSLog(@"urlString = %@",urlString);
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"JSON: %@", responseObject);
//                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
//                if ([code isEqualToString:@"0"]) {
//                    [self dismissModalViewControllerAnimated:YES];
//                    
//                }
//                
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@", error);
//                
//            }];
//            

            
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
    
    
    
    
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
    
    
}

- (IBAction)PhoneBandingButton:(id)sender {
    NSLog(@"确定绑定");
    NSString *phoneNum1 =[_PhoneNumTextFiled.text substringToIndex:2];
    if (_PhoneYanZhengMa.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else if(![_shuRuMimaText.text isEqualToString:_zaiCiShuRuMIMAText.text]&&_shuRuMimaText.hidden == NO){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码重复不一致" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }else if (_PhoneNumTextFiled.text.length > 0&&_shuRuMimaText.text.length == 0&&_zaiCiShuRuMIMAText.hidden == NO){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        
    }else if (_PhoneNumTextFiled.text.length == 0&&_shuRuMimaText.text.length > 0&&_zaiCiShuRuMIMAText.hidden == NO){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入账号" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        
    }else if(!([self checkTel:_PhoneNumTextFiled.text]||[phoneNum1 isEqualToString:@"14"]||[phoneNum1 isEqualToString:@"17"]||[phoneNum1 isEqualToString:@"18"])){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号格式不正确" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else if (([self checkTel:_PhoneNumTextFiled.text]||[phoneNum1 isEqualToString:@"14"]||[phoneNum1 isEqualToString:@"17"]||[phoneNum1 isEqualToString:@"18"])&&_shuRuMimaText.text.length > 0&&[_shuRuMimaText.text isEqualToString:_zaiCiShuRuMIMAText.text]) {
        _VerifyCode = _PhoneYanZhengMa.text;
        [SMS_SDK commitVerifyCode:_VerifyCode result:^(enum SMS_ResponseState state) {
            if (state == 1) {
                NSLog(@"state = %i,验证通过",state);
                //判断设置的密码是否一致
                if ([_shuRuMimaText.text isEqualToString:_zaiCiShuRuMIMAText.text]) {
                    
                if (_PhoneYanZhengMa.text.length > 0) {
                    NSString *urlStr = [NSString stringWithFormat:@"%@account/bind-mobile?mobile=%@&password=%@&access-token=%@",ApiUrlHead,_PhoneNumTextFiled.text,_shuRuMimaText.text,_token];
                    manager = [AFHTTPRequestOperationManager manager];
                    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"JSON: %@", responseObject);
                        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                        if ([code isEqualToString:@"0"]) {
                            NSDictionary * Data = [responseObject objectForKey:@"data"];
                            NSLog(@"Data = %@",Data);
                            
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号绑定成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [alert show];
                            //通知刷新我的个人中心
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyInfo" object:nil userInfo:nil];
                        }else if (![code isEqualToString:@"0"]){
                            NSString *error = [responseObject objectForKey:@"err"];
                            NSLog(@"error = %@",error);
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [alert show];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络超时或者未知错误"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                        
                    }];
                }
                }else{
                    UIAlertView*A=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"密码不一致" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [A show];
                    
                    
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码错误或失效，请重新获取验证码" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
            }
            }];
       
        
    }else if(([self checkTel:_PhoneNumTextFiled.text]||[phoneNum1 isEqualToString:@"14"]||[phoneNum1 isEqualToString:@"17"]||[phoneNum1 isEqualToString:@"18"])&&_shuRuMimaText.text.length == 0&&[_shuRuMimaText.text isEqualToString:_zaiCiShuRuMIMAText.text]){
        _VerifyCode = _PhoneYanZhengMa.text;
        [SMS_SDK commitVerifyCode:_VerifyCode result:^(enum SMS_ResponseState state) {
            if (state == 1) {
                NSLog(@"state = %i,验证通过",state);
                //判断设置的密码是否一致
                if ([_shuRuMimaText.text isEqualToString:_zaiCiShuRuMIMAText.text]) {
                    if (_PhoneYanZhengMa.text.length > 0) {
                        NSString *urlStr = [NSString stringWithFormat:@"%@account/bind-mobile?mobile=%@&access-token=%@",ApiUrlHead,_PhoneNumTextFiled.text,_token];
                        manager = [AFHTTPRequestOperationManager manager];
                        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSLog(@"JSON: %@", responseObject);
                            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                            if ([code isEqualToString:@"0"]) {
                                NSDictionary * Data = [responseObject objectForKey:@"data"];
                                NSLog(@"Data = %@",Data);
                                
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号绑定成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                [alert show];
                                //通知刷新我的个人中心
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyInfo" object:nil userInfo:nil];
                            }else if (![code isEqualToString:@"0"]){
                                NSString *error = [responseObject objectForKey:@"err"];
                                NSLog(@"error = %@",error);
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                [alert show];
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"Error: %@", error);
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络超时或者未知错误"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [alert show];
                            
                        }];
                    }
                }else{
                    UIAlertView*A=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"密码不一致" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [A show];
                    
                    
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码错误或失效，请重新获取验证码" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
            }
        }];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        
        
    }
         
    
}
         
//手机号码正则表达式
- (BOOL)checkTel:(NSString *)str

{
    if ([str length] == 0) {
        
        //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"data_null_prompt", nil) message:NSLocalizedString(@"tel_no_null", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //
        //        [alert show];
        return NO;
        
    }
    //1[0-9]{10}
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    //    NSString *regex = @"[0-9]{11}";
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        //       UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
        return NO;
    }
    return YES;
}
#pragma MARK-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark -- 获取验证码
-(void)Jishi{
    //发送短信验证码的时候，要他倒计时
    //t = 60;
//    _myTimer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(action) userInfo:nil repeats:YES];
    
    int compareResult = 0;
    for (int i = 0; i< _areaArray.count; i++)
    {
        NSDictionary* dict1 = [_areaArray objectAtIndex:i];
        NSString* code1 = [dict1 valueForKey:@"zone"];
        if ([code1 isEqualToString:[@"+86" stringByReplacingOccurrencesOfString:@"+" withString:@""]]) {
            compareResult = 1;
            NSString* rule1 = [dict1 valueForKey:@"rule"];
            NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule1];
            BOOL isMatch = [pred evaluateWithObject:_PhoneNumTextFiled.text];
            if (!isMatch)
            {
                //手机号码不正确
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil)
                                                                message:NSLocalizedString(@"手机号码格式不正确", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"我知道了", nil)
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            break;
        }
    }
    
    if (!compareResult)
    {
        if (_PhoneNumTextFiled.text.length != 11)
        {
            //手机号码不正确
            //手机号码不正确
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil)
                                                            message:NSLocalizedString(@"手机号码格式不正确", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"我知道了", nil)
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    NSString * str = [NSString stringWithFormat:@"%@:%@ %@\n验证码5分钟内有效",NSLocalizedString(@"即将验证", nil),@"+86",_PhoneNumTextFiled.text];
    _str = [NSString stringWithFormat:@"%@",_PhoneNumTextFiled.text];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"验证手机号", nil)
                                                    message:str delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                          otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        //VerifyViewController* verify = [[VerifyViewController alloc] init];
        NSString* str2 = [@"+86" stringByReplacingOccurrencesOfString:@"+" withString:@""];
        //[verify setPhone:self.telField.text AndAreaCode:str2];
        
        [SMS_SDK getVerificationCodeBySMSWithPhone:_PhoneNumTextFiled.text
                                              zone:str2
                                            result:^(SMS_SDKError *error)
         {
             if (!error)
             {
                 NSLog(@"验证码发送成功");
                 /*[self presentViewController:verify animated:YES completion:^{
                  ;
                  }];*/
             }
             else
             {
                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                               message:[NSString stringWithFormat:@"验证码发送失败，请稍候再试!"]
                                                              delegate:self
                                                     cancelButtonTitle:@"我知道了"
                                                     otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];
        
        //        customIdentifier: 自定义模板标识 如果要使用自定义模板标识需要在官网http://www.mob.com进行申请，审核通过以后会下发该标识，没有情况下默认传@""
        //        [SMS_SDK getVerificationCodeBySMSWithPhone:self.telField.text zone:str2 customIdentifier:@"FXsq" result:^(SMS_SDKError *error) {
        //            if (!error)
        //            {
        //                [self presentViewController:verify animated:YES completion:^{
        //                    ;
        //                }];
        //            }
        //            else
        //            {
        //                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
        //                                                              message:[NSString stringWithFormat:@"状态码：%zi ,错误描述：%@",error.errorCode,error.errorDescription]
        //                                                             delegate:self
        //                                                    cancelButtonTitle:NSLocalizedString(@"sure", nil)
        //                                                    otherButtonTitles:nil, nil];
        //                [alert show];
        //            }
        //
        //        }];
        
    }
}


-(void)setTheLocalAreaCode
{
    NSLocale *locale = [NSLocale currentLocale];
    
    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                               @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                               @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                               @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                               @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                               @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                               @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                               @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                               @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                               @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                               @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                               @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                               @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                               @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                               @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                               @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                               @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                               @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                               @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                               @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                               @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                               @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                               @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                               @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                               @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                               @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                               @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                               @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                               @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                               @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                               @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                               @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                               @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                               @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                               @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                               @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                               @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                               @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                               @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                               @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                               @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                               @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                               @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                               @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                               @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                               @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                               @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                               @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                               @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                               @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                               @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                               @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                               @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                               @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                               @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                               @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                               @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                               @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                               @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                               @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                               @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
    
    NSString* tt = [locale objectForKey:NSLocaleCountryCode];
    NSString* defaultCode = [dictCodes objectForKey:tt];
    
    NSString* defaultCountryName = [locale displayNameForKey:NSLocaleCountryCode value:tt];
    _defaultCode = defaultCode;
    _defaultCountryName = defaultCountryName;
}

@end

//
//  LoginViewController.m
//  dayang
//
//  Created by h on 15/7/20.
//  Copyright (c) 2015年 chendong. All rights reserved.
//
#import "LoginViewController.h"
#import "WBBooksManager.h"
#import "YoukeButton.h"
#import "ZheCeViewController.h"
#import "RequestXlJ.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApi.h>
#import "WXApi.h"
#import "WangjiMimaViewController.h"
#import "AFNetworking.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UITextField *zhanghao;
@property (nonatomic ,strong)UITextField *mima;
@end

@implementation LoginViewController{
  AFHTTPRequestOperationManager *manager;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.2902 green:0.6980 blue:0.8980 alpha:1];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSMutableDictionary * resultDictionary = [[NSMutableDictionary alloc] init];
    [[WBBooksManager sharedInstance] readPlist:&resultDictionary];
    NSDictionary *userdic = [resultDictionary objectForKey:@"userDic1"];
    
    NSLog(@"userdic = %@",userdic);
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 90) * 0.5, 60,90, 90)];
    imageview.image = [UIImage imageNamed:@"dengru"];
    [self.view addSubview:imageview];
    
    UIImageView *imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 100) * 0.5, imageview.frame.origin.y + imageview.bounds.size.height + 20, 100, 50)];
    imageview1.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:imageview1];
    
    
    UIImageView *imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(40, 536 * 0.5 - 20, 15, 15)];
    imageview2.image = [UIImage imageNamed:@"denglu2@2x"];
    [self.view addSubview:imageview2];
    _zhanghao = [[UITextField alloc]initWithFrame:CGRectMake(imageview2.frame.origin.x + imageview2.bounds.size.width + 10, imageview2.frame.origin.y, self.view.bounds.size.width - 100, imageview2.bounds.size.height)];
    _zhanghao.font = [UIFont systemFontOfSize:14.0];
    _zhanghao.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    NSString *zhanghao = [userdic objectForKey:@"userName"];
    if (zhanghao.length > 0) {
         _zhanghao.text = zhanghao;
    }else{
         _zhanghao.text = @"请输入账号／手机号/邮箱";
    }
    _zhanghao.delegate = self;
    _zhanghao.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_zhanghao];
    
    UIView *sepline = [[UIView alloc]initWithFrame:CGRectMake(35, imageview2.frame.origin.y + imageview2.bounds.size.height + 5.5, self.view.bounds.size.width - 70, 0.5)];
    sepline.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    [self.view addSubview:sepline];
    
    UIImageView *imageview3 = [[UIImageView alloc]initWithFrame:CGRectMake(40,  imageview2.frame.origin.y  + 50, 15, 15)];
    imageview3.image = [UIImage imageNamed:@"denglu1@2x"];
    [self.view addSubview:imageview3];
    _mima = [[UITextField alloc]initWithFrame:CGRectMake(imageview3.frame.origin.x + imageview3.bounds.size.width + 10, imageview3.frame.origin.y, self.view.bounds.size.width - 100, imageview3.bounds.size.height)];
    _mima.secureTextEntry = NO;
    _mima.font = [UIFont systemFontOfSize:14.0];
    _mima.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    NSString *mima = [userdic objectForKey:@"mima"];
    if (mima.length > 0) {
        _mima.text = mima;
    }else{
        _mima.text = @"请输入密码";
    }
    _mima.delegate = self;
    _mima.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mima];
    
    UIView *sepline1 = [[UIView alloc]initWithFrame:CGRectMake(35, sepline.frame.origin.y + sepline.bounds.size.height + 50.5, self.view.bounds.size.width - 70, 0.5)];
    sepline1.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    [self.view addSubview:sepline1];
    
    
    UIButton *normalButton = [[UIButton alloc]initWithFrame:CGRectMake(sepline1.frame.origin.x - 5, sepline1.frame.origin.y + sepline1.bounds.size.height + 10, 80, 12)];
    [normalButton setTitle:@"注册          " forState:UIControlStateNormal];
    normalButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [normalButton addTarget:self action:@selector(zhuceAction) forControlEvents:UIControlEventTouchUpInside];
    [normalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    normalButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:normalButton];
    
    UIButton *wanjiMimaButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 105, sepline1.frame.origin.y + sepline1.bounds.size.height + 10, 80, 15)];
    [wanjiMimaButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    wanjiMimaButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [wanjiMimaButton addTarget:self action:@selector(wanjimimaAction) forControlEvents:UIControlEventTouchUpInside];
    [wanjiMimaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wanjiMimaButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:wanjiMimaButton];
    
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 250)*0.5, sepline1.frame.origin.y + sepline1.bounds.size.height + 60, 250, 35)];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"anniu11@2x"] forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    int  distance = (self.view.bounds.size.width - 40*3 - 30*2)*0.5;
    NSArray *array = [NSArray arrayWithObjects:[UIImage imageNamed:@"qq@2x"], [UIImage imageNamed:@"weixin@2x"],[UIImage imageNamed:@"weibo@2x"],nil];
    for (int i = 0; i < 3; i ++) {
        UIButton *otherLogin = [[UIButton alloc]initWithFrame:CGRectMake(distance + 70*i, loginButton.frame.origin.y + loginButton.bounds.size.height + 50, 40, 40)];
        [otherLogin setImage:[array objectAtIndex:i] forState:UIControlStateNormal];
        otherLogin.tag = i;
        [otherLogin addTarget:self action:@selector(otherLoginAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:otherLogin];
    }

//   UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40)];
//   backview.backgroundColor = [UIColor colorWithRed:0.4510 green:0.7725 blue:0.9294 alpha:0.6];
//   [self.view addSubview:backview];
    YoukeButton *zhucebutton = [[YoukeButton alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40)];
    [zhucebutton setImage:[UIImage imageNamed:@"dengluArraw4@2x"] forState:UIControlStateNormal];
    [zhucebutton setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateNormal];
    [zhucebutton setTitle:@"游客登录" forState:UIControlStateNormal];
    zhucebutton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [zhucebutton addTarget:self action:@selector(youkeLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhucebutton];
    
    
    //微信登录监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weixinLoginAction:) name:@"weixinLogin" object:nil];
    // Do any additional setup after loading the view.
}
- (void)wanjimimaAction{
    NSLog(@"忘记密码");
    WangjiMimaViewController*wangji=[[WangjiMimaViewController alloc]init];
    [self.navigationController pushViewController:wangji animated:YES];
    
    
}
- (void)youkeLoginAction{
    NSLog(@"游客登录");
    [self dismissModalViewControllerAnimated:YES];
    //显示TABBAR
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Dock" object:nil userInfo:nil];

}
- (void)zhuceAction{
    NSLog(@"zhuce");
    ZheCeViewController *zvc = [[ZheCeViewController alloc]init];
    [self.navigationController pushViewController:zvc animated:YES];
}
- (void)otherLoginAction:(UIButton *)btn{
    switch (btn.tag) {
        case 0:{
            NSLog(@"qq");
            if ([QQApi isQQInstalled]) {   //QQ存在
                [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                    NSLog(@"%d",result);
                    if (result) {
                        //成功登录后，判断该用户的ID是否在自己的数据库中。
                        //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
                        NSLog(@"nickname = %@",[userInfo nickname]);
                        NSLog(@"uid = %@",[userInfo uid]);
                        NSLog(@"profileImage = %@",[userInfo profileImage]);
                        NSString *nickname= (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                                  (CFStringRef)[userInfo nickname],
                                                                                                                  NULL,
                                                                                                                  (CFStringRef)@"!*'$, %#[]",
                                                                                                                  kCFStringEncodingUTF8));
                        manager = nil;
                        NSString *urlStr = [NSString stringWithFormat:@"%@user/third-login?type=QQ&uid=%@&nickname=%@&hpic=%@",ApiUrlHead,[userInfo uid],nickname,[userInfo profileImage]];
                        manager = [[AFHTTPRequestOperationManager alloc]init];
                        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSLog(@"JSON: %@", responseObject);
                            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                            if ([code isEqualToString:@"0"]) {
                                
                                NSDictionary *data = [responseObject objectForKey:@"data"];
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"tokenGet" object:data userInfo:nil];
                                [self dismissModalViewControllerAnimated:YES];
                            }else if (![code isEqualToString:@"0"]){
                                NSString *error = [responseObject objectForKey:@"err"];
                                NSLog(@"error=%@",error);
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                                [alert show];
                                
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"Error: %@", error);
                            
                            
                        }];
                        //查看授权信息
                        //[self reloadStateWithType:ShareTypeWeixiSession];
                    }
                }];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有安装QQ客户端" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [alert show];
            }
           
            
        }
            break;
        case 1:{
            NSLog(@"weixin");
            if ([WXApi isWXAppInstalled]) {  //安装了微信客户端
                 [self sendAuthRequest];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有安装QQ客户端" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [alert show];
            }
        }
            break;
        case 2:{
            NSLog(@"weibo");
            [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                NSLog(@"%d",result);
                 NSLog(@"%@",error);
                if (result) {
                    //成功登录后，判断该用户的ID是否在自己的数据库中。
                    //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
                    NSLog(@"nickname = %@",[userInfo nickname]);
                    NSLog(@"uid = %@",[userInfo uid]);
                    NSLog(@"profileImage = %@",[userInfo profileImage]);
                    
                    NSString *nickname= (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                              (CFStringRef)[userInfo nickname],
                                                                                                              NULL,
                                                                                                              (CFStringRef)@"!*'$, %#[]",
                                                                                                              kCFStringEncodingUTF8));
                    manager = nil;
                    NSString *urlStr = [NSString stringWithFormat:@"%@user/third-login?type=weibo&uid=%@&nickname=%@&hpic=%@",ApiUrlHead,[userInfo uid],nickname,[userInfo profileImage]];
                    manager = [[AFHTTPRequestOperationManager alloc]init];
                    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"JSON: %@", responseObject);
                        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                       if ([code isEqualToString:@"0"]) {
                            NSDictionary *data = [responseObject objectForKey:@"data"];
                           [[NSNotificationCenter defaultCenter]postNotificationName:@"tokenGet" object:data userInfo:nil];
                           [self dismissModalViewControllerAnimated:YES];
                           
                            
                        }else if (![code isEqualToString:@"0"]){
                            NSString *error = [responseObject objectForKey:@"err"];
                            NSLog(@"error=%@",error);
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                            [alert show];
                            
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        
                        
                    }];
                    
                    //查看授权信息
                    //[self reloadStateWithType:ShareTypeSinaWeibo];
                }
            }];
        }
            break;
        default:
            break;
    }
    
   
}
//微信登录**********************************************
-(void)sendAuthRequest  {
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744";
    [WXApi sendReq:req];
}
- (void)weixinLoginAction:(NSNotification *)notification{
    NSString * code = notification.object;
    NSLog(@"code = %@",code);
    [self getAccess_token:code];
}
-(void)getAccess_token:(NSString *)code {
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wxf87374d4d536653f",@"49161ed663cb05bf80400e43dfc7b146",code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"dic1 = %@",dic);
                /*
                 {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 "expires_in" = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 */
                NSString * access_token = [dic objectForKey:@"access_token"];
                NSString * openid = [dic objectForKey:@"openid"];
                [self getUserInfo:access_token openid:openid];
            }
        });
    });
}
-(void)getUserInfo:(NSString *)access_token openid:(NSString *)openid{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"dic2 = %@",dic);
                NSString *nickname= (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                          (CFStringRef)[dic objectForKey:@"nickname"],
                                                                                                          NULL,
                                                                                                          (CFStringRef)@"!*'$, %#[]",
                                                                                                          kCFStringEncodingUTF8));
                NSString *unionid = [dic objectForKey:@"unionid"];
                NSString *headimgurl = [dic objectForKey:@"headimgurl"];
                
                manager = nil;
                NSString *urlStr = [NSString stringWithFormat:@"%@user/third-login?type=webchat&uid=%@&nickname=%@&hpic=%@",ApiUrlHead,unionid,nickname,headimgurl];
                manager = [[AFHTTPRequestOperationManager alloc]init];
                [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                    if ([code isEqualToString:@"0"]) {
                         NSDictionary *data = [responseObject objectForKey:@"data"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"tokenGet" object:data userInfo:nil];
                        [self dismissModalViewControllerAnimated:YES];
                        
                    }else if (![code isEqualToString:@"0"]){
                        NSString *error = [responseObject objectForKey:@"err"];
                        NSLog(@"error=%@",error);
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                        [alert show];
                        
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    
                    
                }];
                
                /*{
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                //self.nickname.text = [dic objectForKey:@"nickname"];
                //self.wxHeadImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]];
            }
        });
    });
}
///*****************************
- (void)loginAction{
    NSLog(@"denglu");
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    if (![_zhanghao.text  isEqual: @"请输入账号／手机号/邮箱"]&&![_mima.text  isEqual: @"请输入密码"]) {
        [userDic setValue:_zhanghao.text forKey:@"userName"];
        [userDic setValue:_mima.text forKey:@"mima"];
    }
    
    //判断给出的Key对应的数据是否存在
    if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"userDic1"]) {
        //存在，则替换之
        NSLog(@"存在，则替换之");
        [[WBBooksManager sharedInstance] replaceDictionary:userDic withDictionaryKey:@"userDic1"];
    }else{//不存在，则写入
        NSLog(@"不存在，则写入");
        [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"userDic1"];
    }
   
    
    __block RequestXlJ  *request=[[RequestXlJ alloc]init];
    NSString*urlString=[NSString stringWithFormat:@"%@user/login?account=%@&password=%@",ApiUrlHead,_zhanghao.text,_mima.text];
    [request requestWithUrl:urlString methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dic,NSArray *array){
        if (code == 0) {
           [[NSNotificationCenter defaultCenter]postNotificationName:@"tokenGet" object:dic userInfo:nil];
            
            [self dismissModalViewControllerAnimated:YES];

        }else{
            NSLog(@"error");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _zhanghao) {
        if ([_zhanghao.text isEqualToString:@"请输入账号／手机号/邮箱"]) {
            _zhanghao.text = @"";
        }
        
    }
    if (textField == _mima) {
        if ([_mima.text isEqualToString:@"请输入密码"]) {
            _mima.text = @"";
            _mima.secureTextEntry = YES;
            _mima.font = [UIFont systemFontOfSize:9];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
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

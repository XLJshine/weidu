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
#import "LoadingViewXLJ.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UITextField *zhanghao;
@property (nonatomic ,strong)UITextField *mima;
@end

@implementation LoginViewController{
   AFHTTPRequestOperationManager *manager;
   NSInteger num;
    UIButton *autoLoginButton;
    LoadingViewXLJ *_loadingView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    num = 0;
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.2902 green:0.6980 blue:0.8980 alpha:1];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSMutableDictionary * resultDictionary = [[NSMutableDictionary alloc] init];
    [[WBBooksManager sharedInstance] readPlist:&resultDictionary];
    NSDictionary *userdic = [resultDictionary objectForKey:@"userDic1"];
    NSString *type = [userdic objectForKey:@"type"];
    NSLog(@"userdic = %@",userdic);
    if (self.view.bounds.size.height > 480) {   //iphone5,5s,6,6p
        UIImageView *imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 60) * 0.5,80, 60, 95)];
        imageview1.image = [UIImage imageNamed:@"loginlogo_w@2x"];
        [self.view addSubview:imageview1];
        
        UIImageView *imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(40, 536 * 0.5 - 20, 15, 15)];
        imageview2.image = [UIImage imageNamed:@"denglu2@2x"];
        [self.view addSubview:imageview2];
        _zhanghao = [[UITextField alloc]initWithFrame:CGRectMake(imageview2.frame.origin.x + imageview2.bounds.size.width + 10, imageview2.frame.origin.y, self.view.bounds.size.width - 100, imageview2.bounds.size.height)];
        _zhanghao.font = [UIFont systemFontOfSize:14.0];
        _zhanghao.textColor = [UIColor colorWithWhite:1 alpha:0.6];
        if (!type&&!_ifLoginOut.length > 0) {
            NSString *zhanghao = [userdic objectForKey:@"userName"];
            _zhanghao.text = zhanghao;
        }
        
        _zhanghao.placeholder = @"请输入账号/手机号/邮箱";
        _zhanghao.delegate = self;
        _zhanghao.keyboardType = UIKeyboardTypeDefault;
        _zhanghao.returnKeyType = UIReturnKeyDone;
        _zhanghao.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_zhanghao];
        
        UIView *sepline = [[UIView alloc]initWithFrame:CGRectMake(35, imageview2.frame.origin.y + imageview2.bounds.size.height + 5.5, self.view.bounds.size.width - 70, 0.5)];
        sepline.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        [self.view addSubview:sepline];
        
        UIImageView *imageview3 = [[UIImageView alloc]initWithFrame:CGRectMake(40,  imageview2.frame.origin.y  + 50, 15, 15)];
        imageview3.image = [UIImage imageNamed:@"denglu1@2x"];
        [self.view addSubview:imageview3];
        _mima = [[UITextField alloc]initWithFrame:CGRectMake(imageview3.frame.origin.x + imageview3.bounds.size.width + 10, imageview3.frame.origin.y, self.view.bounds.size.width - 100, imageview3.bounds.size.height)];
        [_mima addTarget:self action:@selector(textchanged:) forControlEvents:UIControlEventEditingChanged];
        _mima.font = [UIFont systemFontOfSize:14.0];
        _mima.textColor = [UIColor colorWithWhite:1 alpha:0.6];
        if (!type&&!_ifLoginOut.length > 0) {
            NSString *mima = [userdic objectForKey:@"mima"];
             _mima.text = mima;
        }
       
        _mima.placeholder = @"请输入密码";
        _mima.secureTextEntry = YES;
        _mima.returnKeyType = UIReturnKeyDone;
        
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
         if ([WXApi isWXAppInstalled]) {
                UIButton *otherLogin = [[UIButton alloc]initWithFrame:CGRectMake(distance + 70*1, loginButton.frame.origin.y + loginButton.bounds.size.height + 50, 40, 40)];
                [otherLogin setImage:[array objectAtIndex:1] forState:UIControlStateNormal];
                otherLogin.tag = 1;
                [otherLogin addTarget:self action:@selector(otherLoginAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:otherLogin];
            }
        if ([QQApi isQQInstalled]){
                UIButton *otherLogin = [[UIButton alloc]initWithFrame:CGRectMake(distance + 70*0, loginButton.frame.origin.y + loginButton.bounds.size.height + 50, 40, 40)];
                [otherLogin setImage:[array objectAtIndex:0] forState:UIControlStateNormal];
                otherLogin.tag = 0;
                [otherLogin addTarget:self action:@selector(otherLoginAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:otherLogin];
            }
        
        
                UIButton *otherLogin = [[UIButton alloc]initWithFrame:CGRectMake(distance + 70*2, loginButton.frame.origin.y + loginButton.bounds.size.height + 50, 40, 40)];
                [otherLogin setImage:[array objectAtIndex:2] forState:UIControlStateNormal];
                otherLogin.tag = 2;
                [otherLogin addTarget:self action:@selector(otherLoginAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:otherLogin];
        
    
        //  UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40)];
        //   backview.backgroundColor = [UIColor colorWithRed:0.4510 green:0.7725 blue:0.9294 alpha:0.6];
        //   [self.view addSubview:backview];
        YoukeButton *zhucebutton = [[YoukeButton alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40)];
        [zhucebutton setImage:[UIImage imageNamed:@"dengluArraw4@2x"] forState:UIControlStateNormal];
        [zhucebutton setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateNormal];
        [zhucebutton setTitle:@"游客登录" forState:UIControlStateNormal];
        zhucebutton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [zhucebutton addTarget:self action:@selector(youkeLoginAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:zhucebutton];

    }else{  //iphone4,4s
    
        UIImageView *imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 60) * 0.5,69, 60, 95)];
        imageview1.image = [UIImage imageNamed:@"loginlogo_w@2x"];
        [self.view addSubview:imageview1];
        
        
        UIImageView *imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(40, imageview1.frame.origin.y + imageview1.bounds.size.height + 25, 15, 15)];
        imageview2.image = [UIImage imageNamed:@"denglu2@2x"];
        [self.view addSubview:imageview2];
        _zhanghao = [[UITextField alloc]initWithFrame:CGRectMake(imageview2.frame.origin.x + imageview2.bounds.size.width + 10, imageview2.frame.origin.y, self.view.bounds.size.width - 100, imageview2.bounds.size.height)];
        _zhanghao.font = [UIFont systemFontOfSize:14.0];
        _zhanghao.textColor = [UIColor colorWithWhite:1 alpha:0.6];
        if (!type&&!_ifLoginOut.length > 0) {
            NSString *zhanghao = [userdic objectForKey:@"userName"];
            _zhanghao.text = zhanghao;
        }
      
        _zhanghao.placeholder = @"请输入账号/手机号/邮箱";
        _zhanghao.delegate = self;
         _zhanghao.keyboardType = UIKeyboardTypeDefault;
          _zhanghao.returnKeyType = UIReturnKeyDone;
        _zhanghao.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_zhanghao];
        
        UIView *sepline = [[UIView alloc]initWithFrame:CGRectMake(35, imageview2.frame.origin.y + imageview2.bounds.size.height + 5.5, self.view.bounds.size.width - 70, 0.5)];
        sepline.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        [self.view addSubview:sepline];
        
        UIImageView *imageview3 = [[UIImageView alloc]initWithFrame:CGRectMake(40,  imageview2.frame.origin.y  + 50, 15, 15)];
        imageview3.image = [UIImage imageNamed:@"denglu1@2x"];
        [self.view addSubview:imageview3];
        _mima = [[UITextField alloc]initWithFrame:CGRectMake(imageview3.frame.origin.x + imageview3.bounds.size.width + 10, imageview3.frame.origin.y, self.view.bounds.size.width - 100, imageview3.bounds.size.height)];
        _mima.font = [UIFont systemFontOfSize:14.0];
        _mima.textColor = [UIColor colorWithWhite:1 alpha:0.6];
        [_mima addTarget:self action:@selector(textchanged:) forControlEvents:UIControlEventEditingChanged];
        if (!type&&!_ifLoginOut.length > 0) {
            NSString *mima = [userdic objectForKey:@"mima"];
            _mima.text = mima;
        }
        _mima.placeholder = @"请输入密码";
        _mima.secureTextEntry = YES;
        _mima.delegate = self;
        _mima.returnKeyType = UIReturnKeyDone;
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
        
        
            if ([WXApi isWXAppInstalled]) {
                UIButton *otherLogin = [[UIButton alloc]initWithFrame:CGRectMake(distance + 70*1, loginButton.frame.origin.y + loginButton.bounds.size.height + 30, 40, 40)];
                [otherLogin setImage:[array objectAtIndex:1] forState:UIControlStateNormal];
                otherLogin.tag = 1;
                [otherLogin addTarget:self action:@selector(otherLoginAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:otherLogin];
            }
        
        if ([QQApi isQQInstalled]){
                UIButton *otherLogin = [[UIButton alloc]initWithFrame:CGRectMake(distance + 70*0, loginButton.frame.origin.y + loginButton.bounds.size.height + 30, 40, 40)];
                [otherLogin setImage:[array objectAtIndex:0] forState:UIControlStateNormal];
                otherLogin.tag = 0;
                [otherLogin addTarget:self action:@selector(otherLoginAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:otherLogin];
            }
        
        
                UIButton *otherLogin = [[UIButton alloc]initWithFrame:CGRectMake(distance + 70*2, loginButton.frame.origin.y + loginButton.bounds.size.height + 30, 40, 40)];
                [otherLogin setImage:[array objectAtIndex:2] forState:UIControlStateNormal];
                otherLogin.tag = 2;
                [otherLogin addTarget:self action:@selector(otherLoginAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:otherLogin];
       

        
        YoukeButton *zhucebutton = [[YoukeButton alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40)];
        [zhucebutton setImage:[UIImage imageNamed:@"dengluArraw4@2x"] forState:UIControlStateNormal];
        [zhucebutton setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateNormal];
        [zhucebutton setTitle:@"游客登录" forState:UIControlStateNormal];
        zhucebutton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [zhucebutton addTarget:self action:@selector(youkeLoginAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:zhucebutton];
        
    }
    
    //微信登录监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weixinLoginAction:) name:@"weixinLogin" object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
}
- (void)autoLoginSet:(UIButton *)button{
    button.selected = !button.selected;
}
#pragma mark --- 监听密码变化
- (void)textchanged:(UITextField *)textfield{
    NSLog(@"change");
    if (_mima.text.length == 0) {
        _mima.placeholder = @"请输入密码";
        //_mima.secureTextEntry = NO;
    }else{
        _mima.secureTextEntry = YES;
    }
}
- (void)wanjimimaAction{
    NSLog(@"忘记密码");
    WangjiMimaViewController*wangji=[[WangjiMimaViewController alloc]init];
    [self.navigationController pushViewController:wangji animated:YES];
    
    
}
- (void)youkeLoginAction{
    NSLog(@"游客登录");
    [self dismissModalViewControllerAnimated:YES];
    NSDictionary *dic = [NSDictionary dictionary];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tokenGet" object:dic userInfo:nil];
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
                    NSLog(@"%d  // %@",result,error);
                    if (result) {
                        _loadingView = [[LoadingViewXLJ alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 200)*0.5, self.view.bounds.size.height*0.5 - 50, 200,100)   title:@"正在登录"];
                        [self.view addSubview:_loadingView];
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
                        NSLog(@"urlStr = %@",urlStr);
                        
                        NSString *uslStr1 = [NSString stringWithFormat:@"%@user/third-login?",ApiUrlHead];
                        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"QQ",@"type",
                                                    [userInfo uid],@"uid",
                                                     [userInfo nickname],@"nickname",
                                                    [userInfo profileImage],@"hpic",nil];
                        manager = [[AFHTTPRequestOperationManager alloc]init];
                        [manager GET:uslStr1 parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [_loadingView removeFromSuperview];
                            //NSLog(@"JSON: %@", responseObject);
                            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                            if ([code isEqualToString:@"0"]) {
                                 NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
                               //判断给出的Key对应的数据是否存在
                                [userDic setValue:[userInfo nickname] forKey:@"userName"];
                                [userDic setValue:[userInfo uid] forKey:@"mima"];
                                [userDic setValue:[userInfo profileImage] forKey:@"image"];
                                [userDic setValue:@"1" forKey:@"type"];   //QQ登录
                                 if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"userDic1"]) {
                                        //存在，则替换之
                                        NSLog(@"存在，则替换之");
                                        [[WBBooksManager sharedInstance] replaceDictionary:userDic withDictionaryKey:@"userDic1"];
                                    }else{//不存在，则写入
                                        NSLog(@"不存在，则写入");
                                        [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"userDic1"];
                                    }
                                
                                NSDictionary *data = [responseObject objectForKey:@"data"];
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"tokenGet" object:data userInfo:nil];
                                [self dismissModalViewControllerAnimated:YES];
                            }else if (![code isEqualToString:@"0"]){
                                NSString *error = [responseObject objectForKey:@"err"];
                                NSLog(@"error=%@",error);
                                [_loadingView removeFromSuperview];
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                                [alert show];
                                
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"Error: %@", error);
                             [_loadingView removeFromSuperview];
                            
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
                    _loadingView = [[LoadingViewXLJ alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 200)*0.5, self.view.bounds.size.height*0.5 - 50, 200,100)   title:@"正在登录"];
                    [self.view addSubview:_loadingView];
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
                    
                    NSString *uslStr1 = [NSString stringWithFormat:@"%@user/third-login?",ApiUrlHead];
                    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"weibo",@"type",
                                                [userInfo uid],@"uid",
                                                [userInfo nickname],@"nickname",
                                                [userInfo profileImage],@"hpic",nil];
                    manager = [[AFHTTPRequestOperationManager alloc]init];
                    
                    [manager GET:uslStr1 parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         [_loadingView removeFromSuperview];
                        NSLog(@"JSON: %@", responseObject);
                        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                       if ([code isEqualToString:@"0"]) {
                           NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
                           //判断给出的Key对应的数据是否存在
                           [userDic setValue:[userInfo nickname] forKey:@"userName"];
                           [userDic setValue:[userInfo uid] forKey:@"mima"];
                           [userDic setValue:[userInfo profileImage] forKey:@"image"];
                           [userDic setValue:@"3" forKey:@"type"];   //微博
                           if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"userDic1"]) {
                               //存在，则替换之
                               NSLog(@"存在，则替换之");
                               [[WBBooksManager sharedInstance] replaceDictionary:userDic withDictionaryKey:@"userDic1"];
                           }else{//不存在，则写入
                               NSLog(@"不存在，则写入");
                               [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"userDic1"];
                           }
                           

                           NSDictionary *data = [responseObject objectForKey:@"data"];
                           [[NSNotificationCenter defaultCenter]postNotificationName:@"tokenGet" object:data userInfo:nil];
                           [self dismissModalViewControllerAnimated:YES];
                        
                       }else if (![code isEqualToString:@"0"]){
                            NSString *error = [responseObject objectForKey:@"err"];
                            NSLog(@"error=%@",error);
                            [_loadingView removeFromSuperview];
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                            [alert show];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        [_loadingView removeFromSuperview];
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
#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
     NSDictionary* info = [note userInfo];
    NSLog(@"info = %@",info);
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height + 100;
    [UIView animateWithDuration:0.15 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
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
    //NSLog(@"code = %@",code);
    [self getAccess_token:code];
}
-(void)getAccess_token:(NSString *)code {
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wx66a51ebed2c0d1ea",@"dd367c7c6e270bcd37411d56dd80511a",code];
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
                _loadingView = [[LoadingViewXLJ alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 200)*0.5, self.view.bounds.size.height*0.5 - 50, 200,100)   title:@"正在登录"];
                [self.view addSubview:_loadingView];
                
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
                
                NSString *uslStr1 = [NSString stringWithFormat:@"%@user/third-login?",ApiUrlHead];
                NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"webchat",@"type",
                                            unionid,@"uid",
                                            [dic objectForKey:@"nickname"],@"nickname",
                                            headimgurl,@"hpic",nil];
                [manager GET:uslStr1 parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [_loadingView removeFromSuperview];
                    NSLog(@"JSON: %@", responseObject);
                    NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                    if ([code isEqualToString:@"0"]) {
                        NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
                        //判断给出的Key对应的数据是否存在
                        [userDic setValue:[dic objectForKey:@"nickname"] forKey:@"userName"];
                        [userDic setValue:unionid forKey:@"mima"];
                        [userDic setValue:headimgurl forKey:@"image"];
                        [userDic setValue:@"2" forKey:@"type"];  //微信
                        if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"userDic1"]) {
                            //存在，则替换之
                            NSLog(@"存在，则替换之");
                            [[WBBooksManager sharedInstance] replaceDictionary:userDic withDictionaryKey:@"userDic1"];
                        }else{//不存在，则写入
                            NSLog(@"不存在，则写入");
                            [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"userDic1"];
                        }
                        
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
                    [_loadingView removeFromSuperview];
                    
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
    if (num == 0) {
        num ++;
        
        NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
        if (_zhanghao.text.length > 0&&_mima.text.length > 0) {
             _loadingView = [[LoadingViewXLJ alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 200)*0.5, self.view.bounds.size.height*0.5 - 50, 200,100)   title:@"正在登录"];
            [self.view addSubview:_loadingView];
            __block RequestXlJ  *request=[[RequestXlJ alloc]init];
            NSString*urlString=[NSString stringWithFormat:@"%@user/login?account=%@&password=%@",ApiUrlHead,_zhanghao.text,_mima.text];
            NSString *encoded = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [request requestWithUrl:encoded methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dic,NSArray *array){
                 num = 0;
                [_loadingView removeFromSuperview];
                if (code == 0) {
                    //判断给出的Key对应的数据是否存在
                    [userDic setValue:_zhanghao.text forKey:@"userName"];
                    [userDic setValue:_mima.text forKey:@"mima"];
                    if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"userDic1"]) {
                        //存在，则替换之
                        NSLog(@"存在，则替换之");
                        [[WBBooksManager sharedInstance] replaceDictionary:userDic withDictionaryKey:@"userDic1"];
                    }else{//不存在，则写入
                        NSLog(@"不存在，则写入");
                        [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"userDic1"];
                    }
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"tokenGet" object:dic userInfo:nil];
                    [self dismissModalViewControllerAnimated:YES];
                
                }else{
                    NSLog(@"error");
                    [_loadingView removeFromSuperview];
                    if (error.length == 0) {
                        error = @"似乎已断开与互联网的连接";
                    }
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                    [alert show];
                    num = 0;
                }
            }];
            
        }else if (_zhanghao.text.length > 0&&_mima.text.length == 0){
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alertview show];
             [_loadingView removeFromSuperview];
            num = 0;
        }else if(_zhanghao.text.length > 0&&_mima.text.length == 0){
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入账号" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alertview show];
            [_loadingView removeFromSuperview];
            num = 0;
        }else{
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入账号密码" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alertview show];
            num = 0;
        }
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    self.view.transform = CGAffineTransformIdentity;
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LoginViewController"];
    self.navigationController.navigationBarHidden = YES;
    
    self.view.transform = CGAffineTransformIdentity;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LoginViewController"];
    self.navigationController.navigationBarHidden = NO;
    
    [_zhanghao resignFirstResponder];
    [_mima resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //展示引导页
    if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"IntroduceView"]) {
        //存在，不处理
        
    }else{//不存在，则写入
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"1", nil];
        NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"IntroduceView"];
        [self showIntroWithCrossDissolve];
    }
   
}
- (void)showIntroWithCrossDissolve
{
    EAIntroPage *page1 = [EAIntroPage page];
    //page1.title = @"Hello world";
    //page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    
    //page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    // page2.title = @"This is page 2";
    // page2.desc = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
    
    //page2.titleImage = [UIImage imageNamed:@"supportcat"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    //page3.title = @"This is page 3";
    //page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
    
    //page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    //page3.title = @"This is page 3";
    //page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
    if (self.view.bounds.size.height > 500) {
        page1.bgImage = [UIImage imageNamed:@"intro_page1"];
        page2.bgImage = [UIImage imageNamed:@"intro_page2"];
        page3.bgImage = [UIImage imageNamed:@"intro_page3"];
        page4.bgImage = [UIImage imageNamed:@"intro_page4"];
    }else{
        page1.bgImage = [UIImage imageNamed:@"intro_page14"];
        page2.bgImage = [UIImage imageNamed:@"intro_page24"];
        page3.bgImage = [UIImage imageNamed:@"intro_page34"];
        page4.bgImage = [UIImage imageNamed:@"intro_page44"];
    }
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)introDidFinish {
    NSLog(@"Intro callback");


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

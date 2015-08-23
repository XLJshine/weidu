//
//  Login_ViewController.m
//  时时投
//
//  Created by 熊良军 on 15/7/20.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "Login_ViewController.h"
#import "WBBooksManager.h"
@interface Login_ViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UITextField *zhanghao;
@property (nonatomic ,strong)UITextField *mima;
@end

@implementation Login_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.2902 green:0.6980 blue:0.8980 alpha:1];
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
    
    
    UIImageView *imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(40,  imageview1.frame.origin.y + imageview1.bounds.size.height + 20, 22, 22)];
    imageview2.image = [UIImage imageNamed:@"zhanghao@2x"];
    [self.view addSubview:imageview2];
    _zhanghao = [[UITextField alloc]initWithFrame:CGRectMake(imageview2.frame.origin.x + imageview2.bounds.size.width + 10, imageview2.frame.origin.y, self.view.bounds.size.width - 100, imageview2.bounds.size.height)];
    _zhanghao.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    _zhanghao.text = [userdic objectForKey:@"userName"];
    _zhanghao.delegate = self;
    _zhanghao.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_zhanghao];
    
    UIView *sepline = [[UIView alloc]initWithFrame:CGRectMake(35, imageview2.frame.origin.y + imageview2.bounds.size.height + 5, self.view.bounds.size.width - 70, 1)];
    sepline.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.view addSubview:sepline];
    
    UIImageView *imageview3 = [[UIImageView alloc]initWithFrame:CGRectMake(40,  imageview2.frame.origin.y  + 50, 22, 22)];
    imageview3.image = [UIImage imageNamed:@"mima@2x"];
    [self.view addSubview:imageview3];
    _mima = [[UITextField alloc]initWithFrame:CGRectMake(imageview3.frame.origin.x + imageview3.bounds.size.width + 10, imageview3.frame.origin.y, self.view.bounds.size.width - 100, imageview3.bounds.size.height)];
    _mima.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    _mima.text = [userdic objectForKey:@"mima"];
    _mima.delegate = self;
    _mima.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mima];
    
    UIView *sepline1 = [[UIView alloc]initWithFrame:CGRectMake(35, sepline.frame.origin.y + sepline.bounds.size.height + 50, self.view.bounds.size.width - 70, 1)];
    sepline1.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    [self.view addSubview:sepline1];
    
    
    UIButton *normalButton = [[UIButton alloc]initWithFrame:CGRectMake(sepline1.frame.origin.x, sepline1.frame.origin.y + sepline1.bounds.size.height + 10, 80, 15)];
    [normalButton setTitle:@"游客登录" forState:UIControlStateNormal];
    normalButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [normalButton addTarget:self action:@selector(youkeLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [normalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    normalButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:normalButton];
    
    
    UIButton *wanjiMimaButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 110, sepline1.frame.origin.y + sepline1.bounds.size.height + 10, 80, 15)];
    [wanjiMimaButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    wanjiMimaButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [wanjiMimaButton addTarget:self action:@selector(wanjimimaAction) forControlEvents:UIControlEventTouchUpInside];
    [wanjiMimaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wanjiMimaButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:wanjiMimaButton];
    
    
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 250)*0.5, normalButton.frame.origin.y + normalButton.bounds.size.height + 41, 250, 35)];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"anniu@2x"] forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    int  distance = (self.view.bounds.size.width - 40*3 - 30*2)*0.5;
    NSArray *array = [NSArray arrayWithObjects:[UIImage imageNamed:@"qq@2x"], [UIImage imageNamed:@"weixin@2x"],[UIImage imageNamed:@"weibo@2x"],nil];
    for (int i = 0; i < 3; i ++) {
        UIButton *otherLogin = [[UIButton alloc]initWithFrame:CGRectMake(distance + 70*i, loginButton.frame.origin.y + loginButton.bounds.size.height + 35, 40, 40)];
        [otherLogin setImage:[array objectAtIndex:i] forState:UIControlStateNormal];
        otherLogin.tag = i;
        [otherLogin addTarget:self action:@selector(otherLoginAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:otherLogin];
    }
    
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40)];
    backview.backgroundColor = [UIColor colorWithRed:0.4510 green:0.7725 blue:0.9294 alpha:0.6];
    [self.view addSubview:backview];
    UIButton *zhucebutton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40)];
    [zhucebutton setTitle:@"新用户？注册" forState:UIControlStateNormal];
    zhucebutton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [zhucebutton addTarget:self action:@selector(zhuceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhucebutton];
    // Do any additional setup after loading the view.
}
- (void)wanjimimaAction{
    NSLog(@"忘记密码");

}
- (void)youkeLoginAction{
    NSLog(@"游客登录");
    [self dismissModalViewControllerAnimated:YES];

}
- (void)zhuceAction{
     NSLog(@"zhuce");
}
- (void)otherLoginAction:(UIButton *)btn{
    switch (btn.tag) {
        case 0:{
            NSLog(@"qq");
            
        }
            break;
        case 1:{
             NSLog(@"weixin");
            
        }
            break;
        case 2:{
           NSLog(@"weibo");
            
        }
            break;
        default:
            break;
    }
}
- (void)loginAction{
    NSLog(@"denglu");
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    [userDic setValue:_zhanghao.text forKey:@"userName"];
    [userDic setValue:_mima.text forKey:@"mima"];
    //判断给出的Key对应的数据是否存在
    if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"userDic1"]) {
        //存在，则替换之
        NSLog(@"存在，则替换之");
        [[WBBooksManager sharedInstance] replaceDictionary:userDic withDictionaryKey:@"userDic1"];
    }else{//不存在，则写入
        NSLog(@"不存在，则写入");
        [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"userDic1"];
    }
    [self dismissModalViewControllerAnimated:YES];
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

@end

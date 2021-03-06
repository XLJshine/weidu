//
//  MainViewController.m
//  时时投
//
//  Created by 熊良军 on 15/7/19.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking.h"
#import "TongxunluViewController.h"
#import "TouBiaoViewController.h"
#import "ShouCangViewController.h"
#import "XiaoXiViewController.h"
#import "Dock.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MyNavigationController.h"
#import "AFNetworkReachabilityManager.h"
#import "ShezhiViewController.h"
#import "JiFenViewController.h"
#import "FangkeViewController.h"
#import "GerenInfo_My_ViewController.h"
#import "GongsiViewController.h"
#import "DingYueXiaoXiViewController.h"
#import "DongTaiViewController.h"
#import "XiangmuPinglunViewController.h"
#import "xiangMuPinLunViewController.h"
#import "ShareViewController.h"
#import "WBBooksManager.h"
#import "RequestXlJ.h"
#import "NewPingLunViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "YouxiangBangdingViewController.h"
#import "PhoneBangdingViewController.h"
#import "ZhanghaoBandingViewController.h"
@interface MainViewController ()<DockDelegate>
@property (nonatomic ,strong)Dock *dock;
@property (nonatomic ,assign)NSInteger number1;
@property (nonatomic ,strong)TouBiaoViewController * tvc;
@property (nonatomic ,strong)XiaoXiViewController * xvc;
@property (nonatomic ,strong)ShouCangViewController * svc;
@property (nonatomic ,strong)MyNavigationController *mainNavigationController;
@property (nonatomic ,strong)LoginViewController *controller1;
@property (nonatomic ,strong)UIControl *hideview;
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;
@end

@implementation MainViewController{
    UIAlertView *NetAlert;
    NSString * ifModelNavigation;  //是否是个人中心跳转，存在
    AFHTTPRequestOperationManager *manager;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
     manager = [[AFHTTPRequestOperationManager alloc]init];
    
    [self initData];
    
    __block int  num = 0;
     //检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld", (long)status);
        if (num != 0) {
            [NetAlert removeFromSuperview];
            switch (status) {
                case 2:
                {
                    NetAlert = [[UIAlertView alloc]initWithTitle:@"网络状态" message:@"连接到WIFI网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [NetAlert show];
                }
                    break;
                case 1:
                {
                    NetAlert = [[UIAlertView alloc]initWithTitle:@"网络状态" message:@"连接到3G网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [NetAlert show];
                }
                    break;
                case 0:
                {
                    NetAlert = [[UIAlertView alloc]initWithTitle:@"网络状态" message:@"网络已断开" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [NetAlert show];
                }
                    break;
                case -1:
                {
                    NetAlert = [[UIAlertView alloc]initWithTitle:@"网络状态" message:@"未知网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [NetAlert show];
                }
                    break;
                default:
                    break;
            }
        }else{
            num ++;
        }
      
    }];
    //如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
   
    
    
    _dock = [[Dock alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49 - 64, self.view.bounds.size.width, 49)];
    _dock.delegate = self;
    _dock.tag = 100;
    //_dock.hidden = YES;
    //[self.view addSubview:_dock];
    //往Dock里面填充按钮
    [_dock addItemWithIcon:@"zhuye@2x" selectIcon:@"zhuye1@2x" title:@"投标"];
    [_dock addItemWithIcon:@"xiaoxi1@2" selectIcon:@"xiaoxi@2x" title:@"消息"];
    //[_dock addItemWithIcon:@"renmai@2x" selectIcon:@"renmai11@2x" title:@"人脉"];
    [_dock addItemWithIcon:@"soucang@2x" selectIcon:@"shoucang1@2x" title:@"收藏"];
    
    //监听，显示阴影
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideviewAppear) name:@"hideviewAppear" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myCenterPush:) name:@"myCenterPush" object:nil]; //跳转监听
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tokenGet:) name:@"tokenGet" object:nil]; //监听获取token
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shareAction:) name:@"toShareViewController" object:nil];   //监听分享操作
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LoginViewAction:) name:@"LoginView" object:nil];   //监听弹出登录界面
    //侧滑半透明遮挡主视图
    _hideview = [[UIControl alloc]initWithFrame:self.view.bounds];
    _hideview.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self.view addSubview:_hideview];
    [_hideview addTarget:self action:@selector(hideviewDismiss) forControlEvents:UIControlEventTouchUpInside];
    _hideview.hidden = YES;
}

- (void)LoginViewAction:(NSNotification *)notification{
    [self loginView];
}
- (void)initData{
    //初始化数据，判断给出的Key对应的数据是否存在
    if (![[WBBooksManager sharedInstance] isBookExistsForKey:@"Article"]){
        NSString *urlStr1 = [NSString stringWithFormat:@"%@article/fitems",ApiUrlHead];
        NSLog(@"urlStr = %@",urlStr1);
       [manager GET:urlStr1 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            if ([code isEqualToString:@"0"]) {
                NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"Article"];
                
            }else if (![code isEqualToString:@"0"]){
                NSLog(@"加载失败。。");
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            
        }];
        

        
    }
}
- (void)tokenGet:(NSNotification *)notification{
    NSDictionary *dic = notification.object;
    NSLog(@"dic22 = %@",dic);
    //id str = [dic objectForKey:@"token"];
    _token = [NSString stringWithFormat:@"%@",[dic objectForKey:@"token"]];
    _uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
    _tvc.token = _token;
    _tvc.uid = _uid;
    NSLog(@"_token=%@  _uid=%@",_token,_uid);
    //通知刷新我的个人中心、刷新消息、刷新收藏
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyInfo" object:dic userInfo:nil];
}
- (void)hideviewAppear{
    _hideview.hidden = NO;
    [self.view bringSubviewToFront:_hideview];

}
- (void)hideviewDismiss{
    _hideview.hidden = YES;
    //发送通知，隐藏阴影
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewDismiss" object:nil userInfo:nil];
}

#pragma mark  ---- 分享
- (void)shareAction:(NSNotification *)notification{
    ShareViewController *svc = [[ShareViewController alloc]init];
    svc.shareDic = notification.object;
    svc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        svc.providesPresentationContextTransitionStyle = YES;
        svc.definesPresentationContext = YES;
        svc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:svc animated:YES completion:nil];
    } else {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:svc animated:NO completion:nil];
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    
}
#pragma mark  ---- 跳转
- (void)myCenterPush:(NSNotification *)notification{
    NSString *controllerName = notification.object;
    NSLog(@"=====%@",controllerName);
    ifModelNavigation  = @"shide";
    _tvc.ifModelNavigation = ifModelNavigation;
    _xvc.ifModelNavigation = ifModelNavigation;
    _svc.ifModelNavigation = ifModelNavigation;
    ifModelNavigation = @"";
    
    
    if ([controllerName isEqualToString:@"shezhi"]) {
        ShezhiViewController *SVC = [[ShezhiViewController alloc]init];
        SVC.token = _token;
        SVC.uid = _uid;
        [_mainNavigationController pushViewController:SVC animated:YES];
        //发送通知，隐藏阴影
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewDismiss" object:nil userInfo:nil];
    }else if ([controllerName isEqualToString:@"jifen"]){
        JiFenViewController *JVC = [[JiFenViewController alloc]init];
        [_mainNavigationController pushViewController:JVC animated:YES];
        //发送通知，隐藏阴影
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewDismiss" object:nil userInfo:nil];
    }else if ([controllerName isEqualToString:@"fangke"]){
        FangkeViewController *FVC = [[FangkeViewController alloc]init];
        FVC.token=_token;
        FVC.uid=_uid;
        [_mainNavigationController pushViewController:FVC animated:YES];
        //发送通知，隐藏阴影
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewDismiss" object:nil userInfo:nil];
    }else if ([controllerName isEqualToString:@"mycenter"]){
       GerenInfo_My_ViewController *GVC = [[GerenInfo_My_ViewController alloc]init];
        GVC.token = _token;
        GVC.uid = _uid;
       [_mainNavigationController pushViewController:GVC animated:YES];
        //发送通知，隐藏阴影
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewDismiss" object:nil userInfo:nil];
    }else if ([controllerName isEqualToString:@"gongsi"]){
        GongsiViewController *GVC = [[GongsiViewController alloc]init];
        [_mainNavigationController pushViewController:GVC animated:YES];
        //发送通知，隐藏阴影
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewDismiss" object:nil userInfo:nil];
    }else if ([controllerName isEqualToString:@"xiaoxi"]){
        DingYueXiaoXiViewController*dingyue=[[DingYueXiaoXiViewController alloc]init];
        dingyue.token = _token;
        dingyue.uid = _uid;
        [_mainNavigationController pushViewController:dingyue animated:YES];
        //发送通知，隐藏阴影
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewDismiss" object:nil userInfo:nil];
    }else if ([controllerName isEqualToString:@"dongtai"]){
       
        DongTaiViewController *DVC = [[DongTaiViewController alloc]init];
        DVC.token=_token;
        DVC.uid=_uid;
        [_mainNavigationController pushViewController: DVC animated:YES];
        //发送通知，隐藏阴影
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewDismiss" object:nil userInfo:nil];
    }else if ([controllerName isEqualToString:@"xiangmu"]){
        NewPingLunViewController *XVC = [[NewPingLunViewController alloc]init];
        XVC.token = _token;
        XVC.uid = _uid;
        [_mainNavigationController pushViewController:XVC animated:YES];
        //发送通知，隐藏阴影
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewDismiss" object:nil userInfo:nil];
    }else if ([controllerName isEqualToString:@"QQ"]){
        
        YouxiangBangdingViewController*QQ=[[YouxiangBangdingViewController alloc]init];
        QQ.token = _token;
        QQ.uid = _uid;
        [_mainNavigationController pushViewController:QQ animated:YES];
        
        //发送通知，隐藏阴影
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewDismiss" object:nil userInfo:nil];
    }else if ([controllerName isEqualToString:@"Phone"]){
        PhoneBangdingViewController*phone=[[PhoneBangdingViewController alloc]init];
        phone.token = _token;
        phone.uid = _uid;
        [_mainNavigationController pushViewController:phone animated:YES];
        //发送通知，隐藏阴影
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewDismiss" object:nil userInfo:nil];
    }else if ([controllerName isEqualToString:@"Zhanghao"]){
        ZhanghaoBandingViewController*Zhanghao=[[ZhanghaoBandingViewController alloc]init];
        Zhanghao.token = _token;
        Zhanghao.uid = _uid;
        [_mainNavigationController pushViewController:Zhanghao animated:YES];
        
        //发送通知，隐藏阴影
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewDismiss" object:nil userInfo:nil];
    }
}

- (void)dock:(Dock *)dock itemSelectedFrom:(int)from to:(int)to
{
    NSLog(@"%d - %d",from,to);
    if (from == 0&&from != to) {
        [MobClick endLogPageView:@"ToubiaoMainPage"];
        [_mainNavigationController.view removeFromSuperview];
        //导航栏
        _mainNavigationController = nil;
       
    }else if (from == 1&&from != to){
         [MobClick endLogPageView:@"XiaoxiViewController"];
          [_mainNavigationController.view removeFromSuperview];
        //导航栏
        _mainNavigationController = nil;
    }else if (from == 2&&from != to){
        [MobClick endLogPageView:@"StoreMainPage"];
          [_mainNavigationController.view removeFromSuperview];
        //导航栏
        _mainNavigationController = nil;
    }
    
    /*************************************/
    if (from == 0&&to == 0&&_number1 == 0) {
        //导航栏
        _tvc=  [TouBiaoViewController shareInstanceWithToken:_token uid:_uid];
        _mainNavigationController = [[MyNavigationController alloc]initWithRootViewController:_tvc];
        //[self.view insertSubview:_mainNavigationController.view belowSubview:_dock];
        [self.view addSubview:_mainNavigationController.view];
        //[tvc.view addSubview:_dock];
        
        [_tvc.view insertSubview:_dock belowSubview:_tvc.grayView];
        //弹出计时登录模态视图
        [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(loginModal) userInfo:nil repeats:NO];
        _number1 ++;
    }else if(from == to){
        
    
    }else{
        if (to == 0){
            //导航栏
            _tvc=  [TouBiaoViewController shareInstanceWithToken:_token uid:_uid];
             _tvc.ifModelNavigation = @"";
             _mainNavigationController = [[MyNavigationController alloc]initWithRootViewController:_tvc];
            //[self.view insertSubview:_mainNavigationController.view belowSubview:_dock];
            [self.view addSubview:_mainNavigationController.view];
            //[TVC.view addSubview:_dock];
            [_tvc.view insertSubview:_dock belowSubview:_tvc.grayView];
        }else if (to == 1){
            //导航栏
            _xvc= [XiaoXiViewController shareInstanceWithToken:_token uid:_uid];
            _xvc.ifModelNavigation = @"";
              _mainNavigationController = [[MyNavigationController alloc]initWithRootViewController:_xvc];
              //[self.view insertSubview:_mainNavigationController.view belowSubview:_dock];
            [self.view addSubview:_mainNavigationController.view];
            [_xvc.view addSubview:_dock];
            
           
        }else if (to == 2){
            //导航栏
            _svc = [ShouCangViewController shareInstanceWithToken:_token uid:_uid];
            _svc.ifModelNavigation = @"";
            _mainNavigationController = [[MyNavigationController alloc]initWithRootViewController:_svc];
            //[self.view insertSubview:_mainNavigationController.view belowSubview:_dock];
            [self.view addSubview:_mainNavigationController.view];
            [_svc.view addSubview:_dock];
         } 
    }
    [_mainNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbu@2x"] forBarMetrics:UIBarMetricsDefault];
    //[_mainNavigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.2902 green:0.6980 blue:0.8980 alpha:1]];
}

- (void)loginModal{
    if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"userDic1"]) {
        //存在，则替换之
        NSLog(@"直接登录");
        //[self showIntroWithCrossDissolve];
        
         NSMutableDictionary * resultDictionary = [[NSMutableDictionary alloc] init];
        [[WBBooksManager sharedInstance] readPlist:&resultDictionary];
        NSDictionary *userDic = [resultDictionary objectForKey:@"userDic1"];
        NSString *userName = [userDic objectForKey:@"userName"];
        NSString *passWord = [userDic objectForKey:@"mima"];
        NSString *userImage = [userDic objectForKey:@"image"];
        NSString *type = [userDic objectForKey:@"type"];
        
        if ([type isEqualToString:@"1"]) {  //QQ登录
            NSString *urlStr = [NSString stringWithFormat:@"%@user/third-login?type=QQ&uid=%@&nickname=%@&hpic=%@",ApiUrlHead,passWord,userName,userImage];
            //NSLog(@"urlStr = %@",urlStr);
            NSString *uslStr1 = [NSString stringWithFormat:@"%@user/third-login?",ApiUrlHead];
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"QQ",@"type",
                                        passWord,@"uid",
                                        userName,@"nickname",
                                        userImage,@"hpic",nil];
            [manager POST:uslStr1 parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                 NSDictionary *data = [responseObject objectForKey:@"data"];
                if ([code isEqualToString:@"0"]) {
                  [[NSNotificationCenter defaultCenter]postNotificationName:@"tokenGet" object:data userInfo:nil];
                        
                }else if (![code isEqualToString:@"0"]){
                    NSLog(@"error");
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"自动登录失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
                    [alert show];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                
            }];
            

            
        
        }else if([type isEqualToString:@"2"]){   //微信登录
            NSString *urlStr = [NSString stringWithFormat:@"%@user/third-login?type=webchat&uid=%@&nickname=%@&hpic=%@",ApiUrlHead,passWord,userName,userImage];
            NSString *uslStr1 = [NSString stringWithFormat:@"%@user/third-login?",ApiUrlHead];
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"webchat",@"type",
                                        passWord,@"uid",
                                        userName,@"nickname",
                                        userImage,@"hpic",nil];
            [manager POST:uslStr1 parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                 NSDictionary *data = [responseObject objectForKey:@"data"];
                if ([code isEqualToString:@"0"]) {
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"tokenGet" object:data userInfo:nil];
                    
                    
                    
                    
                }else if (![code isEqualToString:@"0"]){
                    NSLog(@"error");
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"自动登录失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
                    [alert show];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                
            }];
            

            
        
        }else if ([type isEqualToString:@"3"]){   //微博登录
            NSString *urlStr = [NSString stringWithFormat:@"%@user/third-login?type=weibo&uid=%@&nickname=%@&hpic=%@",ApiUrlHead,passWord,userName,userImage];
            NSString *uslStr1 = [NSString stringWithFormat:@"%@user/third-login?",ApiUrlHead];
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"weibo",@"type",
                                        passWord,@"uid",
                                        userName,@"nickname",
                                        userImage,@"hpic",nil];
            [manager POST:uslStr1 parameters:parameters success:^(AFHTTPRequestOperation * operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
               NSDictionary *data = [responseObject objectForKey:@"data"];
                if ([code isEqualToString:@"0"]) {
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"tokenGet" object:data userInfo:nil];
                    
                    
                    
                    
                }else if (![code isEqualToString:@"0"]){
                    NSLog(@"error");
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"自动登录失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
                    [alert show];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                
            }];
            
        }else{
            __block RequestXlJ  *request=[[RequestXlJ alloc]init];
            NSString*urlString=[NSString stringWithFormat:@"%@user/login?account=%@&password=%@",ApiUrlHead,userName,passWord];
            NSString *encoded = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [request requestWithUrl:encoded methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dic,NSArray *array){
                if (code == 0) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"tokenGet" object:dic userInfo:nil];
                    
                }else{
                    NSLog(@"error");
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"自动登录失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
                    [alert show];
                }
            }];
        }
        
    }else{//不存在，则写入
        NSLog(@"跳转到登录界面");
        //登录模态视图
        [self loginView];
        
    }
    
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self loginView];
    }
}
- (void)loginView{
    _controller1 = [[LoginViewController alloc] init];
    //_controller1.ifTheFirstLogin = @"dfsgd";
    MyNavigationController *controller = [[MyNavigationController alloc]initWithRootViewController:_controller1];
    [controller.navigationBar setBarTintColor:[UIColor colorWithRed:0.2902 green:0.6980 blue:0.8980 alpha:1]];
    //controller.navigationBarHidden = YES;
    controller.navigationBar.translucent = NO;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        controller.providesPresentationContextTransitionStyle = YES;
        controller.definesPresentationContext = YES;
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:controller animated:NO completion:nil];
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
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

//
//  geRenViewController.m
//  时时投
//
//  Created by h on 15/8/6.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "geRenViewController.h"
#import "ShezhiViewController.h"
#import "UIImageView+MJWebCache.h"
#import "FangkeViewController.h"
#import "JiFenViewController.h"
#import "GerenInfo_My_ViewController.h"
#import "GongsiViewController.h"
#import "LoginViewController.h"
#import "MyNavigationController.h"
#import "UIImageView+MJWebCache.h"
#import <ShareSDK/ShareSDK.h>
#import "WBBooksManager.h"

#import "ZhanghaoBandingViewController.h"
#import "QQbangdingViewController.h"
#import "PhoneBangdingViewController.h"

static geRenViewController *instance;
@interface geRenViewController ()
@property (strong, nonatomic)__block NSMutableArray *DataArray;
@end

@implementation geRenViewController{
   AFHTTPRequestOperationManager *manager;
}
+ (id)shareInstanceWithToken:(NSString *)token uid:(NSString *)uid
{
    if (instance == nil)
    {
        instance = [[[self class]alloc]init];
    }
    instance.token = token;
    instance.uid = uid;
    
    return instance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人";
    
    
    _userImage.userInteractionEnabled = YES;
    [_userImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserImage:)]];
    
    [self requestMyInfo];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMyInfo:) name:@"reloadMyInfo" object:nil]; //监听刷新我的个人数据
    
}
- (void)reloadMyInfo:(NSNotification *)notification{
    if (notification != nil) {
        NSDictionary *dic = notification.object;
        NSLog(@"dic = %@",dic);
        NSString *token = [NSString stringWithFormat:@"%@",[dic objectForKey:@"token"]];
        if (token.length > 10) {
            _token = [NSString stringWithFormat:@"%@",[dic objectForKey:@"token"]];
            _uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
            
        }
    }
    [self  requestMyInfo];
}
- (void)requestMyInfo{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@profile/info?base=1&access-token=%@",ApiUrlHead,_token];
    NSLog(@"=============_token = %@",_token);
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSDictionary *dic1 = [responseObject objectForKey:@"data"];
            
            NSString*img=[NSString stringWithFormat:@"%@",[dic1 objectForKey:@"headpic"]];
            //NSLog(@"img==========%@",img);
            //加了一张图没网的情况下
            //[_image setImageURL:[NSURL URLWithString:img] placeholder:[UIImage imageNamed:@"touxiang333333@2x"]];
            [_image setImageWithURL:[NSURL URLWithString:img]];
            NSString *STR = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"username"]];
           
            if ([STR isEqualToString:@""]||[STR isEqualToString:@"<null>"]) {
                _zhangHaoLable.text=@"设置账号";
                _zhangHaoLable.userInteractionEnabled = YES;
                [_zhangHaoLable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapzhangHaoLable:)]];
                
                
            }else{
                _zhangHaoLable.text=STR;
                _zhangHaoLable.userInteractionEnabled=NO;
                
            }
            NSString *mobileStr = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"mobile"]];
            if ([mobileStr isEqualToString:@""]||[mobileStr isEqualToString:@"<null>"]) {
                _phoneLable.text=@"绑定手机";
                _phoneLable.userInteractionEnabled=YES;
                [_phoneLable addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhoneLabel:) ]];
            }else{
                _phoneLable.text=mobileStr;
                _phoneLable.userInteractionEnabled=NO;
            }
            NSString*emailStr=[NSString stringWithFormat:@"%@",[dic1 objectForKey:@"email"]];
            if ([emailStr isEqualToString:@""]||[emailStr isEqualToString:@"<null>"]) {
                _QQlable.text=@"绑定邮箱";
                _QQlable.userInteractionEnabled=YES;
                [_QQlable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapQQLabel:)]];
                
            }else{
                _QQlable.text=emailStr;
                _QQlable.userInteractionEnabled=NO;
            }
            NSString*nameStr=[NSString stringWithFormat:@"%@",[dic1 objectForKey:@"realname"]];
             nameStr  = [nameStr stringByRemovingPercentEncoding];
            _name.text=nameStr;
            
            
            
            
            //判断给出的Key对应的数据是否存在
            if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"shezhi"]) {
                //存在，则替换之
                NSLog(@"存在，则替换之");
                [[WBBooksManager sharedInstance] replaceDictionary:dic1 withDictionaryKey:@"genrenggg"];
            }else{//不存在，则写入
                NSLog(@"不存在，则写入");
                [[WBBooksManager sharedInstance] writePlist:dic1 forKey:@"genrenggg"];
            }
            
        }else if (![code isEqualToString:@"0"]){
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];

}
-(void)tapQQLabel:(UITapGestureRecognizer*)tap{

    NSLog(@"QQ");
    
     [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"QQ" userInfo:nil];
//    QQbangdingViewController*QQ=[[QQbangdingViewController alloc]init];
//    [self.navigationController pushViewController:QQ animated:YES];
}
-(void)tapPhoneLabel:(UITapGestureRecognizer*)tap{
    NSLog(@"电话");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"Phone" userInfo:nil];
    
//    PhoneBangdingViewController*Phone=[[PhoneBangdingViewController alloc]init];
//    [self.navigationController pushViewController:Phone animated:YES];
    
}
- (void)tapzhangHaoLable:(UITapGestureRecognizer *)tap{
    NSLog(@"账号");
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"Zhanghao" userInfo:nil];
//    ZhanghaoBandingViewController*ZHVC= [[ZhanghaoBandingViewController alloc]init];
//    [self.navigationController pushViewController:ZHVC animated:YES];

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
- (void)tapUserImage:(UITapGestureRecognizer *)tap{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"mycenter" userInfo:nil];
}
- (IBAction)dongTaiButton:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"dongtai" userInfo:nil];
    
}
- (IBAction)LoginOut:(id)sender {
     [[WBBooksManager sharedInstance] removeBookWithKey:@"userDic1"];
    
    [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
    //[self reloadStateWithType:ShareTypeQQSpace];
    //2、微信
    [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
    //[self reloadStateWithType:ShareTypeWeixiSession];
    //3、微博
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    //登录模态视图
    LoginViewController *controller1 = [[LoginViewController alloc] init];
    controller1.ifLoginOut = @"hdgfkj";
    MyNavigationController *controller = [[MyNavigationController alloc]initWithRootViewController:controller1];
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
    /*1、隐藏主视图的阴影，
     2、消息、收藏回到未登录状态
     
     */
    
    _name.text = @"";
    _zhangHaoLable.text = @"";
    _phoneLable.text = @"";
    _QQlable.text = @"";
    _userImage.image = [UIImage imageNamed:@"touxiang2222@2x"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewDismiss" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginOutReloadXiaoxiAndShoucang" object:nil userInfo:nil];
}

- (IBAction)fangKeButton:(id)sender {
      [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"fangke" userInfo:nil];
}

- (IBAction)xiaoXiButton:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"xiaoxi" userInfo:nil];
}

- (IBAction)pingLunButton:(id)sender {
      [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"xiangmu" userInfo:nil];
}

- (IBAction)sheZhiButton:(id)sender {
    //设置
    [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"shezhi" userInfo:nil];
}
@end

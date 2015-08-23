//
//  ShareViewController.m
//  乐邦美食
//
//  Created by jimmy on 15/6/16.
//  Copyright (c) 2015年 jimmy. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareView.h"
#import <ShareSDK/ShareSDK.h>
#import "AppDelegate.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
@interface ShareViewController ()<UIAlertViewDelegate>
@property (nonatomic ,strong)id<ISSContent> publishContent;

@end

@implementation ShareViewController{
   __block  ShareView * shareview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    self.type = [NSString stringWithFormat:@"%@",[self.shareDic objectForKey:@"type"]];
    self.content = [NSString stringWithFormat:@"%@",[self.shareDic objectForKey:@"content"]];
    self.imageUrl = [NSString stringWithFormat:@"%@",[self.shareDic objectForKey:@"imageUrl"]];
    self.defaultContent = [NSString string];
    if ([self.type isEqualToString:@"1"]) {
        self.urlStr = [NSString stringWithFormat:@"http://web.lbcate.com/restaurant/restaurant!toRestaurantMobile.action?id=%@",[self.shareDic objectForKey:@"appoint_id"]];
        self.mytitle = [NSString stringWithFormat:@"%@",@"分享餐厅"];
        self.defaultContent = @"时尚餐厅";
    }else if ([self.type isEqualToString:@"2"]){
        self.urlStr = [NSString stringWithFormat:@"http://web.lbcate.com/dishes/dishes!toDishesMobile.action?id=%@",[self.shareDic objectForKey:@"appoint_id"]];
        self.mytitle = [NSString stringWithFormat:@"%@",@"分享菜品"];
        self.defaultContent = @"美味";
    }else if ([self.type isEqualToString:@"3"]){
        self.urlStr = [NSString stringWithFormat:@"http://web.lbcate.com/memberDynamic/memberDynamic!toMemberDynamic.action?id=%@",[self.shareDic objectForKey:@"appoint_id"]];
        self.mytitle = [NSString stringWithFormat:@"%@",@"我发现了一条好玩的随拍"];
        self.defaultContent = @"玩转随拍";
    }else if ([self.type isEqualToString:@"4"]){
        self.urlStr = [NSString stringWithFormat:@"http://web.lbcate.com/digest/digest!toDigest.action?id=%@",[self.shareDic objectForKey:@"appoint_id"]];
        self.mytitle = [NSString stringWithFormat:@"%@",@"分享美食攻略"];
        self.defaultContent = @"美食攻略";
    }
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon@2x"  ofType:@"png"];
    
    if (self.imageUrl.length > 0) {
        _publishContent = [ShareSDK content:@"维度"
                                           defaultContent:@"维度"
                                                    image:[ShareSDK imageWithUrl:@"http://pic26.nipic.com/20121223/9252150_195341264315_2.jpg"]
                                                    title:@"维度APP测试"
                                                      url:@"http://pic26.nipic.com/20121223/9252150_195341264315_2.jpg"
                                              description:nil
                                                mediaType:SSPublishContentMediaTypeNews];
    }else{
        _publishContent = [ShareSDK content:@"维度"
                            defaultContent:@"维度"
                                     image:[ShareSDK imageWithPath:imagePath]
                                     title:@"维度APP测试"
                                       url:@"http://pic26.nipic.com/20121223/9252150_195341264315_2.jpg"
                               description:nil
                                 mediaType:SSPublishContentMediaTypeNews];
    
    }
  
    shareview = [[ShareView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 240) buttonBlock:^(NSInteger index){
       //app_logo是图片名，png是图片格式
       //构造分享内容－－－－－－网络图片
       //本地图片
        if (index == 0) {
            NSLog(@"QQ空间");
            if ([QQApi isQQInstalled]) {
                id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                     allowCallback:YES
                                                                     authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                      viewDelegate:nil
                                                           authManagerViewDelegate:nil];
                
                
                
                [ShareSDK shareContent:_publishContent
                                  type:ShareTypeQQSpace
                           authOptions:authOptions
                         statusBarTips:YES
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    if (state == SSPublishContentStateSuccess)
                                    {
                                        NSLog(@"success");
                                    }
                                    else if (state == SSPublishContentStateFail)
                                    {
                                        NSLog(@"fail");
                                    }
                                }];

            }else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有安装QQ客户端" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                alertView.tag = 0;
                [alertView show];
            }
            
        }else if (index == 1){
            NSLog(@"QQ好友");
            if ([QQApi isQQInstalled]) {
                id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                     allowCallback:YES
                                                                     authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                      viewDelegate:nil
                                                           authManagerViewDelegate:nil];
                
                
                [ShareSDK shareContent:_publishContent
                                  type:ShareTypeQQ
                           authOptions:authOptions
                         statusBarTips:YES
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    if (state == SSPublishContentStateSuccess)
                                    {
                                        NSLog(@"success");
                                    }
                                    else if (state == SSPublishContentStateFail)
                                    {
                                        NSLog(@"fail");
                                    }
                                }];

            }else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有安装QQ客户端" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                alertView.tag = 1;
                [alertView show];
            
            }
            
        }else if (index == 2){
            NSLog(@"微信好友");
              if ([WXApi isWXAppInstalled]) {
                  id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                       allowCallback:YES
                                                                       authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                        viewDelegate:nil
                                                             authManagerViewDelegate:nil];
                  
                  
                  
                  [ShareSDK shareContent:_publishContent
                                    type:ShareTypeWeixiSession
                             authOptions:authOptions
                           statusBarTips:YES
                                  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                      
                                      if (state == SSPublishContentStateSuccess)
                                      {
                                          NSLog(@"success");
                                      }
                                      else if (state == SSPublishContentStateFail)
                                      {
                                          NSLog(@"fail");
                                      }
                                  }];
                  

                  
              }else{
                  UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有安装微信客户端" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                  alertView.tag = 2;
                  [alertView show];
              
              }
            
        }else if (index == 3){
            NSLog(@"微博");
            id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                 allowCallback:YES
                                                                 authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                  viewDelegate:nil
                                                       authManagerViewDelegate:nil];
            
            //在授权页面中添加关注官方微博
            /*[authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                            SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                            [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                            SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                            nil]];*/
            
            [ShareSDK shareContent:_publishContent
                              type:ShareTypeSinaWeibo
                       authOptions:authOptions
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"success");
                                    /*[UIView animateWithDuration:0.25 animations:^{shareview.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 240);} completion:nil];
                                    if (shareview.frame.origin.y == self.view.bounds.size.height) {
                                        //退出发布模态视图
                                       
                                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"分享成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alert show];
                                    }*/
                                    
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"fail");
                                    /*[UIView animateWithDuration:0.25 animations:^{shareview.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 240);} completion:nil];
                                    if (shareview.frame.origin.y == self.view.bounds.size.height) {
                                        //退出发布模态视图
                                        [self dismissModalViewControllerAnimated:YES];
                                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"分享失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                        [alert show];
                                    }*/
                                    
                                }
                            }];
           /* AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            authRequest.redirectURI = @"https://api.weibo.com/oauth2/default.html";
            authRequest.scope = @"myAll";
            NSLog(@"myDelegate.wbtoken = %@",myDelegate.wbtoken);
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
            request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
            request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
            [WeiboSDK sendRequest:request];*/
        }else{
            NSLog(@"朋友圈");
            if ([WXApi isWXAppInstalled]) {
                id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                     allowCallback:YES
                                                                     authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                      viewDelegate:nil
                                                           authManagerViewDelegate:nil];
                
                [ShareSDK shareContent:_publishContent
                                  type:ShareTypeWeixiTimeline
                           authOptions:authOptions
                         statusBarTips:YES
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    //NSLog(@"state ==== %u",state);
                                    if (state == SSPublishContentStateSuccess)
                                    {
                                        NSLog(@"success");
                                    }
                                    else if (state == SSPublishContentStateFail)
                                    {
                                        NSLog(@"fail");
                                    }
                                }];

                
                
            }else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有安装微信客户端" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                alertView.tag = 3;
                [alertView show];
            
            }
            
        }
    }];
    
    [UIView animateWithDuration:0.25 animations:^{shareview.frame = CGRectMake(0, self.view.bounds.size.height - 240, self.view.bounds.size.width, 240);} completion:nil];
    [self.view addSubview:shareview];
    
    UIControl *control = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - shareview.bounds.size.height)];
    [control addTarget:self action:@selector(hideControl) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
}

#pragma Internal Method

- (WBMessageObject *)messageToShare
{
   //NSLog(@"self.content = %@,self.mytitle = %@",self.content,self.mytitle);
   WBMessageObject *message = [WBMessageObject message];
   WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = @"identifier1";
        webpage.title =  NSLocalizedString(self.content, nil);
        webpage.description =  [NSString stringWithFormat:NSLocalizedString(self.mytitle, nil), [[NSDate date] timeIntervalSince1970]];
        webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon@2x" ofType:@"png"]];
        webpage.webpageUrl = self.urlStr;
        message.mediaObject = webpage;
    
    return message;
}



- (void)hideControl{
   [UIView animateWithDuration:0.25 animations:^{shareview.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 240);} completion:nil];
    if (shareview.frame.origin.y == self.view.bounds.size.height) {
        //退出发布模态视图
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark -- alertView代理
/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0||alertView.tag == 1) {  //跳转到苹果商城下载QQ
        if (buttonIndex == 0)
        {
            NSLog(@"取消评论");
        }
        else
        {
            NSLog(@"给好评");
            //990170805是程序的Apple ID,
            NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id990170805"];  //只针对IOS7及以上版本
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            
        }
        
    }else{    //跳转到苹果商城下载微信
        if (buttonIndex == 0)
        {
            NSLog(@"取消评论");
        }
        else
        {
            NSLog(@"给好评");
            //990170805是程序的Apple ID,
            NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id990170805"];  //只针对IOS7及以上版本
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            
        }
    
    }


}
*/
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

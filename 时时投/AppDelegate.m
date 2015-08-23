//
//  AppDelegate.m
//  时时投
//
//  Created by 熊良军 on 15/8/3.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "RenmaiViewController.h"
#import "TouBiaoViewController.h"
#import "ShouCangViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "XiaoXiViewController.h"
#import "LoginViewController.h"
#import "geRenViewController.h"
#import "MobClick.h"
#import <SMS_SDK/SMS_SDK.h>
#define UMENG_APPKEY @"55c9ad88e0f55a095d00285d"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)umengTrack {
    //[MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    [MobClick updateOnlineConfig];  //在线参数配置
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
    /* Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    */
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
    
}

- (void)shareSDK_init{
    //微信
    //[WXApi registerApp:@"wxf87374d4d536653f"]; //此方法已经测试成功
    [WXApi registerApp:@"wxf87374d4d536653f" withDescription:@"weixin"];
    [ShareSDK registerApp:@"9d2fcc5bb72e"];//字符串api20为您的ShareSDK的AppKey
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [WeiboSDK registerApp:@"1684301330"];
    [ShareSDK connectSinaWeiboWithAppKey:@"1684301330"
                               appSecret:@"bb893231472b48a1e9bba64f371e958d"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"1684301330"
                                appSecret:@"bb893231472b48a1e9bba64f371e958d"
                              redirectUri:@"https://api.weibo.com/oauth2/default.html"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1104599456"
                           appSecret:@"2RXNeNdT4hsLOr2g"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"1104599456"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    /*[ShareSDK connectWeChatWithAppId:@"wxf87374d4d536653f"
     wechatCls:[WXApi class]];*/
    [ShareSDK connectWeChatWithAppId:@"wxf87374d4d536653f"
                           appSecret:@"49161ed663cb05bf80400e43dfc7b146"
                           wechatCls:[WXApi class]];
    [ShareSDK importWeChatClass:[WXApi class]];

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    [NSThread sleepForTimeInterval:2];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];  //修改导航栏标题颜色
    // 显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
    //shareSDK集成
    [self shareSDK_init];
    //集成短信验证码
    [SMS_SDK registerApp:@"9a0f983fcfd1" withSecret:@"d2738a6540d3d36a4078b05cd4bf2226"];
    
    
    MainViewController *mvc = [[MainViewController alloc]init];
    geRenViewController *lvc = [[geRenViewController alloc]init];
    _siderViewController = [[YRSideViewController alloc]init];
    _siderViewController.rootViewController = mvc;
    _siderViewController.leftViewController = lvc;
    _siderViewController.needSwipeShowMenu = NO;
    _siderViewController.showBoundsShadow = true;
    self.window.rootViewController = _siderViewController;
    
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self] ||
    [WXApi handleOpenURL:url delegate:self]||[WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self]||[WXApi handleOpenURL:url delegate:self]||[WeiboSDK handleOpenURL:url delegate:self];
}
#pragma mark - WXApiDelegate

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req{
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if ([aresp.state isEqualToString:@"0744"]) {
            NSString *code = [NSString string];
            if (aresp.errCode == 0) {
                code = aresp.code;
                NSDictionary *dic = @{@"code":code};
                code = [dic objectForKey:@"code"];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"weixinLogin" object:code userInfo:nil];
        }
    }
}

@end

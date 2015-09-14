//
//  XiaoXiViewController.m
//  dayang
//
//  Created by chendong on 15/7/20.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "XiaoXiViewController.h"
#import "XiaoXiCustomTableViewCell.h"
//#import "XiaoxiSosuoViewController.h"
#import "AppDelegate.h"
#import "HuoDongViewController.h"
#import "LunTanTableViewController.h"
#import "daiChuLiViewController.h"
#import "FootTabelView.h"
#import "DingYueXiaoXiViewController.h"
#import "ChatViewController.h"
#import "MyItemButton.h"
#import "NewPingLunViewController.h"
#import "UIImageView+MJWebCache.h"
#import "TimeXLJ.h"
#import "WBBooksManager.h"
#import "RequestXlJ.h"
#import "GerenInfoViewController.h"
static XiaoXiViewController *instance;
@interface XiaoXiViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UIAlertViewDelegate>
{
    UITableView * _myTableView;//自定义tableView
    NSMutableArray * _imaArr;//存储图片的数组
    NSMutableArray*_lableArr;//存储名字
    UISearchDisplayController * _displayCtr;
    NSMutableArray *chatList;
    AFHTTPRequestOperationManager *manager;
    LoadingViewXLJ *_loadingView;
}
@property (strong, nonatomic)FootTabelView * foot;
@end

@implementation XiaoXiViewController
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
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //数组初始化
        _imaArr = [[NSMutableArray alloc]init];
        _lableArr=[[NSMutableArray alloc]init];
        chatList = [NSMutableArray array];
        manager = [AFHTTPRequestOperationManager manager];
        
        self.navigationItem.title = @"消息";
        UIImage *backImg = [UIImage imageNamed:@"genrenzhongxin@2x"];
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 25,25)];
        [backBtn setImage:backImg forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(push1) forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = backBarBtn;
        
        /*UIImage *backImg1 = [UIImage imageNamed:@"dingbu2@2x"];
        UIButton *backBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 25,25)];
        [backBtn1 setImage:backImg1 forState:UIControlStateNormal];
        [backBtn1 addTarget:self action:@selector(push2) forControlEvents:UIControlEventTouchUpInside];
//        [backBtn1 setImage:backImg1 forState:UIControlStateNormal];
//        UIView *backBtnView1 = [[UIView alloc] initWithFrame:backBtn1.bounds];
//        backBtnView1.bounds = CGRectOffset(backBtnView.bounds, -20, 0);
//        [backBtnView1 addSubview:backBtn1];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn1];
        self.navigationItem.rightBarButtonItem = rightItem;*/
    }
    return self;
}
-(void)push1{
    //NSLog(@"_lestButton.frame = %f ,%f ,%f ,%f ",_lestButton.frame.origin.x,_lestButton.frame.origin.y,_lestButton.frame.size.width,_lestButton.frame.size.height);
    if (_token.length > 10) {
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        YRSideViewController *sideViewController = [delegate siderViewController];
        //sideViewController.needSwipeShowMenu = true;
        [sideViewController showLeftViewController:YES];
       
        //显示主界面半透明视图
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewAppear" object:nil userInfo:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还尚未登录，是否登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self loginViewshow1];
    }
    
}
- (void)loginViewshow1{
    
    //登录模态视图
    LoginViewController *controller1 = [[LoginViewController alloc] init];
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
}
-(void)push2{

    
}
- (void)viewDidAppear:(BOOL)animated{
    if (_ifModelNavigation.length > 0) {  //xianshicehua
        [[NSNotificationCenter defaultCenter]postNotificationName:@"xianshicehua" object:nil userInfo:nil];
    }
    
    _ifModelNavigation = @"";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //读取数据
    [self creadData];
    
    [self addViews];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tokenGet:) name:@"tokenGet" object:nil]; //监听获取token
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LoginOutStatus:) name:@"loginOutReloadXiaoxiAndShoucang" object:nil]; //退出登录状态
}
#pragma mark -- 退出登录状态
- (void)LoginOutStatus:(NSNotification *)notification{
    NSArray *subViewArr = self.view.subviews;
    for (UIView *view in subViewArr) {
        if (view.tag != 100) {
            [view removeFromSuperview];
        }
        
    }
    
}
//刷新界面
- (void)tokenGet:(NSNotification *)notification{
    NSDictionary *dic = notification.object;
    NSLog(@"dic22 = %@",dic);
    _token = @"";
    _uid = @"";
    _token = [NSString stringWithFormat:@"%@",[dic objectForKey:@"token"]];
    _uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
    if (_token.length < 10) {
        NSArray *subViewArr = self.view.subviews;
        for (UIView *view in subViewArr) {
            if (view.tag != 100) {
                [view removeFromSuperview];
            }
            
        }
    }else{
        [self addViews];
        _loadingView = [[LoadingViewXLJ alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 200)*0.5, self.view.bounds.size.height*0.5 - 120, 200,100) title:@"正在加载，请稍后。。。"];
        [self.view addSubview:_loadingView];
        NSString *message = [NSString stringWithFormat:@"%@message/ulist?access-token=%@",ApiUrlHead,_token];
        NSLog(@"message = %@",message);
        [manager GET:message parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"JSON: %@", responseObject);
            [_loadingView removeFromSuperview];
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSArray *data = [responseObject objectForKey:@"data"];
                [chatList removeAllObjects];
                [chatList addObjectsFromArray:data];
                [_myTableView reloadData];
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                NSLog(@"error=%@",error);
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [_loadingView removeFromSuperview];
            //网络不佳视图
            InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height * 0.75, self.view.bounds.size.width - 180, 25)];
            [self.view addSubview:errorView];
        }];
        

    }
  
}
- (void)addViews{
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height -49) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_myTableView registerNib:[UINib nibWithNibName:@"XiaoXiCustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
    [self.view addSubview:_myTableView];
    
    //    UISearchBar * searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    //    _myTableView.tableHeaderView = searchBar;
    //    _displayCtr = [[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
    _foot = [[NSBundle mainBundle] loadNibNamed:@"FootTabelView" owner:self options:0][0];
    _myTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    _myTableView.tableFooterView.userInteractionEnabled = YES;
    _myTableView.tableFooterView = _foot;
    //去掉tableivew的多余线
    _myTableView.tableFooterView=[[UIView alloc]init];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    
    if (_token.length < 10) {
        NSArray *subViewArr = self.view.subviews;
        for (UIView *view in subViewArr) {
            if (view.tag != 100) {
                [view removeFromSuperview];
            }
            
        }
       UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还尚未登录，是否登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
       [alertView show];
    }else{
        [self addViews];
        _loadingView = [[LoadingViewXLJ alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 200)*0.5, self.view.bounds.size.height*0.5 - 120, 200,100) title:@"正在加载，请稍后。。。"];
        [self.view addSubview:_loadingView];
        NSString *message = [NSString stringWithFormat:@"%@message/ulist?access-token=%@",ApiUrlHead,_token];
        NSLog(@"message = %@",message);
        [manager GET:message parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"JSON: %@", responseObject);
            [_loadingView removeFromSuperview];
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSArray *data = [responseObject objectForKey:@"data"];
                [chatList removeAllObjects];
                [chatList addObjectsFromArray:data];
                [_myTableView reloadData];
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                NSLog(@"error=%@",error);
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [_loadingView removeFromSuperview];
            //网络不佳视图
            InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height * 0.75, self.view.bounds.size.width - 180, 25)];
            [self.view addSubview:errorView];
        }];
        

    }
    
    //初始化数据，判断给出的Key对应的数据是否存在,若不存在，则重新加载
    if (![[WBBooksManager sharedInstance] isBookExistsForKey:@"Article"]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@article/fitems",ApiUrlHead];
        RequestXlJ *_request = [[RequestXlJ alloc]init];
        [_request requestWithUrl:urlStr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary * responseObject,NSArray *array){
            //NSLog(@"code = %li",(long)code);
            //NSLog(@"responseObject = %@",responseObject);
            NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
            [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"Article"];
        }];
    }
    
      [MobClick beginLogPageView:@"XiaoxiViewController"];
}

- (void)creadData{
   // _imaArr = [@[@"dingyu@2x.png",@"huodong@2x.png",@"speech-bubble-2@2x"] mutableCopy];
    _imaArr = [@[@"dingyu@2x.png",@"speech-bubble-2@2x"] mutableCopy];
    _lableArr=[@[@"订阅消息",@"项目评论"]mutableCopy];
    
}
#pragma mark ----- tableview分割线从顶点开始
//******tableview分割线从顶点开始********************
-(void)viewDidLayoutSubviews
{
    if ([_myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_myTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_myTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark -tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"%lu   %lu",(unsigned long)_imaArr.count,(unsigned long)chatList.count);
    return _imaArr.count + chatList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XiaoXiCustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (indexPath.row < 2) {
        cell.headImg.image = [UIImage imageNamed:_imaArr[indexPath.row]];
        cell.headMessageName.text = [_lableArr objectAtIndex:indexPath.row];
        cell.messageInfo.text = @"";
        cell.time.text = @"";
    }else{
      
        NSString *imageUrl = [NSString stringWithFormat:@"%@",[[chatList objectAtIndex:indexPath.row - 2]objectForKey:@"headpic"]];
        [cell.headImg setImageURLStr:imageUrl placeholder:placeImage];
        cell.headImg.tag = indexPath.row;
        cell.headImg.userInteractionEnabled = YES;
       [cell.headImg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectUserImage:)]];
        
        
        NSString *userName = [[chatList objectAtIndex:indexPath.row - 2]objectForKey:@"realname"];
        userName = [userName stringByRemovingPercentEncoding];
        
        cell.headMessageName.text = userName;
        NSString *messageInfo = [[chatList objectAtIndex:indexPath.row - 2]objectForKey:@"message"];
        cell.messageInfo.text = [messageInfo stringByRemovingPercentEncoding];
        cell.time.text = [TimeXLJ returnUploadTime_no1970:[NSString stringWithFormat:@"%@",[[chatList objectAtIndex:indexPath.row - 2]objectForKey:@"stime"]]];
    }
    return cell;
}
- (void)selectUserImage:(UITapGestureRecognizer *)tap{
    GerenInfoViewController *GVC = [[GerenInfoViewController alloc]init];
    GVC.token = _token;
    GVC.uid = [NSString stringWithFormat:@"%@",[[chatList objectAtIndex:tap.view.tag - 2]objectForKey:@"user_id"]];
    [self.navigationController pushViewController:GVC animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        DingYueXiaoXiViewController *dingyue=[[DingYueXiaoXiViewController alloc]init];
        dingyue.token = _token;
        dingyue.uid = _uid;
        [self.navigationController pushViewController:dingyue animated:YES];
    }else if (indexPath.row == 1){
        NewPingLunViewController*pinglun=[[NewPingLunViewController alloc]init];
        pinglun.token = _token;
        pinglun.uid = _uid;
        [self.navigationController pushViewController:pinglun animated:YES];
       
   }else{
        ChatViewController *dingye=[[ChatViewController alloc]init];
        dingye.uid = _uid;
        dingye.token = _token;
        dingye.realname = [[chatList objectAtIndex:indexPath.row - 2] objectForKey:@"realname"];
        dingye.user_id = [NSString stringWithFormat:@"%@",[[chatList objectAtIndex:indexPath.row - 2] objectForKey:@"user_id"]];
        [self.navigationController pushViewController:dingye animated:YES];
    }

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

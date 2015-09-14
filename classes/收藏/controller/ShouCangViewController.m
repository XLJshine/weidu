//
//  ShouCangViewController.m
//  dayang
//
//  Created by chendong on 15/7/20.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "ShouCangViewController.h"
#import "ToubiaoTableViewCell.h"
#import "MyShouCangTableViewCell.h"
#import "AppDelegate.h"
#import "MyItemButton.h"
#import "XiangmuPinglinButton.h"
#import "MobClick.h"
#import "ToubiaoDetailViewController.h"

#import "TimeXLJ.h"

#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MJChiBaoZiFooter.h"
#import "WBBooksManager.h"
static ShouCangViewController *instance;
@interface ShouCangViewController ()<UITableViewDataSource,UITableViewDelegate,ShouCangTableViewCellDelegate,UIAlertViewDelegate>

@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic ,strong)NSMutableArray *dataArray;

@property (strong, nonatomic)NSMutableArray *DataArray;
@property (strong, nonatomic)UIView * tanChuangView;
@property (strong, nonatomic)XiangmuPinglinButton *shoucanButton;
@property (strong, nonatomic)XiangmuPinglinButton *fenxiangButton;

@property (strong, nonatomic)NSMutableArray *zanNumArray;    //赞的个数数组
@property (strong, nonatomic)NSMutableArray *liulanNumArray;    //浏览的个数数组
@property (strong, nonatomic)NSMutableArray *commentNumArray;    //评论的个数数组
@property (strong, nonatomic)NSMutableArray *zanedNumArray;    //是否已经赞过

@property (assign, nonatomic)NSInteger titleFont;    //标题字号
@property (assign, nonatomic)NSInteger lableFont;    //标签字号
@property (assign, nonatomic)NSInteger detailFont;      //内容字号
@property (assign, nonatomic)NSInteger titleSepFont;    //标题间距
@property (assign, nonatomic)NSInteger detailSepFont;      //内容间距

@end

@implementation ShouCangViewController{

    AFHTTPRequestOperationManager *manager;
       // NSDictionary * _DataArray;//存储数据
    NSInteger pageNum;
    MJChiBaoZiFooter *footer;
    NSInteger tanchuanTag;
    NSInteger indexPath_rowNum;   //跳转到投标详细页面的标示，检测浏览数，评论数的改变
    LoadingViewXLJ *_loadingView;
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
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
        NSString *urlStr = [NSString stringWithFormat:@"%@article/list?access-token=%@&page=1&psize=10&fav=1",ApiUrlHead,_token];
        //NSLog(@"=============_token = %@",_token);
        manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_loadingView removeFromSuperview];
            //NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                [_DataArray removeAllObjects];
                NSArray *arr = [responseObject objectForKey:@"data"];
                
                [_zanNumArray removeAllObjects];
                [_liulanNumArray removeAllObjects];
                [_commentNumArray removeAllObjects];
                [_zanedNumArray removeAllObjects];
                for (int i  = 0; i < arr.count; i ++) {
                    [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zans"]]];
                    [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"views"]]];
                    [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"comments"]]];
                    [_zanedNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zaned"]]];
                }
                
                [_DataArray addObjectsFromArray:arr];
                //NSLog(@"_DataArray===========%@",_DataArray);
                if (arr.count >= 10) {
                    //设置footer
                    _tableview.footer = footer;
                }
                
                [_tableview reloadData];
            }else if (![code isEqualToString:@"0"]){
                
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [_loadingView removeFromSuperview];
            //网络不佳视图
            InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height * 0.75, self.view.bounds.size.width - 180, 25)];
            [self.view addSubview:errorView];
        }];
        
        //读取字体大小
        [self readTextFont];
        [_tableview reloadData];
    }
    // this UIViewController is about to re-appear, make sure we remove the current selection in our table view
    NSIndexPath *tableSelection = [self.tableview indexPathForSelectedRow];
    [self.tableview deselectRowAtIndexPath:tableSelection animated:NO];
    [MobClick beginLogPageView:@"StoreMainPage"];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self loginViewshow1];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"StoreMainPage"];
}
- (void)readTextFont{
    if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"Font"]) {
        //读取字体
        NSMutableDictionary * resultDictionary = [[NSMutableDictionary alloc] init];
        [[WBBooksManager sharedInstance] readPlist:&resultDictionary];
        NSDictionary *fontDic = [resultDictionary objectForKey:@"Font"];
        NSString *titleFont = [fontDic objectForKey:@"titleFont"];
        NSString *lableFont = [fontDic objectForKey:@"lableFont"];
        NSString *detailFont = [fontDic objectForKey:@"detailFont"];
        NSString *titleSepFont = [fontDic objectForKey:@"titleSepFont"];
        NSString *detailSepFont = [fontDic objectForKey:@"detailSepFont"];
        _titleFont = [titleFont integerValue];
        _lableFont = [lableFont integerValue];
        _detailFont = [detailFont integerValue];
        _titleSepFont = [titleSepFont integerValue];
        _detailSepFont = [detailSepFont integerValue];
        
    }else{
        _titleFont = 19;
        _lableFont = 12;
        _detailFont = 14;
        _titleSepFont = 8;
        _detailSepFont = 10;
    }
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"收藏";
        
        UIImage *backImg = [UIImage imageNamed:@"genrenzhongxin@2x"];
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 25,25)];
        [backBtn setImage:backImg forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(push1) forControlEvents:UIControlEventTouchUpInside];
        //        [backBtn setImage:backImg forState:UIControlStateNormal];
        //        UIView *backBtnView = [[UIView alloc] initWithFrame:backBtn.bounds];
        //        backBtnView.bounds = CGRectOffset(backBtnView.bounds, 10, 0);
        //        [backBtnView addSubview:backBtn];
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
        //self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
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
        alertView.tag = 2;
        [alertView show];
        
        
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
- (void)addViews{
    pageNum = 1;
    
    _dataArray = [[NSMutableArray alloc]initWithObjects:@"1",@"1",@"1",@"1",@"1", nil];
    _DataArray = [NSMutableArray array];
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 49)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.tag = 1;
    [self.view addSubview:_tableview];
    UIView *footview = [[UIView alloc]init];
    footview.backgroundColor = [UIColor whiteColor];
    _tableview.tableFooterView = footview;
   
    _tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        pageNum = 1;
        NSString *urlStr = [NSString stringWithFormat:@"%@article/list?access-token=%@&page=1&psize=10&fav=1",ApiUrlHead,_token];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSArray *arr = [responseObject objectForKey:@"data"];
                [_DataArray removeAllObjects];
                [_zanNumArray removeAllObjects];
                [_liulanNumArray removeAllObjects];
                [_commentNumArray removeAllObjects];
                [_zanedNumArray removeAllObjects];
                for (int i  = 0; i < arr.count; i ++) {
                    [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zans"]]];
                    [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"views"]]];
                    [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"comments"]]];
                    [_zanedNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zaned"]]];
                }
                if (arr.count >= 10) {
                    //设置footer
                    _tableview.footer = footer;
                }else{
                    [_tableview.footer removeFromSuperview];
                
                }
                [_DataArray addObjectsFromArray:arr];
                [_tableview reloadData];
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                NSLog(@"error=%@",error);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                [alert show];
                [_tableview reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            //网络不佳视图
            InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height * 0.75, self.view.bounds.size.width - 180, 25)];
            [self.view addSubview:errorView];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [_tableview.header endRefreshing];
        });
    }];
    
    //设置自动切换透明度(在导航栏下面自动隐藏)
    _tableview.header.autoChangeAlpha = YES;
    //上拉刷新
    /*_tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
     // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     // 结束刷新
     [_tableview.footer endRefreshing];
     });
     }];*/
    footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 当上拉刷新控件出现50%时（出现一半），就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新）
    //    footer.appearencePercentTriggerAutoRefresh = 0.5;
    // 隐藏刷新状态的文字
    footer.refreshingTitleHidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.tabBarController.tabBar.hidden = YES;
    _zanNumArray = [NSMutableArray array];
    _liulanNumArray = [NSMutableArray array];
    _commentNumArray = [NSMutableArray array];
    _zanedNumArray = [NSMutableArray array];
    
    [self addViews];
     //读取字体大小
    [self readTextFont];
    
    _tanChuangView = [[UIView alloc]init];   //分享收藏弹窗
    _tanChuangView.hidden = YES;
    _fenxiangButton = [[XiangmuPinglinButton alloc]init];
    [_fenxiangButton setTitle:@"分享" forState:UIControlStateNormal];
    [_fenxiangButton setBackgroundColor:[UIColor clearColor]];
    [_fenxiangButton setImage:[UIImage imageNamed:@"fenfen1@2x"] forState:UIControlStateNormal];
    _fenxiangButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [_fenxiangButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _fenxiangButton.tag = 0;
    [_fenxiangButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    [_tanChuangView addSubview:_fenxiangButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(numHaveChanged:) name:@"ShoucangNumHaveChanged" object:nil];   //监听评论数和
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LoginReloadData:) name:@"tokenGet" object:nil]; //监听获取token
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
//登录刷新界面
- (void)LoginReloadData:(NSNotification *)notification{
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
        NSString *urlStr = [NSString stringWithFormat:@"%@article/list?access-token=%@&page=1&psize=10&fav=1",ApiUrlHead,_token];
        NSLog(@"=============_token = %@",_token);
        manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_loadingView removeFromSuperview];
            //NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                [_DataArray removeAllObjects];
                NSArray *arr = [responseObject objectForKey:@"data"];
                
                [_zanNumArray removeAllObjects];
                [_liulanNumArray removeAllObjects];
                [_commentNumArray removeAllObjects];
                [_zanedNumArray removeAllObjects];
                for (int i  = 0; i < arr.count; i ++) {
                    [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zans"]]];
                    [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"views"]]];
                    [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"comments"]]];
                    [_zanedNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zaned"]]];
                }
                
                [_DataArray addObjectsFromArray:arr];
                //NSLog(@"_DataArray===========%@",_DataArray);
                if (arr.count >= 10) {
                    //设置footer
                    _tableview.footer = footer;
                }
                
                [_tableview reloadData];
            }else if (![code isEqualToString:@"0"]){
                
                
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
- (void)numHaveChanged:(NSNotification *)notification{
    NSString *commonedNum = notification.object;
    NSString *commonedNum1 = [NSString stringWithFormat:@"%@",[_commentNumArray objectAtIndex:indexPath_rowNum]];
    NSInteger c1 = [commonedNum integerValue];
    NSInteger c2 = [commonedNum1 integerValue];
    NSInteger c3 = c1 + c2;
    NSString *commonedNum2 = [NSString stringWithFormat:@"%li",(long)c3];
    [_commentNumArray replaceObjectAtIndex:indexPath_rowNum withObject:commonedNum2];
    
    NSString *liulanNum1 = [_liulanNumArray objectAtIndex:indexPath_rowNum];
    NSInteger l1 = [liulanNum1 integerValue];
    NSInteger l3 = l1 + 1;
    NSString *liulanNum2 = [NSString stringWithFormat:@"%li",(long)l3];
    [_liulanNumArray replaceObjectAtIndex:indexPath_rowNum withObject:liulanNum2];
    // 刷新该行
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:indexPath_rowNum inSection:0];
    [_tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tokenGet:) name:@"tokenGet" object:nil]; //监听获取token
}

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
        NSString *urlStr = [NSString stringWithFormat:@"%@article/list?access-token=%@&page=1&psize=10&fav=1",ApiUrlHead,_token];
        NSLog(@"=============_token = %@",_token);
        manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_loadingView removeFromSuperview];
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                [_DataArray removeAllObjects];
                NSArray *arr = [responseObject objectForKey:@"data"];
                
                [_zanNumArray removeAllObjects];
                [_liulanNumArray removeAllObjects];
                [_commentNumArray removeAllObjects];
                [_zanedNumArray removeAllObjects];
                for (int i  = 0; i < arr.count; i ++) {
                    [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zans"]]];
                    [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"views"]]];
                    [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"comments"]]];
                    [_zanedNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zaned"]]];
                }
                
                [_DataArray addObjectsFromArray:arr];
                NSLog(@"_DataArray===========%@",_DataArray);
                if (arr.count >= 10) {
                    //设置footer
                    _tableview.footer = footer;
                }
                
                [_tableview reloadData];
            }else if (![code isEqualToString:@"0"]){
                
                
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

- (void)loadMoreData{
    //1.添加数据
    pageNum ++;
     NSString *urlStr = [NSString stringWithFormat:@"%@article/list?access-token=%@&page=%li&psize=10&fav=1",ApiUrlHead,_token,(long)pageNum];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *data = [responseObject objectForKey:@"data"];
            [_DataArray addObjectsFromArray:data];
            
            for (int i  = 0; i < data.count; i ++) {
                [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i] objectForKey:@"zans"]]];
                [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i] objectForKey:@"views"]]];
                [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[data objectAtIndex:i] objectForKey:@"comments"]]];
                NSString *zaned11  = [NSString stringWithFormat:@"%@",[[data objectAtIndex:i] objectForKey:@"zaned"]];
                if ([zaned11 isEqualToString:@"1"]) {
                   [_zanedNumArray addObject:@"1"];
                }else{
                   [_zanedNumArray addObject:@"0"];
                }
                
            }
            if (data.count >= 10) {
                //设置footer
                _tableview.footer = footer;
            }else{
                [_tableview.footer removeFromSuperview];
                
            }
            
            [_tableview reloadData];
        }else if (![code isEqualToString:@"0"]){
            NSString *error = [responseObject objectForKey:@"err"];
            NSLog(@"error=%@",error);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
            [alert show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        //网络不佳视图
        InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height * 0.75, self.view.bounds.size.width - 180, 25)];
        [self.view addSubview:errorView];
    }];
    
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        //刷新表格
        //[_tableview reloadData];
        //拿到当前的上拉刷新控件，结束刷新状态
        [_tableview.footer endRefreshing];
    });
}


#pragma mark -tableViewDelegate
/*- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return _tableview.tag;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //判断表格是否需要删除数据
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_dataArray removeObjectAtIndex:indexPath.row];
        [_tableview deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
        
     }
}*/
#pragma mark ----- tableview分割线从顶点开始
//******tableview分割线从顶点开始********************
-(void)viewDidLayoutSubviews
{
    if ([_tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
//******tableview分割线********************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _DataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LableXLJ *title = [[LableXLJ alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 45) text:[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"title"] textColor:[UIColor colorWithWhite:0 alpha:1] font:(int)_titleFont - 2 numberOfLines:2 lineSpace:(int)_titleSepFont - 2];
    CGFloat h1 = title.bounds.size.height;
    title = nil;
    //NSLog(@"h1 = %f",h1);
    
    return h1 + 60;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier1 = @"statusCell2";
    MyShouCangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    
    if (cell == nil) {
        cell = [[MyShouCangTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1 title:[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"title"]
                                                   hangye:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row ] objectForKey:@"trades"]] location:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row ] objectForKey:@"area"]] time:[TimeXLJ returnUploadTime_no1970:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"created_at"]]] detail:@""   titleFont:_titleFont  - 2 lableFont:_lableFont titleSepFont:_titleSepFont - 2];
    }else{
        [cell.tanChuangView removeFromSuperview];
    [cell title:[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"title"]
         hangye:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row ] objectForKey:@"trades"]]
       location:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row ] objectForKey:@"area"]]
           time:[TimeXLJ returnUploadTime_no1970:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"created_at"]]]
         detail:@""
      titleFont:_titleFont - 2
      lableFont:_lableFont
   titleSepFont:_titleSepFont - 2];
    }
   
    NSString *zaned = [_zanedNumArray objectAtIndex:indexPath.row];
    NSLog(@"zaned = %@",zaned);
    if ([zaned isEqualToString:@"1"]) {
        [cell.zanbtn setImage:[UIImage imageNamed:@"zaned_Img@2x"] forState:UIControlStateNormal];
    }else{
        [cell.zanbtn setImage:[UIImage imageNamed:@"zhaobiaozan@2x"] forState:UIControlStateNormal];
    }
    
    [cell.zanbtn setTitle:[_zanNumArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [cell.liulanbtn setTitle:[_liulanNumArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [cell.pinglunbtn setTitle:[_commentNumArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
     //__block int number1 = 0;
    [cell blockButtonAction:^(NSInteger index,NSInteger selectNum){
        NSLog(@"index = %li,indexPath.row = %li",(long)index,(long)indexPath.row);
        if (index == 0) {
            NSString *str = [_zanedNumArray objectAtIndex:indexPath.row];
            if ([str isEqualToString:@"1"]) {
                
                [cell.zanbtn setImage:[UIImage imageNamed:@"zhaobiaozan@2x"] forState:UIControlStateNormal];
                //取消点赞
                NSString *urlStr = [NSString stringWithFormat:@"%@zan/article-cancel?id=%@&access-token=%@",ApiUrlHead,[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"id"]],_token];
                NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [manager GET:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                    NSString *err = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"err"]];
                    if ([code isEqualToString:@"0"]) {
                        NSLog(@"取消点赞成功！");
                        [_zanedNumArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
                        NSString *str = [_zanNumArray objectAtIndex:indexPath.row];
                        int x = [str intValue];
                        x --;
                        
                        [_zanNumArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%i",x]];
                        
                        [cell.zanbtn setTitle:[NSString stringWithFormat:@"%i",x] forState:UIControlStateNormal];
                        
                        
                        
                    }else if (![code isEqualToString:@"0"]){
                        NSLog(@"err = %@",err);
                        
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    
                    
                }];

                
            }else{
                [cell.zanbtn setImage:[UIImage imageNamed:@"zaned_Img@2x"] forState:UIControlStateNormal];
                NSString *zanednum = [_zanedNumArray objectAtIndex:indexPath.row];
                if (![zanednum isEqualToString:@"1"]) {
                    cell.addOneLable.alpha = 1;
                    [cell hideAddOneLable];
                }
                
                NSString *zannumStr = [_zanNumArray objectAtIndex:indexPath.row];
                int zannum = [zannumStr intValue];
                zannum ++;
                NSLog(@"zannum = %i",zannum);
                [_zanedNumArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
                [_zanNumArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%i",zannum]];
                [cell.zanbtn setTitle:[NSString stringWithFormat:@"%i",zannum] forState:UIControlStateNormal];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@zan/article?id=%@&access-token=%@",ApiUrlHead,[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"id"]],_token];
                NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [manager GET:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                    NSString *err = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"err"]];
                    if ([code isEqualToString:@"0"]) {
                        NSLog(@"点赞成功！");
                       
                    }else if (![code isEqualToString:@"0"]){
                        NSLog(@"err = %@",err);
                        /*if ([err isEqualToString:@"已点过赞"]) {   //取消点赞
                         NSString *urlStr = [NSString stringWithFormat:@"%@zan/comment-cancel?id=%@&access-token=%@",ApiUrlHead,[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"id"]],_token];
                         NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                         [manager GET:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSLog(@"JSON: %@", responseObject);
                         NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                         NSString *err = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"err"]];
                         if ([code isEqualToString:@"0"]) {
                         NSLog(@"取消点赞成功！");
                         [_zanedNumArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
                         [_zanNumArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%i",zannum --]];
                         [cell.zanbtn setTitle:zannumStr forState:UIControlStateNormal];
                         
                         }else if (![code isEqualToString:@"0"]){
                         NSLog(@"err = %@",err);
                         
                         }
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"Error: %@", error);
                         
                         
                         }];
                         }*/
                        
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    
                    
                }];
                
            }

        }else if (index == 1){
            
            
        }else if (index == 2){
            ToubiaoDetailViewController *Tvc = [[ToubiaoDetailViewController alloc]init];
            Tvc.token = _token;
            Tvc.uid = _uid;
            Tvc.ifShowPinglun = @"ssd";
            Tvc.toubiaoID = [NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
            Tvc.time = [TimeXLJ returnUploadTime:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"created_at"]]];
            [self.navigationController pushViewController:Tvc animated:YES];
            
        }else{
            //刷新单个cell
            // NSIndexPath *indexPath=[NSIndexPath indexPathForRow:tanchuanTag inSection:0];
            //[_tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationLeft];
            NSLog(@"tanchuanTag = %li",(long)tanchuanTag);
            //if (cell.number == 0) {
            if (indexPath.row == tanchuanTag) {
                if (_tanChuangView.hidden == YES) {
                    _tanChuangView.hidden = NO;
                    _tanChuangView.frame = CGRectMake(self.view.bounds.size.width - 85, cell.zanbtn.frame.origin.y - 20, 70, 25);
                    _tanChuangView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
                    _tanChuangView.tag = indexPath.row;
                    [cell.contentView addSubview:_tanChuangView];
                    
                    _tanChuangView.layer.masksToBounds = YES;
                    _tanChuangView.layer.cornerRadius = 4;
                    
                    _fenxiangButton.frame =  CGRectMake(10, _tanChuangView.bounds.size.height * 0.2, _tanChuangView.bounds.size.width * 0.8, _tanChuangView.bounds.size.height * 0.6);
                    
                    //_shoucanButton.frame = CGRectMake(_tanChuangView.bounds.size.width * 0.5 + 10, _tanChuangView.bounds.size.height * 0.2, _tanChuangView.bounds.size.width * 0.5, _tanChuangView.bounds.size.height * 0.6);
                }else{
                    _tanChuangView.hidden = YES;
                }
                
            }else{
                _tanChuangView.hidden = NO;
                 _tanChuangView.frame = CGRectMake(self.view.bounds.size.width - 85, cell.zanbtn.frame.origin.y - 20, 70, 25);
                _tanChuangView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
                _tanChuangView.tag = indexPath.row;
                [cell.contentView addSubview:_tanChuangView];
                
                
                _tanChuangView.layer.masksToBounds = YES;
                _tanChuangView.layer.cornerRadius = 4;
                
                
                  _fenxiangButton.frame =  CGRectMake(10, _tanChuangView.bounds.size.height * 0.2, _tanChuangView.bounds.size.width * 0.8, _tanChuangView.bounds.size.height * 0.6);
                //_shoucanButton.frame = CGRectMake(_tanChuangView.bounds.size.width * 0.5 + 10, _tanChuangView.bounds.size.height * 0.2, _tanChuangView.bounds.size.width * 0.5, _tanChuangView.bounds.size.height * 0.6);
                
                
            }
            
            
            
            
            
            tanchuanTag = indexPath.row;
            NSLog(@"indexPath.row = %li",(long)indexPath.row);
            
            //}else if (cell.number == 1){
            //[_tanChuangView removeFromSuperview];
            //cell.number = 0;
            //}
        }
        
        
    }];
    
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    
    
    
    return cell;
}
- (void)moreAction:(XiangmuPinglinButton *)btn{
    switch (btn.tag) {
        case 0:
        {
            NSLog(@"分享");
            
            NSString *title = [[_DataArray objectAtIndex:btn.superview.tag] objectForKey:@"title"];
            if (title.length > 15) {
                title = [title substringToIndex:15];
            }
            
            NSString *summary = [[_DataArray objectAtIndex:btn.superview.tag] objectForKey:@"summary"];
            if (summary.length > 30) {
                summary = [summary substringToIndex:30];
            }
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[_DataArray objectAtIndex:btn.superview.tag] objectForKey:@"share_url"],@"share_url",title,@"title",summary,@"content", nil];
            //通知分享
            [[NSNotificationCenter defaultCenter]postNotificationName:@"toShareViewController" object:dic userInfo:nil];
            
        }
            break;
        case 1:
        {
            NSLog(@"收藏");
            NSString *urlStr = [NSString stringWithFormat:@"%@favorite/new?access-token=%@&aid=%@",ApiUrlHead,_token,[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:btn.superview.tag] objectForKey:@"id"]]];
            
            [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                
                if ([code isEqualToString:@"0"]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"收藏成功" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                    [alert show];
                    
                }else if (![code isEqualToString:@"0"]){
                    NSString *error = [responseObject objectForKey:@"err"];
                    NSLog(@"error=%@",error);
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                    [alert show];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                
            }];
        }
            break;
            
        default:
            break;
    }
    //一个cell刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:btn.superview.tag inSection:0];
    [_tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _tanChuangView.hidden = YES;
}
- (void)moreAction1:(XiangmuPinglinButton *)btn{
    switch (btn.tag) {
        case 0:
        {
            NSLog(@"分享");
            NSString *title = [[_DataArray objectAtIndex:btn.superview.tag] objectForKey:@"title"];
            if (title.length > 15) {
                title = [title substringToIndex:15];
            }
            
            NSString *summary = [[_DataArray objectAtIndex:btn.superview.tag] objectForKey:@"summary"];
            if (summary.length > 30) {
                summary = [summary substringToIndex:30];
            }
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[_DataArray objectAtIndex:btn.superview.tag] objectForKey:@"share_url"],@"share_url",[[_DataArray objectAtIndex:btn.superview.tag] objectForKey:@"title"],@"title", nil];
            //通知分享
            [[NSNotificationCenter defaultCenter]postNotificationName:@"toShareViewController" object:dic userInfo:nil];
            
        }
            break;
        case 1:
        {
            NSLog(@"收藏");
        }
            break;
            
        default:
            break;
    }
    
}
-(void)didCellWillHide:(id)aSender{

}
-(void)didCellHided:(id)aSender{

}
-(void)didCellWillShow:(id)aSender{

}
-(void)didCellShowed:(id)aSender{

}
-(void)didCellClickedDeleteButton:(id)aSender  index:(NSInteger)index{
    NSLog(@"删除,index = %li",(long)index);
    NSLog(@"_DataArray.count = %lu",(unsigned long)_DataArray.count);
    NSString *urlStr = [NSString stringWithFormat:@"%@favorite/del?id=%@&access-token=%@",ApiUrlHead,[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:index] objectForKey:@"id"]],_token];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            
            NSIndexPath *vIndex = [_tableview indexPathForCell:aSender];
            [_DataArray removeObjectAtIndex:(NSUInteger)index];
            //[_tableview deleteRowsAtIndexPaths:[NSArray arrayWithObjects:vIndex, nil] withRowAnimation:UITableViewRowAnimationLeft];
            [_tableview deleteRowsAtIndexPaths:[NSArray arrayWithObjects:vIndex, nil] withRowAnimation:UITableViewRowAnimationLeft];
            [_tableview reloadData];
       
        }else if (![code isEqualToString:@"0"]){
            NSString *error = [responseObject objectForKey:@"err"];
            NSLog(@"error=%@",error);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
            [alert show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];
    
    
    
   
}
-(void)didCellClickedMoreButton:(id)aSender{
    NSLog(@"分享");
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ToubiaoDetailViewController *Tvc = [[ToubiaoDetailViewController alloc]init];
    Tvc.token = _token;
    Tvc.uid = _uid;
    Tvc.ifFromToubiao = @"shoucang";
    Tvc.toubiaoID = [NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    Tvc.time = [TimeXLJ returnUploadTime_no1970:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"created_at"]]];
    [self.navigationController pushViewController:Tvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

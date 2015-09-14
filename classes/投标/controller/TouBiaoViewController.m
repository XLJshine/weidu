//
//  TouBiaoViewController.m
//  dayang
//
//  Created by chendong on 15/7/20.
//  Copyright (c) 2015年 chendong. All rights reserved.
//
#import "TouBiaoViewController.h"
#import "ToubiaoTableViewCell.h"
#import "ToubiaoChooseButton.h"
#import "ToubiaoChooseButton2.h"
#import "MJRefresh.h"
#import "MJChiBaoZiFooter.h"
#import "AppDelegate.h"
#import "BlackViewController.h"
#import "ChooseTableView.h"
#import "ChooseTableView2.h"
#import "ChooseView_shaixuanView.h"
#import "MyItemButton.h"
#import "AFHTTPRequestOperationManager.h"
#import "RequestXlJ.h"
#import "WBBooksManager.h"
#import "XiangmuPinglinButton.h"
#import "TimeXLJ.h"
#import "LableXLJ.h"
#import "MobClick.h"
#import "ToubiaoDetailViewController.h"
#import "ToubiaoModal.h"
#import "LoadingViewXLJ.h"
static TouBiaoViewController *instance;
@interface TouBiaoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong)UITableView *tableview;

@property (nonatomic ,strong)__block ChooseTableView *firstTableView; //筛选一级视图
@property (nonatomic ,strong)__block ChooseTableView2 *secondTableView; //筛选二级视图
@property (nonatomic ,strong)__block ChooseTableView2 *thirdTableView; //筛选二级视图
@property (nonatomic ,strong)__block ChooseView_shaixuanView *shaixuanView;
@property (nonatomic ,strong)NSMutableArray *BigArray;
@property (nonatomic ,strong)NSMutableArray *SmallArray;
@property (nonatomic ,strong)ToubiaoChooseButton *tcButton1;    //筛选按钮
@property (nonatomic ,strong)ToubiaoChooseButton *tcButton2;
@property (nonatomic ,strong)ToubiaoChooseButton *tcButton3;
@property (nonatomic ,strong)ToubiaoChooseButton2 *tcButton4;
@property (nonatomic ,strong)UIImageView *backgroudImageView;  //背景图片
@property (nonatomic ,strong)UITextField *searchTextField;
@property (nonatomic ,strong)NSArray *chooseArray;      //数据源
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) UIButton *lestButton;
@property (strong, nonatomic) UIBarButtonItem *leftItem;
@property (strong, nonatomic)__block RequestXlJ *request;
@property (strong, nonatomic)NSMutableDictionary *ArticleDic;  //初始化数据
@property (strong, nonatomic)__block NSMutableArray *DataArray;
@property (strong, nonatomic)UIView * tanChuangView;
@property (strong, nonatomic)XiangmuPinglinButton *shoucanButton;
@property (strong, nonatomic)XiangmuPinglinButton *fenxiangButton;
@property (strong, nonatomic)UIView *headview;  //头部筛选视图
@property (strong, nonatomic)NSMutableArray *zanNumArray;    //赞的个数数组
@property (strong, nonatomic)NSMutableArray *liulanNumArray;    //浏览的个数数组
@property (strong, nonatomic)NSMutableArray *commentNumArray;    //评论的个数数组
@property (strong, nonatomic)NSMutableArray *zanedNumArray;    //是否已经赞过
@property (strong, nonatomic)NSMutableArray *favedNumArray;    //是否已经赞过
@property (assign, nonatomic)NSInteger titleFont;    //标题字号
@property (assign, nonatomic)NSInteger lableFont;    //标签字号
@property (assign, nonatomic)NSInteger detailFont;      //内容字号
@property (assign, nonatomic)NSInteger titleSepFont;    //标题间距
@property (assign, nonatomic)NSInteger detailSepFont;      //内容间距
@end

@implementation TouBiaoViewController{
    MJChiBaoZiFooter *footer;
    NSInteger firstTableViewIndex;
    NSInteger secondTableViewIndex;
    NSInteger number;
    
    __block  NSInteger pageNum;   //分页控制
    NSString * areaID;    //地区ID
    NSString * hangyeID;  //行业ID
    NSString * cateID;   //类别ID
    
    AFHTTPRequestOperationManager *manager;
    __block NSInteger areaSelectNum;   //地区选中数
    __block NSInteger shengSelectNum;  //省份选中数
    __block NSInteger tradeSelectNum;  //行业选中数
    __block NSInteger typeSelectNum;   //类型选中数
    
    NSDictionary * _parameters;
    NSString * _fID;
    __block  NSInteger loadMoreType;  //1、筛选，2、普通筛选，3、搜索
    UIView *titleView1;
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
    
     //[self.navigationController.view bringSubviewToFront:_headview];
     //刷新navigationBaritems
     //[self addnavigationItems];
    
     self.extendedLayoutIncludesOpaqueBars = NO;
     self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    
   
    // this UIViewController is about to re-appear, make sure we remove the current selection in our table view
    NSIndexPath *tableSelection = [self.tableview indexPathForSelectedRow];
    [self.tableview deselectRowAtIndexPath:tableSelection animated:NO];
    [MobClick beginLogPageView:@"ToubiaoMainPage"];
    
     //初始化数据，判断给出的Key对应的数据是否存在,若不存在，则重新加载
    if (![[WBBooksManager sharedInstance] isBookExistsForKey:@"Article"]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@article/fitems",ApiUrlHead];
        _request = [[RequestXlJ alloc]init];
        [_request requestWithUrl:urlStr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary * responseObject,NSArray *array){
            NSLog(@"code = %li",(long)code);
            //NSLog(@"responseObject = %@",responseObject);
            if (code == 0) {
                NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                _ArticleDic = userDic;
                [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"Article"];
            }else{
                NSLog(@"加载失败");
            
            }
           
        }];
    }
    
    //刷新tableView调整字号
    [self readTextFont];
    [_tableview reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
   
    
    if (_ifModelNavigation.length > 0) {  //xianshicehua
        [[NSNotificationCenter defaultCenter]postNotificationName:@"xianshicehua" object:nil userInfo:nil];
    }
    _ifModelNavigation = @"";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ToubiaoMainPage"];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
       self.navigationItem.title = @"投标";
       
        [self addnavigationItems];
        //self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}
#pragma mark -添加items
- (void)addnavigationItems{
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
    
    
    UIImage *backImg1 = [UIImage imageNamed:@"dingbu2@2x"];
    UIButton *backBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 25,25)];
    [backBtn1 setImage:backImg1 forState:UIControlStateNormal];
    [backBtn1 setImage:[UIImage imageNamed:@"search_delete_img@2x"] forState:UIControlStateSelected];
    [backBtn1 addTarget:self action:@selector(searchToubiao:) forControlEvents:UIControlEventTouchUpInside];
    //        [backBtn1 setImage:backImg1 forState:UIControlStateNormal];
    //        UIView *backBtnView1 = [[UIView alloc] initWithFrame:backBtn1.bounds];
    //        backBtnView1.bounds = CGRectOffset(backBtnView.bounds, -20, 0);
    //        [backBtnView1 addSubview:backBtn1];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn1];
    self.navigationItem.rightBarButtonItem = rightItem;


}

-(void)push1{
    //NSLog(@"_lestButton.frame = %f ,%f ,%f ,%f ",_lestButton.frame.origin.x,_lestButton.frame.origin.y,_lestButton.frame.size.width,_lestButton.frame.size.height);
    NSLog(@"_token = %@",_token);
    if (_token.length > 10) {
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        YRSideViewController *sideViewController = [delegate siderViewController];
        //sideViewController.needSwipeShowMenu = true;
        [sideViewController showLeftViewController:YES];
        [_searchTextField resignFirstResponder];
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

-(void)searchToubiao:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        self.navigationItem.titleView = titleView1;
        [_searchTextField becomeFirstResponder];
    }else{
        [_backgroudImageView removeFromSuperview];
        
        loadMoreType = 1;
        self.navigationItem.titleView = nil;
        [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?access-token=%@page=1&psize=10",ApiUrlHead,_token] parameter:nil methed:@"post" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
            NSLog(@"array = %@",array);
           
            if (array.count >= 10) {
                //设置footer
                _tableview.footer = footer;
            }else{
                 _tableview.footer = nil;
            }
            [_zanedNumArray removeAllObjects];
            [_zanNumArray removeAllObjects];
            [_commentNumArray removeAllObjects];
            [_liulanNumArray removeAllObjects];
            [_DataArray removeAllObjects];
            [_favedNumArray removeAllObjects];
            for (int i  = 0; i < array.count; i ++) {
                [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
                [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
                [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
                NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                if ([zaned11 isEqualToString:@"1"]) {
                    [_zanedNumArray addObject:@"1"];
                }else{
                    [_zanedNumArray addObject:@"0"];
                }
                NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                if ([faved11 isEqualToString:@"1"]) {
                    [_favedNumArray addObject:@"1"];
                }else{
                    [_favedNumArray addObject:@"0"];
                }
            }
            [_DataArray addObjectsFromArray:array];
            [_loadingView removeFromSuperview];
            
            [_tableview reloadData];
        }];
        

    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hideTableView];
    
    loadMoreType = 3;
    NSString *urlStr = [NSString stringWithFormat:@"%@article/so?wd=%@&page=1&psize=10",ApiUrlHead,textField.text];
    NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            [_DataArray removeAllObjects];
            if (arr.count >= 10) {
                //设置footer
                _tableview.footer = footer;
            }else{
                _tableview.footer = nil;
                
            }
            if (arr.count == 0) {
                [self.view addSubview:_backgroudImageView];
            }else{
                [_backgroudImageView removeFromSuperview];
            }
            
            [_zanNumArray removeAllObjects];
            [_commentNumArray removeAllObjects];
            [_liulanNumArray removeAllObjects];
            [_DataArray removeAllObjects];
            [_favedNumArray removeAllObjects];
            for (int i  = 0; i < arr.count; i ++) {
                [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zans"]]];
                [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"views"]]];
                [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"comments"]]];
                NSString *zaned11  = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zaned"]];
                if ([zaned11 isEqualToString:@"1"]) {
                    [_zanedNumArray addObject:@"1"];
                }else{
                    [_zanedNumArray addObject:@"0"];
                }
                NSString *faved11  = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"faved"]];
                if ([faved11 isEqualToString:@"1"]) {
                    [_favedNumArray addObject:@"1"];
                }else{
                    [_favedNumArray addObject:@"0"];
                }
            }
            [_DataArray addObjectsFromArray:arr];
            [_tableview reloadData];
            
        }else if (![code isEqualToString:@"0"]){
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];
    
    [textField resignFirstResponder];
    return YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
   
    _zanNumArray = [NSMutableArray array];
    _liulanNumArray = [NSMutableArray array];
    _commentNumArray = [NSMutableArray array];
    _zanedNumArray = [NSMutableArray array];
    _favedNumArray = [NSMutableArray array];
    
    
    _backgroudImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    if (self.view.bounds.size.height > 500) {
        _backgroudImageView.image = [UIImage imageNamed:@"search_none_img_5S"];
    }else{
        _backgroudImageView.image = [UIImage imageNamed:@"search_none_img"];
    }
    
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
    
    _shoucanButton = [[XiangmuPinglinButton alloc]init];
    [_shoucanButton setTitle:@"收藏" forState:UIControlStateNormal];
    [_shoucanButton setBackgroundColor:[UIColor clearColor]];
    [_shoucanButton setImage:[UIImage imageNamed:@"fengfen1@2x"] forState:UIControlStateNormal];
    _shoucanButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [_shoucanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _shoucanButton.tag = 1;
    [_shoucanButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    [_tanChuangView addSubview:_shoucanButton];
    
    
    titleView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 6, 180, 25)];
    titleView1.backgroundColor = [UIColor whiteColor];
    titleView1.layer.masksToBounds = YES;
    titleView1.layer.cornerRadius = titleView1.bounds.size.height * 0.5;
    _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, titleView1.bounds.size.width - 20, 25)];
    _searchTextField.delegate = self;
    _searchTextField.placeholder = @"请输入搜索关键字";
    _searchTextField.font = [UIFont systemFontOfSize:14.0];
     _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.backgroundColor = [UIColor whiteColor];
    [titleView1 addSubview:_searchTextField];
    //if_FirstAppear = YES;
    //self.tabBarController.tabBar.hidden = YES;
    number = 0;
    _BigArray = [NSMutableArray array];
    _SmallArray = [NSMutableArray array];
    _DataArray = [NSMutableArray array];
    pageNum = 1;
    areaID = @"";
    hangyeID = @"";
    cateID = @"";
    areaSelectNum = 0;
    
    manager = [AFHTTPRequestOperationManager manager];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    
    //实例话tableview并集成刷新空间
    [self initTableView];
    //添加筛选按钮
    [self addHeadView];
    //读取text字号
    [self readTextFont];
    
    //请求投标数据列表
    _request = nil;
    _request = [[RequestXlJ alloc]init];
    if (_token.length < 10) {
        _token = @"";
    }
    [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?access-token=%@&page=1&psize=10",ApiUrlHead,_token] parameter:nil methed:@"post" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
        NSLog(@"array = %@",array);
       
      
        for (int i  = 0; i < array.count; i ++) {
            [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
            [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
            [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
            NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
            if ([zaned11 isEqualToString:@"1"]) {
                [_zanedNumArray addObject:@"1"];
            }else{
                [_zanedNumArray addObject:@"0"];
            }
            NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
            if ([faved11 isEqualToString:@"1"]) {
                [_favedNumArray addObject:@"1"];
            }else{
                [_favedNumArray addObject:@"0"];
            }
        }
        [_DataArray addObjectsFromArray:array];
        
        [_loadingView removeFromSuperview];
        
        [_tableview reloadData];
    }];
    
    
    
    _loadingView = [[LoadingViewXLJ alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 200)*0.5, self.view.bounds.size.height*0.5 - 120, 200,100) title:@"正在加载，请稍后。。。"];
    [self.view addSubview:_loadingView];
    
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(numHaveChanged:) name:@"NumHaveChanged" object:nil];   //监听评论数和
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tokenGet:) name:@"tokenGet" object:nil]; //监听获取token
    
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
- (void)tokenGet:(NSNotification *)notification{
    NSDictionary *dic = notification.object;
    NSLog(@"dic22 = %@",dic);
    _token = [NSString stringWithFormat:@"%@",[dic objectForKey:@"token"]];
    _uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
    //请求投标数据列表
    _request = nil;
    _request = [[RequestXlJ alloc]init];
    
    pageNum = 1;
    loadMoreType = 2;
    [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?page=1&psize=10&access-token=%@",ApiUrlHead,_token] parameter:nil methed:@"post" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
        //NSLog(@"code = %li",(long)code);
        //NSLog(@"error = %@",error);
        //NSLog(@"dictionary = %@",dictionary);
        NSLog(@"array = %@",array);
        [_DataArray removeAllObjects];
        
        [_zanNumArray removeAllObjects];
        [_liulanNumArray removeAllObjects];
        [_commentNumArray removeAllObjects];
        [_zanedNumArray removeAllObjects];
        [_favedNumArray removeAllObjects];
        for (int i  = 0; i < array.count; i ++) {
            [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
            [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
            [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
            NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
            if ([zaned11 isEqualToString:@"1"]) {
                [_zanedNumArray addObject:@"1"];
            }else{
                [_zanedNumArray addObject:@"0"];
            }
            NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
            if ([faved11 isEqualToString:@"1"]) {
                [_favedNumArray addObject:@"1"];
            }else{
                [_favedNumArray addObject:@"0"];
            }
            
        }
        [_DataArray addObjectsFromArray:array];
        [_tableview reloadData];
        
    }];

}

- (void)numHaveChanged:(NSNotification *)notification{
    NSString *commonedNum = notification.object;
    NSString *commonedNum1 = [_commentNumArray objectAtIndex:indexPath_rowNum];
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
    
}
- (void)initData{
    //初始化数据，判断给出的Key对应的数据是否存在
    if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"Article"]) {
        //存在，则替换之
        NSMutableDictionary * resultDictionary = [[NSMutableDictionary alloc] init];
        [[WBBooksManager sharedInstance] readPlist:&resultDictionary];
        NSDictionary *ArticleDic = [resultDictionary objectForKey:@"Article"];
        NSLog(@"ArticleDic = %@",ArticleDic);
        
    }else{//不存在，则写入
        
        NSString *urlStr = [NSString stringWithFormat:@"%@article/fitems",ApiUrlHead];
        _request = [[RequestXlJ alloc]init];
        [_request requestWithUrl:urlStr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary * responseObject,NSArray *array){
            NSLog(@"code = %li",(long)code);
            NSLog(@"responseObject = %@",responseObject);
            
            NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
           [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"Article"];
            
        }];
    }
}
- (void)addHeadView{
    _headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    /*headview.layer.shadowOpacity  =  0.5f ;
    headview.layer.cornerRadius = 4.0f;
    headview.layer.shadowOffset = CGSizeZero;
    headview.layer.shadowRadius = 4.0f;
    headview.layer.shadowPath   = [UIBezierPath bezierPathWithRect:headview.bounds].CGPath;*/
    _headview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headview];
    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, self.view.bounds.size.width, 0.5)];
    sepLine.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
    [_headview addSubview:sepLine];
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"全部地区",@"全部行业",@"全部类别",@"筛选", nil];
    _tcButton1 = [[ToubiaoChooseButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.25*0, 0, self.view.bounds.size.width*0.25, _headview.bounds.size.height)];
        [_tcButton1 setBackgroundColor:[UIColor clearColor]];
        [_tcButton1 setTitle:[titleArray objectAtIndex:0] forState:UIControlStateNormal];
        _tcButton1.tag = 0;
        [_tcButton1 addTarget:self action:@selector(shaixuanAction:) forControlEvents:UIControlEventTouchUpInside];
        [_headview addSubview:_tcButton1];
    
    _tcButton2 = [[ToubiaoChooseButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.25*1, 0, self.view.bounds.size.width*0.25, _headview.bounds.size.height)];
     [_tcButton2 setBackgroundColor:[UIColor clearColor]];
    [_tcButton2 setTitle:[titleArray objectAtIndex:1] forState:UIControlStateNormal];
    _tcButton2.tag = 1;
    [_tcButton2 addTarget:self action:@selector(shaixuanAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headview addSubview:_tcButton2];
    
    _tcButton3 = [[ToubiaoChooseButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.25*2, 0, self.view.bounds.size.width*0.25, _headview.bounds.size.height)];
    [_tcButton3 setBackgroundColor:[UIColor clearColor]];
    [_tcButton3 setTitle:[titleArray objectAtIndex:2] forState:UIControlStateNormal];
    _tcButton3.tag = 2;
    [_tcButton3 addTarget:self action:@selector(shaixuanAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headview addSubview:_tcButton3];
    
    _tcButton4 = [[ToubiaoChooseButton2 alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.25*3, 0, self.view.bounds.size.width*0.25, _headview.bounds.size.height)];
    [_tcButton4 setBackgroundColor:[UIColor clearColor]];
    [_tcButton4 setTitle:[titleArray objectAtIndex:3] forState:UIControlStateNormal];
    _tcButton4.tag = 3;
    [_tcButton4 addTarget:self action:@selector(shaixuanAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headview addSubview:_tcButton4];
}
#pragma mark----实例化---
- (void)initTableView{
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 49 - 64 - 40)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.scrollsToTop = YES;
    [self.view addSubview:_tableview];
    UIView *footview = [[UIView alloc]init];
    footview.backgroundColor = [UIColor whiteColor];
    _tableview.tableFooterView = footview;
    
    //底部阴影视图
    _grayView = [[UIControl alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 40)];
    _grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [_grayView addTarget:self action:@selector(hideTableView) forControlEvents:UIControlEventTouchUpInside];
    _grayView.hidden = YES;
    [self.view addSubview:_grayView];
    // 下拉刷新
    _tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        pageNum = 1;
        
        if (loadMoreType == 1) {  //筛选请求
            //传入的参数
            [manager POST:[NSString stringWithFormat:@"%@article/list?access-token=%@&page=1&psize=10",ApiUrlHead,_token] parameters:_parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                if ([code isEqualToString:@"0"]) {
                    NSArray *data = [responseObject objectForKey:@"data"];
                    [_DataArray removeAllObjects];
                    [_zanNumArray removeAllObjects];
                    [_liulanNumArray removeAllObjects];
                    [_commentNumArray removeAllObjects];
                    [_zanedNumArray removeAllObjects];
                    [_favedNumArray removeAllObjects];
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
                        NSString *faved11  = [NSString stringWithFormat:@"%@",[[data objectAtIndex:i] objectForKey:@"faved"]];
                        if ([faved11 isEqualToString:@"1"]) {
                            [_favedNumArray addObject:@"1"];
                        }else{
                            [_favedNumArray addObject:@"0"];
                        }
                    }
                    
                    [_DataArray addObjectsFromArray:data];
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
            
            
            
        }else if(loadMoreType == 2){    //非筛选
            NSMutableArray *arr = [NSMutableArray array];
            /*if (![areaID isEqualToString:@"0"]) {
                arr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"area=%@",areaID],@"psize=10",[NSString stringWithFormat:@"access-token=%@",_token],nil];
                [arr addObject:[NSString stringWithFormat:@"page=1"]];
            }else if (![hangyeID isEqualToString:@"0"]){
                arr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"trade=%@",hangyeID],@"psize=10",[NSString stringWithFormat:@"access-token=%@",_token],nil];
                [arr addObject:[NSString stringWithFormat:@"page=1"]];
            }else if (![cateID isEqualToString:@"0"]){
                arr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"cate=%@",cateID],@"psize=10",[NSString stringWithFormat:@"access-token=%@",_token],nil];
                [arr addObject:[NSString stringWithFormat:@"page=1"]];
            }else{
                arr = [NSMutableArray arrayWithObjects:@"psize=10",[NSString stringWithFormat:@"access-token=%@",_token],nil];
                [arr addObject:[NSString stringWithFormat:@"page=1"]];
            }*/
            arr = [NSMutableArray arrayWithObjects:@"psize=10",[NSString stringWithFormat:@"area=%@",areaID],[NSString stringWithFormat:@"type=%@",cateID],[NSString stringWithFormat:@"trade=%@",hangyeID],[NSString stringWithFormat:@"access-token=%@",_token],nil];
            [arr addObject:[NSString stringWithFormat:@"page=%li",(long)pageNum]];
            
            _request = nil;
            _request = [[RequestXlJ alloc]init];
            if (arr.count > 0) {
                NSMutableString *urlstr = [NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead];
                for (int i = 0;i < arr.count;i ++){
                    NSString *str;
                    if (i != arr.count - 1) {
                        str = [NSString stringWithFormat:@"%@&",[arr objectAtIndex:i]];
                    }else{
                        str = [arr objectAtIndex:i];
                    }
                    [urlstr appendString:str];
                }
                [_request requestWithUrlHead:urlstr parameter:nil methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
                    //NSLog(@"code = %li",(long)code);
                    //NSLog(@"error = %@",error);
                    //NSLog(@"dictionary = %@",dictionary);
                    NSLog(@"array = %@",array);
                     [_DataArray removeAllObjects];
                    [_zanNumArray removeAllObjects];
                    [_liulanNumArray removeAllObjects];
                    [_commentNumArray removeAllObjects];
                    [_zanedNumArray removeAllObjects];
                    [_favedNumArray removeAllObjects];
                    for (int i  = 0; i < array.count; i ++) {
                        [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
                        [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
                        [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
                        NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                        if ([zaned11 isEqualToString:@"1"]) {
                            [_zanedNumArray addObject:@"1"];
                        }else{
                            [_zanedNumArray addObject:@"0"];
                        }
                        NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                        if ([faved11 isEqualToString:@"1"]) {
                            [_favedNumArray addObject:@"1"];
                        }else{
                            [_favedNumArray addObject:@"0"];
                        }
                    }
                  
                    [_DataArray addObjectsFromArray:array];
                    [_tableview reloadData];
                    
                }];
            }else{
                [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead] parameter:arr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
                    //NSLog(@"code = %li",(long)code);
                    //NSLog(@"error = %@",error);
                    //NSLog(@"dictionary = %@",dictionary);
                    NSLog(@"array = %@",array);
                     [_DataArray removeAllObjects];
                    [_zanNumArray removeAllObjects];
                    [_liulanNumArray removeAllObjects];
                    [_commentNumArray removeAllObjects];
                    [_zanedNumArray removeAllObjects];
                    [_favedNumArray removeAllObjects];
                    for (int i  = 0; i < array.count; i ++) {
                        [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
                        [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
                        [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
                        NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                        if ([zaned11 isEqualToString:@"1"]) {
                            [_zanedNumArray addObject:@"1"];
                        }else{
                            [_zanedNumArray addObject:@"0"];
                        }
                        NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                        if ([faved11 isEqualToString:@"1"]) {
                            [_favedNumArray addObject:@"1"];
                        }else{
                            [_favedNumArray addObject:@"0"];
                        }

                    }
                  
                    [_DataArray addObjectsFromArray:array];
                    [_tableview reloadData];
                    
                }];
                
            }
            
            
        }else if(loadMoreType == 3){  //搜索
            NSString *urlStr = [NSString stringWithFormat:@"%@article/so?access-token=%@&wd=%@&page=%li&psize=10",ApiUrlHead,_token,_searchTextField.text,(long)pageNum];
            NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [manager GET:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                if ([code isEqualToString:@"0"]) {
                    NSArray *arr = [responseObject objectForKey:@"data"];
                    [_DataArray removeAllObjects];
                    
                    [_zanNumArray removeAllObjects];
                    [_liulanNumArray removeAllObjects];
                    [_commentNumArray removeAllObjects];
                    [_zanedNumArray removeAllObjects];
                    [_favedNumArray removeAllObjects];
                    for (int i  = 0; i < arr.count; i ++) {
                        [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zans"]]];
                        [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"views"]]];
                        [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"comments"]]];
                        NSString *zaned11  = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zaned"]];
                        if ([zaned11 isEqualToString:@"1"]) {
                            [_zanedNumArray addObject:@"1"];
                        }else{
                            [_zanedNumArray addObject:@"0"];
                        }
                        NSString *faved11  = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"faved"]];
                        if ([faved11 isEqualToString:@"1"]) {
                            [_favedNumArray addObject:@"1"];
                        }else{
                            [_favedNumArray addObject:@"0"];
                        }
 
                    }
                    
                    [_DataArray addObjectsFromArray:arr];
                    [_tableview reloadData];
                   
                    
                }else if (![code isEqualToString:@"0"]){
                    
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                //网络不佳视图
                InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height * 0.75, self.view.bounds.size.width - 180, 25)];
                [self.view addSubview:errorView];
                
            }];
            
        }else{
            //请求投标数据列表
            _request = nil;
            _request = [[RequestXlJ alloc]init];
            [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?page=1&psize=10&access-token=%@",ApiUrlHead,_token] parameter:nil methed:@"post" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
                //NSLog(@"code = %li",(long)code);
                //NSLog(@"error = %@",error);
                //NSLog(@"dictionary = %@",dictionary);
                NSLog(@"array = %@",array);
                [_DataArray removeAllObjects];
                
                [_zanNumArray removeAllObjects];
                [_liulanNumArray removeAllObjects];
                [_commentNumArray removeAllObjects];
                [_zanedNumArray removeAllObjects];
                [_favedNumArray removeAllObjects];
                for (int i  = 0; i < array.count; i ++) {
                    [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
                    [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
                    [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
                    NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                    if ([zaned11 isEqualToString:@"1"]) {
                        [_zanedNumArray addObject:@"1"];
                    }else{
                        [_zanedNumArray addObject:@"0"];
                    }
                    NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                    if ([faved11 isEqualToString:@"1"]) {
                        [_favedNumArray addObject:@"1"];
                    }else{
                        [_favedNumArray addObject:@"0"];
                    }

                }
                [_DataArray addObjectsFromArray:array];
                [_tableview reloadData];
              
            }];
        }
        
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
    //设置footer
    _tableview.footer = footer;
    
    
    //筛选1级／2级tableview实例化
    
    _thirdTableView = [[ChooseTableView2 alloc]initWithFrame:CGRectMake(0, 40,self.view.bounds.size.width, 330) titleArray:nil block:^(NSInteger index){}];
    [self.view addSubview:_thirdTableView];
    _secondTableView = [[ChooseTableView2 alloc]initWithFrame:CGRectMake(135, 40,self.view.bounds.size.width - 135, 330) titleArray:nil block:^(NSInteger index){}];
    [self.view addSubview:_secondTableView];
    _firstTableView = [[ChooseTableView alloc]initWithFrame:CGRectMake(0, 40, 135, 330) titleArray:nil block:^(NSInteger index){}];
    [self.view addSubview:_firstTableView];
    
    //筛选界面
    _shaixuanView = [[ChooseView_shaixuanView alloc]initWithFrame:CGRectMake(0, 40,self.view.bounds.size.width, 330) block:^(NSDictionary *parameters, NSArray *array,NSString *fID,NSInteger index) {
        if (index == 1) {     //筛选
            _parameters = parameters;
            NSLog(@"_parameters = %@",_parameters);
            loadMoreType = 1;
            [self hideTableView];
            [_DataArray removeAllObjects];
            [_zanNumArray removeAllObjects];
            [_liulanNumArray removeAllObjects];
            [_commentNumArray removeAllObjects];
            [_zanedNumArray removeAllObjects];
            [_favedNumArray removeAllObjects];
            for (int i  = 0; i < array.count; i ++) {
                [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
                [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
                [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
                NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                if ([zaned11 isEqualToString:@"1"]) {
                    [_zanedNumArray addObject:@"1"];
                }else{
                    [_zanedNumArray addObject:@"0"];
                }
                NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                if ([faved11 isEqualToString:@"1"]) {
                    [_favedNumArray addObject:@"1"];
                }else{
                    [_favedNumArray addObject:@"0"];
                }
            }
            [_DataArray addObjectsFromArray:array];
            [_tableview reloadData];
        }else if (index == 2){   //保存筛选后的请求
            [self.view addSubview:_loadingView];
            
            NSString *urlStr =[NSString stringWithFormat:@"%@article/list?access-token=%@&page=1&psize=10",ApiUrlHead,_token];
            [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [_loadingView removeFromSuperview];
                
                NSLog(@"JSON: %@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                if ([code isEqualToString:@"0"]) {
                    NSArray *data = [responseObject objectForKey:@"data"];
                    _parameters = parameters;
                    NSLog(@"_parameters = %@",_parameters);
                    loadMoreType = 1;
                    [self hideTableView];
                    [_DataArray removeAllObjects];
                    [_zanNumArray removeAllObjects];
                    [_liulanNumArray removeAllObjects];
                    [_commentNumArray removeAllObjects];
                    [_zanedNumArray removeAllObjects];
                    [_favedNumArray removeAllObjects];
                     [_DataArray addObjectsFromArray:data];
                    for (int i  = 0; i < _DataArray.count; i ++) {
                        [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:i] objectForKey:@"zans"]]];
                        [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:i] objectForKey:@"views"]]];
                        [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:i] objectForKey:@"comments"]]];
                        NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                        if ([zaned11 isEqualToString:@"1"]) {
                            [_zanedNumArray addObject:@"1"];
                        }else{
                            [_zanedNumArray addObject:@"0"];
                        }
                        NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                        if ([faved11 isEqualToString:@"1"]) {
                            [_favedNumArray addObject:@"1"];
                        }else{
                            [_favedNumArray addObject:@"0"];
                        }
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
                [_loadingView removeFromSuperview];
                
                //网络不佳视图
                InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height * 0.75, self.view.bounds.size.width - 180, 25)];
                [self.view addSubview:errorView];
            }];
            
        }else if (index == 3){  //我的筛选列表请求
            NSLog(@"");
            _parameters = parameters;
            _fID = fID;
            NSLog(@"_parameters = %@",_parameters);
             loadMoreType = 4;
            [self hideTableView];
            [_DataArray removeAllObjects];
            [_zanNumArray removeAllObjects];
            [_liulanNumArray removeAllObjects];
            [_commentNumArray removeAllObjects];
            [_zanedNumArray removeAllObjects];
            [_favedNumArray removeAllObjects];
            for (int i  = 0; i < array.count; i ++) {
                [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
                [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
                [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
                NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                if ([zaned11 isEqualToString:@"1"]) {
                    [_zanedNumArray addObject:@"1"];
                }else{
                    [_zanedNumArray addObject:@"0"];
                }
                NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                if ([faved11 isEqualToString:@"1"]) {
                    [_favedNumArray addObject:@"1"];
                }else{
                    [_favedNumArray addObject:@"0"];
                }
            }
            [_DataArray addObjectsFromArray:array];
            [_tableview reloadData];
        }
    }];
    
    
    [self.view addSubview:_shaixuanView];
   
    _shaixuanView.hidden = YES;
    _thirdTableView.hidden = YES;
    _firstTableView.hidden = YES;
    _secondTableView.hidden = YES;

}
#pragma mark -- 初始刷新条件
- (void)beginTheNum{
    //areaID = @"0";    //地区
    //hangyeID = @"0";  //行业
    //cateID = @"0";    //类别
}
- (void)loadMoreData{
    //1.添加数据
    pageNum ++;
    if (loadMoreType == 1) {  //筛选请求
        //传入的参数
        [manager POST:[NSString stringWithFormat:@"%@article/list?access-token=%@&page=%li&psize=10",ApiUrlHead,_token,(long)pageNum] parameters:_parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSArray *data = [responseObject objectForKey:@"data"];
              
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
                    NSString *faved11  = [NSString stringWithFormat:@"%@",[[data objectAtIndex:i] objectForKey:@"faved"]];
                    if ([faved11 isEqualToString:@"1"]) {
                        [_favedNumArray addObject:@"1"];
                    }else{
                        [_favedNumArray addObject:@"0"];
                    }
                }
                [_DataArray addObjectsFromArray:data];
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
        
        
        
    }else if(loadMoreType == 2){    //非筛选
        NSMutableArray *arr = [NSMutableArray array];
       
        arr = [NSMutableArray arrayWithObjects:@"psize=10",[NSString stringWithFormat:@"area=%@",areaID],[NSString stringWithFormat:@"type=%@",cateID],[NSString stringWithFormat:@"trade=%@",hangyeID],[NSString stringWithFormat:@"access-token=%@",_token],nil];
        [arr addObject:[NSString stringWithFormat:@"page=%li",(long)pageNum]];
        
        _request = nil;
        _request = [[RequestXlJ alloc]init];
        if (arr.count > 0) {
            NSMutableString *urlstr = [NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead];
            for (int i = 0;i < arr.count;i ++){
                NSString *str;
                if (i != arr.count - 1) {
                    str = [NSString stringWithFormat:@"%@&",[arr objectAtIndex:i]];
                }else{
                    str = [arr objectAtIndex:i];
                }
                [urlstr appendString:str];
            }
            [_request requestWithUrlHead:urlstr parameter:nil methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
                
                for (int i  = 0; i < array.count; i ++) {
                    [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
                    [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
                    [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
                    NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                    if ([zaned11 isEqualToString:@"1"]) {
                        [_zanedNumArray addObject:@"1"];
                    }else{
                        [_zanedNumArray addObject:@"0"];
                    }
                    NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                    if ([faved11 isEqualToString:@"1"]) {
                        [_favedNumArray addObject:@"1"];
                    }else{
                        [_favedNumArray addObject:@"0"];
                    }
                }
                [_DataArray addObjectsFromArray:array];
                [_tableview reloadData];
                
            }];
        }else{
            [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead] parameter:arr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
                //NSLog(@"code = %li",(long)code);
                //NSLog(@"error = %@",error);
                //NSLog(@"dictionary = %@",dictionary);
                NSLog(@"array = %@",array);
                for (int i  = 0; i < array.count; i ++) {
                    [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
                    [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
                    [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
                    NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                    if ([zaned11 isEqualToString:@"1"]) {
                        [_zanedNumArray addObject:@"1"];
                    }else{
                        [_zanedNumArray addObject:@"0"];
                    }
                    NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                    if ([faved11 isEqualToString:@"1"]) {
                        [_favedNumArray addObject:@"1"];
                    }else{
                        [_favedNumArray addObject:@"0"];
                    }
                }
                [_DataArray addObjectsFromArray:array];
                [_tableview reloadData];
                
            }];
            
        
        }

    
    }else  if(loadMoreType == 3){  //搜索
        NSString *urlStr = [NSString stringWithFormat:@"%@article/so?access-token=%@&wd=%@&page=%li&psize=10",ApiUrlHead,_token,_searchTextField.text,(long)pageNum];
        NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSArray *arr = [responseObject objectForKey:@"data"];
                for (int i  = 0; i < arr.count; i ++) {
                    [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zans"]]];
                    [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"views"]]];
                    [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"comments"]]];
                    NSString *zaned11  = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zaned"]];
                    if ([zaned11 isEqualToString:@"1"]) {
                        [_zanedNumArray addObject:@"1"];
                    }else{
                        [_zanedNumArray addObject:@"0"];
                    }
                    NSString *faved11  = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"faved"]];
                    if ([faved11 isEqualToString:@"1"]) {
                        [_favedNumArray addObject:@"1"];
                    }else{
                        [_favedNumArray addObject:@"0"];
                    }
                }
                [_DataArray addObjectsFromArray:arr];
                [_tableview reloadData];
                
            }else if (![code isEqualToString:@"0"]){
                
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            //网络不佳视图
            InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height * 0.75, self.view.bounds.size.width - 180, 25)];
            [self.view addSubview:errorView];
            
        }];
    
    }else  if(loadMoreType == 4){   //我的记录筛选
        NSString *urlStr =[NSString stringWithFormat:@"%@article/list?page=%li&psize=10&fid=%@&access-token=%@",ApiUrlHead,(long)pageNum,_fID,_token];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSArray *data = [responseObject objectForKey:@"data"];
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
                    NSString *faved11  = [NSString stringWithFormat:@"%@",[[data objectAtIndex:i] objectForKey:@"faved"]];
                    if ([faved11 isEqualToString:@"1"]) {
                        [_favedNumArray addObject:@"1"];
                    }else{
                        [_favedNumArray addObject:@"0"];
                    }
                }
                [_DataArray addObjectsFromArray:data];
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
        
        
        
    }else{
        //请求投标数据列表
        _request = nil;
        _request = [[RequestXlJ alloc]init];
        [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?page=%li&psize=10&access-token=%@",ApiUrlHead,(long)pageNum,_token] parameter:nil methed:@"post" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
            //NSLog(@"code = %li",(long)code);
            //NSLog(@"error = %@",error);
            //NSLog(@"dictionary = %@",dictionary);
            NSLog(@"array = %@",array);
            for (int i  = 0; i < array.count; i ++) {
                [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
                [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
                [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
                NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                if ([zaned11 isEqualToString:@"1"]) {
                    [_zanedNumArray addObject:@"1"];
                }else{
                    [_zanedNumArray addObject:@"0"];
                }
                NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                if ([faved11 isEqualToString:@"1"]) {
                    [_favedNumArray addObject:@"1"];
                }else{
                    [_favedNumArray addObject:@"0"];
                }
            }
            [_DataArray addObjectsFromArray:array];
            
            [_tableview reloadData];
        }];
    
    
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        //刷新表格
        //[_tableview reloadData];
        //拿到当前的上拉刷新控件，结束刷新状态
        [_tableview.footer endRefreshing];
    });
}
- (void)shaixuanAction:(ToubiaoChooseButton *)btn{
    btn.selected = !btn.selected;
    if (number == 0) {
        //初始化数据，判断给出的Key对应的数据是否存在
        if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"Article"]) {
            //存在，则替换之
            NSMutableDictionary * resultDictionary = [[NSMutableDictionary alloc] init];
            [[WBBooksManager sharedInstance] readPlist:&resultDictionary];
            _ArticleDic = [resultDictionary objectForKey:@"Article"];
            //NSLog(@"ArticleDic = %@",_ArticleDic);
        }else{//不存在，则写入
            NSString *urlStr = [NSString stringWithFormat:@"%@article/fitems",ApiUrlHead];
            _request = [[RequestXlJ alloc]init];
            [_request requestWithUrl:urlStr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary * responseObject,NSArray *array){
                //NSLog(@"code = %li",(long)code);
                //NSLog(@"responseObject = %@",responseObject);
                if (code == 0) {
                    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                    _ArticleDic = userDic;
                    [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"Article"];
                }else{
                    NSLog(@"加载失败");
                    
                }
            }];
        }
        number ++;
    }
    //给筛选界面传token
    if (_token.length > 0) {
        _shaixuanView.token = _token;
    }
    
    //请求我保存的搜索设置
    NSString *myChoose = [NSString stringWithFormat:@"%@filter/list?access-token=%@",ApiUrlHead,_token];
    [manager GET:myChoose parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *data = [responseObject objectForKey:@"data"];
            _shaixuanView.myChooseArray = data;
            
        }else if (![code isEqualToString:@"0"]){
            NSString *error = [responseObject objectForKey:@"err"];
            NSLog(@"error=%@",error);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];
    
    switch (btn.tag) {
        case 0:       //地区
        {
            NSLog(@"1");
           
            loadMoreType = 2;
            [self beginTheNum];
            _thirdTableView.hidden = YES;
            _shaixuanView.hidden = YES;
            if (btn.selected == YES) {
                _tcButton2.selected = NO;
                _tcButton3.selected = NO;
                _tcButton4.selected = NO;
                 _firstTableView.hidden = NO;
                _secondTableView.hidden = NO;
                
                _grayView.hidden = NO;
                NSArray *array0 = [[_ArticleDic objectForKey:@"areas"]allKeys];
                NSArray *array2 = [[_ArticleDic objectForKey:@"areas"]allValues];
                NSMutableArray *array1 = [NSMutableArray array];
                [array1 addObject:@"全部"];
                [array1 addObjectsFromArray:array0];
                
                
                [_firstTableView tableReloadData:array1 frame:CGRectMake(0, 34, 135, 330) block:^(NSInteger index){
                    areaSelectNum = index;
                    shengSelectNum = 0;
                    NSDictionary * dic2 = [NSDictionary dictionary];
                    NSArray * array5 = [NSArray array];
                    NSMutableArray *array3 = [NSMutableArray array];
                    NSArray *array4 = [NSArray array];
                    if (index > 0) {
                        dic2 = [array2 objectAtIndex:index - 1];
                        array5 = [dic2 allValues];
                        [array3 addObject:@"全部"];
                        [array3 addObjectsFromArray:array5];
                        array4 = [dic2 allKeys];
                        [_secondTableView tableReloadData:array3 frame:CGRectMake(_firstTableView.bounds.size.width, 34,self.view.bounds.size.width - _firstTableView.bounds.size.width,10) block:^(NSInteger index){
                            [self.view addSubview:_loadingView];
                            
                            pageNum = 1;
                            if (index > 0) {
                                shengSelectNum = index;
                                NSLog(@"index = %li",(long)index);
                                areaID = [array4 objectAtIndex:index - 1];
                                
                                NSMutableArray *arr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"area=%@",areaID],[NSString stringWithFormat:@"type=%@",cateID],[NSString stringWithFormat:@"trade=%@",hangyeID],@"psize=10",[NSString stringWithFormat:@"access-token=%@",_token],nil];
                                [arr addObject:[NSString stringWithFormat:@"page=%i",1]];
                                NSLog(@"arr = %@",arr);
                                [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead] parameter:arr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
                                    [_loadingView removeFromSuperview];
                                    
                                    NSLog(@"code = %li",(long)code);
                                    NSLog(@"error = %@",error);
                                    //NSLog(@"dictionary = %@",dictionary);
                                    //NSLog(@"array = %@",array);
                                    pageNum = 1;
                                    [_DataArray removeAllObjects];
                                    [_zanNumArray removeAllObjects];
                                    [_liulanNumArray removeAllObjects];
                                    [_commentNumArray removeAllObjects];
                                    [_zanedNumArray removeAllObjects];
                                    [_favedNumArray removeAllObjects];
                                    for (int i  = 0; i < array.count; i ++) {
                                        [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
                                        [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
                                        [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
                                        NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                                        if ([zaned11 isEqualToString:@"1"]) {
                                            [_zanedNumArray addObject:@"1"];
                                        }else{
                                            [_zanedNumArray addObject:@"0"];
                                        }
                                        NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                                        if ([faved11 isEqualToString:@"1"]) {
                                            [_favedNumArray addObject:@"1"];
                                        }else{
                                            [_favedNumArray addObject:@"0"];
                                        }
                                    }
                                    [_DataArray addObjectsFromArray:array];
                                    [_tableview reloadData];
                                    [self hideTableView];
                                }];

                            }else{
                                 for (int i = 0 ;i < array4.count; i ++) {
                                    NSString *areaStr = [array4 objectAtIndex:i];
                                    if (i < array4.count - 1) {
                                        areaID = [NSString stringWithFormat:@"%@%@,",areaID,areaStr];
                                    }else{
                                        areaID = [NSString stringWithFormat:@"%@%@",areaID,areaStr];
                                    }
                                   
                                    //[NSString stringWithFormat:@"%@",[[array objectAtIndex:i]
                                }
                                NSLog(@"areaIDs = %@",areaID);
                                NSMutableArray *arr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"area=%@",areaID],[NSString stringWithFormat:@"type=%@",cateID],[NSString stringWithFormat:@"trade=%@",hangyeID],@"psize=10",[NSString stringWithFormat:@"access-token=%@",_token],nil];
                                [arr addObject:[NSString stringWithFormat:@"page=%i",1]];
                                NSLog(@"arr = %@",arr);
                                [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead] parameter:arr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
                                   
                                    [_loadingView removeFromSuperview];
                                    
                                    pageNum = 1;
                                    [_DataArray removeAllObjects];
                                    [_zanNumArray removeAllObjects];
                                    [_liulanNumArray removeAllObjects];
                                    [_commentNumArray removeAllObjects];
                                    [_zanedNumArray removeAllObjects];
                                    [_favedNumArray removeAllObjects];
                                    for (int i  = 0; i < array.count; i ++) {
                                        [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
                                        [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
                                        [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
                                        NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                                        if ([zaned11 isEqualToString:@"1"]) {
                                            [_zanedNumArray addObject:@"1"];
                                        }else{
                                            [_zanedNumArray addObject:@"0"];
                                        }
                                        NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                                        if ([faved11 isEqualToString:@"1"]) {
                                            [_favedNumArray addObject:@"1"];
                                        }else{
                                            [_favedNumArray addObject:@"0"];
                                        }
                                    }
                                    [_DataArray addObjectsFromArray:array];
                                    [_tableview reloadData];
                                    [self hideTableView];
                                }];

                            
                            }
                    
                        }];

                    }else{   //选择地区全部
                        areaID = @"";
                        pageNum = 1;
                        NSMutableArray *arr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"area=%@",areaID],[NSString stringWithFormat:@"type=%@",cateID],[NSString stringWithFormat:@"trade=%@",hangyeID],@"psize=10",[NSString stringWithFormat:@"access-token=%@",_token],nil];
                        [arr addObject:[NSString stringWithFormat:@"page=%i",1]];
                          NSLog(@"arr = %@",arr);
                        [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead] parameter:arr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
                            [_loadingView removeFromSuperview];
                            
                            pageNum = 1;
                            [_DataArray removeAllObjects];
                            [_zanNumArray removeAllObjects];
                            [_liulanNumArray removeAllObjects];
                            [_commentNumArray removeAllObjects];
                            [_zanedNumArray removeAllObjects];
                            [_favedNumArray removeAllObjects];
                            for (int i  = 0; i < array.count; i ++) {
                                [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
                                [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
                                [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
                                NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                                if ([zaned11 isEqualToString:@"1"]) {
                                    [_zanedNumArray addObject:@"1"];
                                }else{
                                    [_zanedNumArray addObject:@"0"];
                                }
                                NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                                if ([faved11 isEqualToString:@"1"]) {
                                    [_favedNumArray addObject:@"1"];
                                }else{
                                    [_favedNumArray addObject:@"0"];
                                }
                            }
                            [_DataArray addObjectsFromArray:array];
                            [_tableview reloadData];
                            [self hideTableView];
                        }];
                   
                    }
                 
                    if (array3.count > 0) {
                        NSIndexPath *ip2=[NSIndexPath indexPathForRow:shengSelectNum inSection:0];
                         [_secondTableView selectRowAtIndexPath:ip2 animated:YES scrollPosition:UITableViewScrollPositionBottom];
                    }
               
                }];
                NSMutableArray *array3 = [NSMutableArray array];
                NSArray *array4 = [NSArray array];
                if (areaSelectNum > 0) {
                    NSDictionary * dic2 = [array2 objectAtIndex:areaSelectNum - 1];
                    NSArray *arr = [dic2 allValues];
                    [array3 addObject:@"全部"];
                    [array3 addObjectsFromArray:arr];
                    array4 = [dic2 allKeys];
                }
              
                
                //tableview默认选中某一行
                if (array1.count > 0) {
                    NSIndexPath *ip=[NSIndexPath indexPathForRow:areaSelectNum inSection:0];
                    [_firstTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
                }
                 //刷新城市
                [_secondTableView tableReloadData:array3 frame:CGRectMake(_firstTableView.bounds.size.width, 34,self.view.bounds.size.width - _firstTableView.bounds.size.width,10) block:^(NSInteger index){
                    [self.view addSubview:_loadingView];
                    
                    
                    pageNum = 1;
                    if (index > 0) {
                        shengSelectNum = index;
                        NSLog(@"index = %li",(long)index);
                        areaID = [array4 objectAtIndex:index - 1];
                        
                        NSMutableArray *arr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"area=%@",areaID],[NSString stringWithFormat:@"type=%@",cateID],[NSString stringWithFormat:@"trade=%@",hangyeID],@"psize=10",[NSString stringWithFormat:@"access-token=%@",_token],nil];
                        [arr addObject:[NSString stringWithFormat:@"page=%i",1]];
                        NSLog(@"arr = %@",arr);
                        [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead] parameter:arr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
                            [_loadingView removeFromSuperview];
                            
                           
                            [_DataArray removeAllObjects];
                            [_zanNumArray removeAllObjects];
                            [_liulanNumArray removeAllObjects];
                            [_commentNumArray removeAllObjects];
                            [_zanedNumArray removeAllObjects];
                            [_favedNumArray removeAllObjects];
                            for (int i  = 0; i < array.count; i ++) {
                                [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
                                [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
                                [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
                                NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                                if ([zaned11 isEqualToString:@"1"]) {
                                    [_zanedNumArray addObject:@"1"];
                                }else{
                                    [_zanedNumArray addObject:@"0"];
                                }
                                NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                                if ([faved11 isEqualToString:@"1"]) {
                                    [_favedNumArray addObject:@"1"];
                                }else{
                                    [_favedNumArray addObject:@"0"];
                                }
                            }
                            [_DataArray addObjectsFromArray:array];
                            [_tableview reloadData];
                            [self hideTableView];
                        }];
                        
                    }else{
                        for (int i = 0 ;i < array4.count; i ++) {
                            NSString *areaStr = [array4 objectAtIndex:i];
                            if (i < array4.count - 1) {
                                areaID = [NSString stringWithFormat:@"%@%@,",areaID,areaStr];
                            }else{
                                areaID = [NSString stringWithFormat:@"%@%@",areaID,areaStr];
                            }
                            
                            //[NSString stringWithFormat:@"%@",[[array objectAtIndex:i]
                        }
                        pageNum = 1;
                        NSLog(@"areaIDs = %@",areaID);
                        NSMutableArray *arr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"area=%@",areaID],[NSString stringWithFormat:@"type=%@",cateID],[NSString stringWithFormat:@"trade=%@",hangyeID],@"psize=10",[NSString stringWithFormat:@"access-token=%@",_token],nil];
                        [arr addObject:[NSString stringWithFormat:@"page=%i",1]];
                        NSLog(@"arr = %@",arr);
                        [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead] parameter:arr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
                            [_loadingView removeFromSuperview];
                            
                            
                            [_DataArray removeAllObjects];
                            [_zanNumArray removeAllObjects];
                            [_liulanNumArray removeAllObjects];
                            [_commentNumArray removeAllObjects];
                            [_zanedNumArray removeAllObjects];
                            [_favedNumArray removeAllObjects];
                            for (int i  = 0; i < array.count; i ++) {
                                [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
                                [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
                                [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
                                NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                                if ([zaned11 isEqualToString:@"1"]) {
                                    [_zanedNumArray addObject:@"1"];
                                }else{
                                    [_zanedNumArray addObject:@"0"];
                                }
                                NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                                if ([faved11 isEqualToString:@"1"]) {
                                    [_favedNumArray addObject:@"1"];
                                }else{
                                    [_favedNumArray addObject:@"0"];
                                }
                            }
                            [_DataArray addObjectsFromArray:array];
                            [_tableview reloadData];
                            [self hideTableView];
                        }];
                        
                        
                    }
                    
                }];
                if (array3.count > 0) {
                    NSIndexPath *ip2=[NSIndexPath indexPathForRow:shengSelectNum inSection:0];
                    [_secondTableView selectRowAtIndexPath:ip2 animated:YES scrollPosition:UITableViewScrollPositionBottom];
                }
            }else{
                _firstTableView.hidden = YES;
                _secondTableView.hidden = YES;
                //[_firstTableView deselectRowAtIndexPath:(NSIndexPath *)firstTableViewIndex animated:YES];
            }
        
        }
            break;
        case 1:      //行业
        {
            loadMoreType = 2;
            [self beginTheNum];
            NSLog(@"2");
            if (btn.selected == YES) {
                _tcButton1.selected = NO;
                _tcButton3.selected = NO;
                _tcButton4.selected = NO;
                _firstTableView.hidden = YES;
                _secondTableView.hidden = YES;
                _shaixuanView.hidden = YES;
                _thirdTableView.hidden = NO;
                _grayView.hidden = NO;
                
                NSArray *array1 = [[_ArticleDic objectForKey:@"trades"]allKeys];     //ID
                NSArray *array0 = [[_ArticleDic objectForKey:@"trades"]allValues];   //名称
                NSMutableArray *array2 = [NSMutableArray array];
                [array2 addObject:@"全部"];
                [array2 addObjectsFromArray:array0];
                
                [_thirdTableView tableReloadData:array2 frame:CGRectMake(0, 34, 135, 330) block:^(NSInteger index){
                    [self.view addSubview:_loadingView];
                    
                    pageNum = 1;
                    tradeSelectNum = index;
                    NSLog(@"index = %li",(long)index);
                    if (index > 0) {
                        hangyeID = [array1 objectAtIndex:index - 1];
                    }else{
                        hangyeID = @"";
                    }
                    NSMutableArray *arr = [NSMutableArray array];
                    arr =  [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"trade=%@",hangyeID],[NSString stringWithFormat:@"type=%@",cateID],[NSString stringWithFormat:@"area=%@",areaID],@"psize=10",[NSString stringWithFormat:@"access-token=%@",_token],nil];
                    
                    [arr addObject:[NSString stringWithFormat:@"page=%li",(long)pageNum]];
                    _request = nil;
                    _request = [[RequestXlJ alloc]init];
                    [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead] parameter:arr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
                        [_loadingView removeFromSuperview];
                        
                        pageNum = 1;
                        [_DataArray removeAllObjects];
                        [_zanNumArray removeAllObjects];
                        [_liulanNumArray removeAllObjects];
                        [_commentNumArray removeAllObjects];
                        [_zanedNumArray removeAllObjects];
                        [_favedNumArray removeAllObjects];
                        for (int i  = 0; i < array.count; i ++) {
                            [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
                            [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
                            [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
                            NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                            if ([zaned11 isEqualToString:@"1"]) {
                                [_zanedNumArray addObject:@"1"];
                            }else{
                                [_zanedNumArray addObject:@"0"];
                            }
                            NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                            if ([faved11 isEqualToString:@"1"]) {
                                [_favedNumArray addObject:@"1"];
                            }else{
                                [_favedNumArray addObject:@"0"];
                            }
                        }
                        [_DataArray addObjectsFromArray:array];
                        [_tableview reloadData];
                        [self hideTableView];
                    }];
                    
                }];
                //tableview默认选中某一行
                if (array2.count > 0) {
                    NSIndexPath *ip=[NSIndexPath indexPathForRow:tradeSelectNum inSection:0];
                    [_thirdTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
                }
            }else{
                _firstTableView.hidden = YES;
                _secondTableView.hidden = YES;
                _thirdTableView.hidden = YES;
                _shaixuanView.hidden = YES;
            }
        }
            break;
        case 2:       //类别
        {
            loadMoreType = 2;
            [self beginTheNum];
            NSLog(@"3");
            if (btn.selected == YES) {
                _tcButton2.selected = NO;
                _tcButton1.selected = NO;
                _tcButton4.selected = NO;
                _firstTableView.hidden = YES;
                _secondTableView.hidden = YES;
                _thirdTableView.hidden = NO;
                _shaixuanView.hidden = YES;
                _grayView.hidden = NO;
                
                NSArray *array1 = [[_ArticleDic objectForKey:@"types"]allKeys];
                NSArray *array0 = [[_ArticleDic objectForKey:@"types"]allValues];
                NSMutableArray *array2 = [NSMutableArray array];
                [array2 addObject:@"全部"];
                [array2 addObjectsFromArray:array0];
                [_thirdTableView tableReloadData:array2 frame:CGRectMake(0, 34, 135, 330) block:^(NSInteger index){
                    [self.view addSubview:_loadingView];
                    
                    typeSelectNum = index;
                    pageNum = 1;
                    NSLog(@"index = %li",(long)index);
                    if (index > 0) {
                        cateID = [array1 objectAtIndex:index - 1];
                    }else{
                        cateID = @"";
                    }
                    NSMutableArray *arr = [NSMutableArray array];
                    arr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"type=%@",cateID],[NSString stringWithFormat:@"trade=%@",hangyeID],[NSString stringWithFormat:@"area=%@",areaID],@"psize=10",[NSString stringWithFormat:@"access-token=%@",_token],nil];
                    [arr addObject:[NSString stringWithFormat:@"page=%li",(long)pageNum]];
                    
                    /*if (index > 0) {
                        hangyeID = [array1 objectAtIndex:index - 1];
                    }else{
                        hangyeID = @"";
                    }
                   
                    if ([hangyeID isEqualToString:@""]) {
                        arr =  [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"trade=%@",hangyeID],@"psize=10",[NSString stringWithFormat:@"access-token=%@",_token],nil];
                    }else{
                        arr =  [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"trade=%@",hangyeID],@"psize=10",[NSString stringWithFormat:@"access-token=%@",_token],nil];
                    }
                    [arr addObject:[NSString stringWithFormat:@"page=%li",(long)pageNum]];*/
                    _request = nil;
                    _request = [[RequestXlJ alloc]init];
                    [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead] parameter:arr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
                        [_loadingView removeFromSuperview];
                        
                        pageNum = 1;
                        [_DataArray removeAllObjects];
                        [_zanNumArray removeAllObjects];
                        [_liulanNumArray removeAllObjects];
                        [_commentNumArray removeAllObjects];
                        [_zanedNumArray removeAllObjects];
                        [_favedNumArray removeAllObjects];
                        for (int i  = 0; i < array.count; i ++) {
                            [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zans"]]];
                            [_liulanNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"views"]]];
                            [_commentNumArray addObject:[NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"comments"]]];
                            NSString *zaned11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"zaned"]];
                            if ([zaned11 isEqualToString:@"1"]) {
                                [_zanedNumArray addObject:@"1"];
                            }else{
                                [_zanedNumArray addObject:@"0"];
                            }
                            NSString *faved11  = [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"faved"]];
                            if ([faved11 isEqualToString:@"1"]) {
                                [_favedNumArray addObject:@"1"];
                            }else{
                                [_favedNumArray addObject:@"0"];
                            }
                        }
                        [_DataArray addObjectsFromArray:array];
                        [_tableview reloadData];
                        [self hideTableView];
                    }];
                    

                    
                }];
                //tableview默认选中某一行
                if (array2.count > 0) {
                    NSIndexPath *ip=[NSIndexPath indexPathForRow:typeSelectNum inSection:0];
                    [_thirdTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
                }
               
            }else{
                _firstTableView.hidden = YES;
                _secondTableView.hidden = YES;
                _thirdTableView.hidden = YES;
                _shaixuanView.hidden = YES;
            }
        }
            break;
        case 3:
        {
            loadMoreType = 1;
            [self beginTheNum];
             NSLog(@"4");
            if (btn.selected == YES) {
                _tcButton2.selected = NO;
                _tcButton3.selected = NO;
                _tcButton1.selected = NO;
                _grayView.hidden = NO;
                _firstTableView.hidden = YES;
                _secondTableView.hidden = YES;
                _thirdTableView.hidden = YES;
                _shaixuanView.hidden = NO;
              
            }else{
                _firstTableView.hidden = YES;
                _secondTableView.hidden = YES;
                _thirdTableView.hidden = YES;
                _shaixuanView.hidden = YES;
            }
        }
            break;
        default:
            break;
    }
    
    [self appearGrayView];    //显示阴影
    
}
#pragma mark -- 收起筛选视图
- (void)hideTableView{
    _tcButton2.selected = NO;
    _tcButton3.selected = NO;
    _tcButton1.selected = NO;
    _tcButton4.selected = NO;
    _grayView.hidden = YES;
    _firstTableView.hidden = YES;
    _secondTableView.hidden = YES;
    _thirdTableView.hidden = YES;
    _shaixuanView.hidden = YES;

}
- (void)appearGrayView{
    if (_firstTableView.hidden == NO||_thirdTableView.hidden == NO||_shaixuanView.hidden == NO) {
         _grayView.hidden = NO;
    }else{
        _grayView.hidden = YES;
    }
}
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
#pragma mark -tableViewDelegate
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
    
    LableXLJ *detailTitle = [[LableXLJ alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 45) text:[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"summary"] textColor:[UIColor colorWithWhite:0 alpha:1] font:(int)_detailFont numberOfLines:3 lineSpace:(int)_detailSepFont - 8];
    CGFloat h2 = detailTitle.bounds.size.height;
    //NSLog(@"h1 = %f,h2 = %f",h1,h2);
    title = nil;
    detailTitle = nil;
    
    return h1 + h2 + 70;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier1 = @"statusCell1";
    ToubiaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (cell == nil) {
        cell = [[ToubiaoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1 title:[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"title"]
                                                   hangye:[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"trades"]
                                                 location:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"area"]]
                                                     time:[TimeXLJ returnUploadTime_no1970:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"created_at"]]]
                                                   detail:[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"summary"] titleFont:_titleFont  - 2
                                                lableFont:_lableFont DetailFont:_detailFont titleSepFont:_titleSepFont  - 2 detailSepFont:_detailSepFont  - 8];
        
        
        
   }else{
       [cell title:[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"title"]
            hangye:[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"trades"]
          location:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"area"]]
              time:[TimeXLJ returnUploadTime_no1970:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"created_at"]]]
            detail:[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"summary"]
         titleFont:_titleFont  - 2
         lableFont:_lableFont
        DetailFont:_detailFont
      titleSepFont:_titleSepFont  - 2
     detailSepFont:_detailSepFont - 8];
    }
    
    [cell.tanChuangView removeFromSuperview];
    //赞的数量
    NSString *zannum1 = [[_DataArray objectAtIndex:indexPath.row] objectForKey:@"zans"];
     NSString *zaned = [_zanedNumArray objectAtIndex:indexPath.row];
    if ([zaned isEqualToString:@"1"]) {
        [cell.zanbtn setImage:[UIImage imageNamed:@"zaned_Img@2x"] forState:UIControlStateNormal];
    }else{
       [cell.zanbtn setImage:[UIImage imageNamed:@"zhaobiaozan@2x"] forState:UIControlStateNormal];
    }
    [cell.zanbtn setTitle:[_zanNumArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [cell.liulanbtn setTitle:[_liulanNumArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [cell.pinglunbtn setTitle:[_commentNumArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    __block int number1 = 0;
    
    cell.number = number1;
    [cell blockButtonAction:^(NSInteger index,NSInteger selectNum){
        NSLog(@"index = %li,indexPath.row = %li",(long)index,(long)indexPath.row);
        if (index == 0) {
            NSString *str = [_zanedNumArray objectAtIndex:indexPath.row];
            NSLog(@"str += %@",str);
            if ([str isEqualToString:@"1"]) {
                  NSLog(@"取消点赞");
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
                            NSString *zanstr = [_zanNumArray objectAtIndex:indexPath.row];
                            int x = [zanstr intValue];
                            x -- ;
                            [_zanNumArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%i",x]];
                            //[_zanNumArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"zans"]]];
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
                __block int zannum = [zannumStr intValue];
                zannum ++;
                NSLog(@"zannum = %i",zannum);
                [_zanedNumArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
                [_zanNumArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%i",zannum]];
                [cell.zanbtn setTitle:[NSString stringWithFormat:@"%i",zannum] forState:UIControlStateNormal];
                //点赞
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
                    _tanChuangView.frame = CGRectMake(self.view.bounds.size.width - 155, cell.zanbtn.frame.origin.y - 20, 140, 25);
                    _tanChuangView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
                    _tanChuangView.tag = indexPath.row;
                    [cell.contentView addSubview:_tanChuangView];
                    
                    _tanChuangView.layer.masksToBounds = YES;
                    _tanChuangView.layer.cornerRadius = 4;
                    
                    _fenxiangButton.frame =  CGRectMake(10, _tanChuangView.bounds.size.height * 0.2, _tanChuangView.bounds.size.width * 0.5, _tanChuangView.bounds.size.height * 0.6);
                    _shoucanButton.frame = CGRectMake(_tanChuangView.bounds.size.width * 0.5 + 10, _tanChuangView.bounds.size.height * 0.2, _tanChuangView.bounds.size.width * 0.5, _tanChuangView.bounds.size.height * 0.6);
                    NSString *faved = [_favedNumArray objectAtIndex:indexPath.row];
                    if ([faved isEqualToString:@"1"]) {
                        [_shoucanButton setImage:[UIImage imageNamed:@"faved_img_small2x"] forState:UIControlStateNormal];
                    }else{
                        [_shoucanButton setImage:[UIImage imageNamed:@"fengfen1@2x"] forState:UIControlStateNormal];
                    }
                }else{
                    _tanChuangView.hidden = YES;
                }
                
            }else{
                _tanChuangView.hidden = NO;
                _tanChuangView.frame = CGRectMake(self.view.bounds.size.width - 155, cell.zanbtn.frame.origin.y - 20, 140, 25);
                _tanChuangView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
                _tanChuangView.tag = indexPath.row;
                [cell.contentView addSubview:_tanChuangView];
                
                _tanChuangView.layer.masksToBounds = YES;
                _tanChuangView.layer.cornerRadius = 4;
                
                
                _fenxiangButton.frame =  CGRectMake(10, _tanChuangView.bounds.size.height * 0.2, _tanChuangView.bounds.size.width * 0.5, _tanChuangView.bounds.size.height * 0.6);
                
                _shoucanButton.frame = CGRectMake(_tanChuangView.bounds.size.width * 0.5 + 10, _tanChuangView.bounds.size.height * 0.2, _tanChuangView.bounds.size.width * 0.5, _tanChuangView.bounds.size.height * 0.6);
                NSString *faved = [_favedNumArray objectAtIndex:indexPath.row];
                if ([faved isEqualToString:@"1"]) {
                    [_shoucanButton setImage:[UIImage imageNamed:@"faved_img_small2x"] forState:UIControlStateNormal];
                }else{
                    [_shoucanButton setImage:[UIImage imageNamed:@"fengfen1@2x"] forState:UIControlStateNormal];
                }
                
            }
            
             tanchuanTag = indexPath.row;
            NSLog(@"indexPath.row = %li",(long)indexPath.row);
           
                            //}else if (cell.number == 1){
                //[_tanChuangView removeFromSuperview];
                //cell.number = 0;
            //}
         }
    }];
    
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
     _tanChuangView.hidden = YES;
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
            NSString *faved = [_favedNumArray objectAtIndex:btn.superview.tag];
            if ([faved isEqualToString:@"0"]) {
                NSString *urlStr = [NSString stringWithFormat:@"%@favorite/new?access-token=%@&aid=%@",ApiUrlHead,_token,[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:btn.superview.tag] objectForKey:@"id"]]];
                
                [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                    if ([code isEqualToString:@"0"]) {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"收藏成功" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                        [alert show];
                        [_favedNumArray replaceObjectAtIndex:btn.superview.tag withObject:@"1"];
                        
                    }else if (![code isEqualToString:@"0"]){
                        NSString *error = [responseObject objectForKey:@"err"];
                        NSLog(@"error=%@",error);
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                        [alert show];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    
                    
                }];

            }else{
                NSString *urlStr = [NSString stringWithFormat:@"%@favorite/del?id=%@&access-token=%@",ApiUrlHead,[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:btn.superview.tag] objectForKey:@"id"]],_token];
                [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                    if ([code isEqualToString:@"0"]) {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已取消收藏" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                        [alert show];
                        [_favedNumArray replaceObjectAtIndex:btn.superview.tag withObject:@"0"];
                        
                        
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
                    }
            break;
            
        default:
            break;
    }
    //一个cell刷新
    _tanChuangView.hidden = YES;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:btn.superview.tag inSection:0];
    [_tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    indexPath_rowNum = indexPath.row;
    
    ToubiaoDetailViewController *Tvc = [[ToubiaoDetailViewController alloc]init];
    Tvc.ifFromToubiao = @"toubiao";
    Tvc.token = _token;
    Tvc.uid = _uid;
    Tvc.toubiaoID = [NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    Tvc.time = [TimeXLJ returnUploadTime_no1970:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"created_at"]]];
    [self.navigationController pushViewController:Tvc animated:YES];
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

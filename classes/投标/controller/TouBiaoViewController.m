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
static TouBiaoViewController *instance;
@interface TouBiaoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView *tableview;

@property (nonatomic ,strong)__block ChooseTableView *firstTableView; //筛选一级视图
@property (nonatomic ,strong)__block ChooseTableView2 *secondTableView; //筛选二级视图
@property (nonatomic ,strong)__block ChooseTableView2 *thirdTableView; //筛选二级视图
@property (nonatomic ,strong)ChooseView_shaixuanView *shaixuanView;
@property (nonatomic ,strong)NSMutableArray *BigArray;
@property (nonatomic ,strong)NSMutableArray *SmallArray;
@property (nonatomic ,strong)ToubiaoChooseButton *tcButton1;    //筛选按钮
@property (nonatomic ,strong)ToubiaoChooseButton *tcButton2;
@property (nonatomic ,strong)ToubiaoChooseButton *tcButton3;
@property (nonatomic ,strong)ToubiaoChooseButton2 *tcButton4;
@property (nonatomic ,strong)NSArray *chooseArray;      //数据源

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) UIButton *lestButton;
@property (strong, nonatomic) UIBarButtonItem *leftItem;
@property (strong, nonatomic)__block RequestXlJ *request;
@property (strong, nonatomic)NSMutableDictionary *ArticleDic;  //初始化数据
@property (strong, nonatomic)__block NSMutableArray *DataArray;
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
    
   
    // this UIViewController is about to re-appear, make sure we remove the current selection in our table view
    NSIndexPath *tableSelection = [self.tableview indexPathForSelectedRow];
    [self.tableview deselectRowAtIndexPath:tableSelection animated:NO];
    [MobClick beginLogPageView:@"ToubiaoMainPage"];
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
         UIImage *backImg = [UIImage imageNamed:@"caidan@2x"];
        MyItemButton *backBtn = [[MyItemButton alloc] initWithFrame:CGRectMake(0.f, 0.f, backImg.size.width/0.6, backImg.size.height/0.6)];
         [backBtn addTarget:self action:@selector(push1) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:backImg forState:UIControlStateNormal];
        UIView *backBtnView = [[UIView alloc] initWithFrame:backBtn.bounds];
        backBtnView.bounds = CGRectOffset(backBtnView.bounds, 10, 0);
        [backBtnView addSubview:backBtn];
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
        self.navigationItem.leftBarButtonItem = backBarBtn;
 
        
        UIImage *backImg1 = [UIImage imageNamed:@"tianjia@2x"];
        MyItemButton *backBtn1 = [[MyItemButton alloc] initWithFrame:CGRectMake(0.f, 0.f, backImg1.size.width/0.6, backImg1.size.height/0.6)];
        [backBtn1 addTarget:self action:@selector(push2) forControlEvents:UIControlEventTouchUpInside];
        [backBtn1 setImage:backImg1 forState:UIControlStateNormal];
        UIView *backBtnView1 = [[UIView alloc] initWithFrame:backBtn1.bounds];
        backBtnView1.bounds = CGRectOffset(backBtnView.bounds, -20, 0);
        [backBtnView1 addSubview:backBtn1];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:backBtnView1];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        //self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

-(void)push1{
    //NSLog(@"_lestButton.frame = %f ,%f ,%f ,%f ",_lestButton.frame.origin.x,_lestButton.frame.origin.y,_lestButton.frame.size.width,_lestButton.frame.size.height);
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController = [delegate siderViewController];
    //sideViewController.needSwipeShowMenu = true;
    [sideViewController showLeftViewController:YES];
  
    //显示主界面半透明视图
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewAppear" object:nil userInfo:nil];
}
-(void)push2{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //if_FirstAppear = YES;
    //self.tabBarController.tabBar.hidden = YES;
    number = 0;
    _BigArray = [NSMutableArray array];
    _SmallArray = [NSMutableArray array];
    _DataArray = [NSMutableArray array];
    pageNum = 1;
    areaID = @"0";
    hangyeID = @"0";
    cateID = @"0";
    
    manager = [AFHTTPRequestOperationManager manager];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    
    //实例话tableview并集成刷新空间
    [self initTableView];
    //添加筛选按钮
    [self addHeadView];
    
    
    //请求投标数据列表
    _request = nil;
    _request = [[RequestXlJ alloc]init];
    [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead] parameter:nil methed:@"post" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
        //NSLog(@"code = %li",(long)code);
        //NSLog(@"error = %@",error);
        //NSLog(@"dictionary = %@",dictionary);
        NSLog(@"array = %@",array);
        
        [_DataArray addObjectsFromArray:array];
        
        [_tableview reloadData];
    }];
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
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    /*headview.layer.shadowOpacity  =  0.5f ;
    headview.layer.cornerRadius = 4.0f;
    headview.layer.shadowOffset = CGSizeZero;
    headview.layer.shadowRadius = 4.0f;
    headview.layer.shadowPath   = [UIBezierPath bezierPathWithRect:headview.bounds].CGPath;*/
    headview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headview];
    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, self.view.bounds.size.width, 0.5)];
    sepLine.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
    [headview addSubview:sepLine];
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"全部地区",@"全部行业",@"全部类别",@"筛选", nil];
    _tcButton1 = [[ToubiaoChooseButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.25*0, 0, self.view.bounds.size.width*0.25, headview.bounds.size.height)];
        [_tcButton1 setBackgroundColor:[UIColor clearColor]];
        [_tcButton1 setTitle:[titleArray objectAtIndex:0] forState:UIControlStateNormal];
        _tcButton1.tag = 0;
        [_tcButton1 addTarget:self action:@selector(shaixuanAction:) forControlEvents:UIControlEventTouchUpInside];
        [headview addSubview:_tcButton1];
    
    _tcButton2 = [[ToubiaoChooseButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.25*1, 0, self.view.bounds.size.width*0.25, headview.bounds.size.height)];
     [_tcButton2 setBackgroundColor:[UIColor clearColor]];
    [_tcButton2 setTitle:[titleArray objectAtIndex:1] forState:UIControlStateNormal];
    _tcButton2.tag = 1;
    [_tcButton2 addTarget:self action:@selector(shaixuanAction:) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:_tcButton2];
    
    _tcButton3 = [[ToubiaoChooseButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.25*2, 0, self.view.bounds.size.width*0.25, headview.bounds.size.height)];
    [_tcButton3 setBackgroundColor:[UIColor clearColor]];
    [_tcButton3 setTitle:[titleArray objectAtIndex:2] forState:UIControlStateNormal];
    _tcButton3.tag = 2;
    [_tcButton3 addTarget:self action:@selector(shaixuanAction:) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:_tcButton3];
    
    _tcButton4 = [[ToubiaoChooseButton2 alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.25*3, 0, self.view.bounds.size.width*0.25, headview.bounds.size.height)];
    [_tcButton4 setBackgroundColor:[UIColor clearColor]];
    [_tcButton4 setTitle:[titleArray objectAtIndex:3] forState:UIControlStateNormal];
    _tcButton4.tag = 3;
    [_tcButton4 addTarget:self action:@selector(shaixuanAction:) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:_tcButton4];
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [_tableview.header endRefreshing];
        });
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
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
    _shaixuanView = [[ChooseView_shaixuanView alloc]initWithFrame:CGRectMake(0, 40,self.view.bounds.size.width, 330)];
    [self.view addSubview:_shaixuanView];
   
    _shaixuanView.hidden = YES;
    _thirdTableView.hidden = YES;
    _firstTableView.hidden = YES;
    _secondTableView.hidden = YES;

}
#pragma mark -- 初始刷新条件
- (void)beginTheNum{
    areaID = @"0";    //地区
    hangyeID = @"0";  //行业
    cateID = @"0";    //类别
}
- (void)loadMoreData{
    //1.添加假数据
    pageNum ++;
    NSMutableArray *arr = [NSMutableArray array];
    if (![areaID isEqualToString:@"0"]) {
        arr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"area=%@",areaID],@"psize=10",nil];
        [arr addObject:[NSString stringWithFormat:@"page=%li",(long)pageNum]];
    }else if (![hangyeID isEqualToString:@"0"]){
        arr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"trade=%@",hangyeID],@"psize=10",nil];
        [arr addObject:[NSString stringWithFormat:@"page=%li",(long)pageNum]];
    }else if (![cateID isEqualToString:@"0"]){
        arr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"cate=%@",cateID],@"psize=10",nil];
        [arr addObject:[NSString stringWithFormat:@"page=%li",(long)pageNum]];
    }else{
        arr = [NSMutableArray arrayWithObjects:@"psize=10",nil];
        [arr addObject:[NSString stringWithFormat:@"page=%li",(long)pageNum]];
    }
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
            [_DataArray addObjectsFromArray:array];
            [_tableview reloadData];
            
        }];
    }else{
        [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead] parameter:arr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
            //NSLog(@"code = %li",(long)code);
            //NSLog(@"error = %@",error);
            //NSLog(@"dictionary = %@",dictionary);
            NSLog(@"array = %@",array);
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
                
                NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"Article"];
                
            }];
        }
        number ++;
    }
    
    switch (btn.tag) {
        case 0:       //地区
        {
            NSLog(@"1");
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
                NSArray *array1 = [[_ArticleDic objectForKey:@"areas"]allKeys];
                NSArray *array2 = [[_ArticleDic objectForKey:@"areas"]allValues];
               
                [_firstTableView tableReloadData:array1 frame:CGRectMake(0, 34, 135, 330) block:^(NSInteger index){
                    NSDictionary * dic2 = [array2 objectAtIndex:index];
                    NSArray *array3 = [dic2 allValues];
                    NSArray *array4 = [dic2 allKeys];
                    [_secondTableView tableReloadData:array3 frame:CGRectMake(_firstTableView.bounds.size.width, 34,self.view.bounds.size.width - _firstTableView.bounds.size.width,10) block:^(NSInteger index){
                        NSLog(@"index = %li",(long)index);
                        areaID = [array4 objectAtIndex:index];
                        NSMutableArray *arr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"area=%@",areaID],@"psize=10",nil];
                        [arr addObject:[NSString stringWithFormat:@"page=%li",(long)pageNum]];
                        [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead] parameter:arr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
                            NSLog(@"code = %li",(long)code);
                            NSLog(@"error = %@",error);
                            NSLog(@"dictionary = %@",dictionary);
                            NSLog(@"array = %@",array);
                            pageNum = 1;
                            [_DataArray removeAllObjects];
                            [_DataArray addObjectsFromArray:array];
                            [_tableview reloadData];
                            [self hideTableView];
                        }];
                    }];
                    if (array3.count > 0) {
                        NSIndexPath *ip2=[NSIndexPath indexPathForRow:0 inSection:0];
                         [_secondTableView selectRowAtIndexPath:ip2 animated:YES scrollPosition:UITableViewScrollPositionBottom];
                    }
                 
                }];
                
                NSDictionary * dic2 = [array2 objectAtIndex:0];
                NSArray *array3 = [dic2 allValues];
                NSArray *array4 = [dic2 allKeys];
                areaID = [array4 objectAtIndex:0];
                //tableview默认选中某一行
                if (array1.count > 0) {
                    NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
                    [_firstTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
                }
              
                [_secondTableView tableReloadData:array3 frame:CGRectMake(_firstTableView.bounds.size.width, 34,self.view.bounds.size.width - _firstTableView.bounds.size.width,10) block:^(NSInteger index){
                    //NSString *urlStr = [NSString stringWithFormat:@"%@article/list?page=1&psize=10&cate=&type=&ttype=&trade=&area=&words=",ApiUrlHead];
                    NSMutableArray *arr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"area=%@",areaID], nil];
                    _request = nil;
                    _request = [[RequestXlJ alloc]init];
                    [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead] parameter:arr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,id array){
                        NSLog(@"code = %li",(long)code);
                        NSLog(@"error = %@",error);
                        NSLog(@"dictionary = %@",dictionary);
                        NSLog(@"array = %@",array);
                        
                        pageNum = 1;
                        [_DataArray removeAllObjects];
                        [_DataArray addObjectsFromArray:array];
                        [_tableview reloadData];
                       [self hideTableView];
                    }];
                }];
                if (array3.count > 0) {
                    NSIndexPath *ip2=[NSIndexPath indexPathForRow:0 inSection:0];
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
                
                NSArray *array1 = [[_ArticleDic objectForKey:@"trades"]allKeys];
                NSArray *array2 = [[_ArticleDic objectForKey:@"trades"]allValues];
                [_thirdTableView tableReloadData:array2 frame:CGRectMake(0, 34, 135, 330) block:^(NSInteger index){
                    NSLog(@"index = %li",(long)index);
                    hangyeID = [array1 objectAtIndex:index];
                    NSMutableArray *arr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"trade=%@",hangyeID],@"psize=10",nil];
                    [arr addObject:[NSString stringWithFormat:@"page=%li",(long)pageNum]];
                    _request = nil;
                    _request = [[RequestXlJ alloc]init];
                    [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead] parameter:arr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
                        NSLog(@"code = %li",(long)code);
                        NSLog(@"error = %@",error);
                        NSLog(@"dictionary = %@",dictionary);
                        NSLog(@"array = %@",array);
                        pageNum = 1;
                        [_DataArray removeAllObjects];
                        [_DataArray addObjectsFromArray:array];
                        [_tableview reloadData];
                        [self hideTableView];
                    }];
                    
                    
                    
                }];
               
                //tableview默认选中某一行
                if (array2.count > 0) {
                    NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
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
                NSArray *array2 = [[_ArticleDic objectForKey:@"types"]allValues];
                [_thirdTableView tableReloadData:array2 frame:CGRectMake(0, 34, 135, 330) block:^(NSInteger index){
                    NSLog(@"index = %li",(long)index);
                    cateID = [array1 objectAtIndex:index];
                    NSMutableArray *arr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"cate=%@",cateID],@"psize=10",nil];
                    [arr addObject:[NSString stringWithFormat:@"page=%li",(long)pageNum]];
                    _request = nil;
                    _request = [[RequestXlJ alloc]init];
                    [_request requestWithUrlHead:[NSMutableString stringWithFormat:@"%@article/list?",ApiUrlHead] parameter:arr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary *dictionary,NSArray *array){
                        NSLog(@"code = %li",(long)code);
                        NSLog(@"error = %@",error);
                        NSLog(@"dictionary = %@",dictionary);
                        NSLog(@"array = %@",array);
                        pageNum = 1;
                        [_DataArray removeAllObjects];
                        [_DataArray addObjectsFromArray:array];
                        [_tableview reloadData];
                        [self hideTableView];
                    }];
                    

                    
                }];
                //tableview默认选中某一行
                if (array2.count > 0) {
                    NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
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
                
                
                NSArray *array1 = [[_ArticleDic objectForKey:@"types"]allKeys];
                NSArray *array2 = [[_ArticleDic objectForKey:@"types"]allValues];
                NSArray *array3 = [[_ArticleDic objectForKey:@"ttypes"]allKeys];
                NSArray *array4 = [[_ArticleDic objectForKey:@"ttypes"]allValues];
                NSMutableArray *muarray = [NSMutableArray arrayWithArray:array2];
                NSMutableArray *muarray1 = [NSMutableArray arrayWithArray:array1];
                [muarray addObjectsFromArray:array4];
                [muarray1 addObjectsFromArray:array3];
                [_thirdTableView tableReloadData:muarray frame:CGRectMake(0, 34, 135, 330) block:^(NSInteger index){
                    
                    
                    
                    
                }];
                //tableview默认选中某一行
                if (muarray.count > 0) {
                    NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
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
        default:
            break;
    }
    
    [self appearGrayView];    //显示阴影
    
}
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
    LableXLJ *title = [[LableXLJ alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 45) text:[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"title"] textColor:[UIColor colorWithWhite:0 alpha:1] font:14 numberOfLines:2 lineSpace:3];
    CGFloat h1 = title.bounds.size.height;
    
    LableXLJ *detailTitle = [[LableXLJ alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 45) text:@"期法律；化工二库萨机构埃及俄独立的 v 叫啊人家过快仨当局 i 肉看看女哦哦啊让 v空间都 is 减肥 i 哦是多哈工人难过IE化工 i 然后古俄奥PDF红人哦 i 阿萨德譬如结果i 哦素古人配爱破啊俄方将陪我哈土坷垃无奈方法叫阿俄华人旅客啊防护屙咖了入户率妇女节lakh 吞弗兰克首都人" textColor:[UIColor colorWithWhite:0 alpha:1] font:14 numberOfLines:2 lineSpace:0];
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
                                                   hangye:@"网络通讯计算机" location:@"上海" time:[TimeXLJ returnUploadTime:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"created_at"]]] detail:@"期法律；化工二库萨机构埃及俄独立的 v 叫啊人家过快仨当局 i 肉看看女哦哦啊让 v空间都 is 减肥 i 哦是多哈工人难过IE化工 i 然后古俄奥PDF红人哦 i 阿萨德譬如结果i 哦素古人配爱破啊俄方将陪我哈土坷垃无奈方法叫阿俄华人旅客啊防护屙咖了入户率妇女节lakh 吞弗兰克首都人"];
        
        
        
   }else{
       [cell title:[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"title"]
            hangye:@"网络通讯计算机" location:@"上海" time:[TimeXLJ returnUploadTime:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"created_at"]]] detail:@"期法律；化工二库萨机构埃及俄独立的 v 叫啊人家过快仨当局 i 肉看看女哦哦啊让 v空间都 is 减肥 i 哦是多哈工人难过IE化工 i 然后古俄奥PDF红人哦 i 阿萨德譬如结果i 哦素古人配爱破啊俄方将陪我哈土坷垃无奈方法叫阿俄华人旅客啊防护屙咖了入户率妇女节lakh 吞弗兰克首都人"];
    }
    
    [cell.tanChuangView removeFromSuperview];
    NSString *zannum1 = @"46";
    [cell.zanbtn setTitle:zannum1 forState:UIControlStateNormal];
    [cell.liulanbtn setTitle:@"29" forState:UIControlStateNormal];
    [cell.pinglunbtn setTitle:[NSString stringWithFormat:@"%li",(long)indexPath.row] forState:UIControlStateNormal];
    
    
    __block int number1 = 0;
    cell.number = number1;
    [cell blockButtonAction:^(NSInteger index){
        NSLog(@"index = %li,indexPath.row = %li",(long)index,(long)indexPath.row);
        if (index == 0) {
            NSString *zannumStr = zannum1;
            int zannum = [zannumStr intValue];
            zannum ++;
            NSLog(@"zannum = %i",zannum);
            [cell.zanbtn setTitle:[NSString stringWithFormat:@"%i",zannum] forState:UIControlStateNormal];
            
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
            
            if (cell.number == 0) {
                cell.tanChuangView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 155, cell.zanbtn.frame.origin.y - 20, 140, 25)];
                cell.tanChuangView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
                cell.tanChuangView.tag = indexPath.row;
                [cell.contentView addSubview:cell.tanChuangView];
                
                XiangmuPinglinButton *fenxiangButton = [[XiangmuPinglinButton alloc]initWithFrame:CGRectMake(10, cell.tanChuangView.bounds.size.height * 0.2, cell.tanChuangView.bounds.size.width * 0.5, cell.tanChuangView.bounds.size.height * 0.6)];
                [fenxiangButton setTitle:@"分享" forState:UIControlStateNormal];
                [fenxiangButton setBackgroundColor:[UIColor clearColor]];
                [fenxiangButton setImage:[UIImage imageNamed:@"fenfen1@2x"] forState:UIControlStateNormal];
                fenxiangButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
                [fenxiangButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                fenxiangButton.tag = 0;
                [fenxiangButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.tanChuangView addSubview:fenxiangButton];
                
                XiangmuPinglinButton *shoucanButton = [[XiangmuPinglinButton alloc]initWithFrame:CGRectMake(cell.tanChuangView.bounds.size.width * 0.5 + 10, cell.tanChuangView.bounds.size.height * 0.2, cell.tanChuangView.bounds.size.width * 0.5, cell.tanChuangView.bounds.size.height * 0.6)];
                [shoucanButton setTitle:@"收藏" forState:UIControlStateNormal];
                [shoucanButton setBackgroundColor:[UIColor clearColor]];
                 [shoucanButton setImage:[UIImage imageNamed:@"fengfen1@2x"] forState:UIControlStateNormal];
                 shoucanButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
                [shoucanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                shoucanButton.tag = 1;
                [shoucanButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.tanChuangView addSubview:shoucanButton];
                
                cell.tanChuangView.layer.masksToBounds = YES;
                cell.tanChuangView.layer.cornerRadius = 4;
                
                cell.number = 1;
            }else if (cell.number == 1){
                [cell.tanChuangView removeFromSuperview];
                cell.number = 0;
            }
         }
    }];
    
    return cell;
}

- (void)moreAction:(XiangmuPinglinButton *)btn{
    switch (btn.tag) {
        case 0:
        {
            NSLog(@"分享");
            //通知分享
            [[NSNotificationCenter defaultCenter]postNotificationName:@"toShareViewController" object:nil userInfo:nil];
             
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ToubiaoDetailViewController *Tvc = [[ToubiaoDetailViewController alloc]init];
    Tvc.token = _token;
    Tvc.uid = _uid;
    Tvc.toubiaoID = [NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    Tvc.time = [TimeXLJ returnUploadTime:[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"created_at"]]];
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

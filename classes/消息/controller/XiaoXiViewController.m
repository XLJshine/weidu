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
static XiaoXiViewController *instance;
@interface XiaoXiViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>
{
    UITableView * _myTableView;//自定义tableView
    NSMutableArray * _imaArr;//存储图片的数组
    NSMutableArray*_lableArr;//存储名字
    UISearchDisplayController * _displayCtr;
}
@property (strong, nonatomic)FootTabelView * foot;
@end

@implementation XiaoXiViewController
+ (id)shareInstance
{
    if (instance == nil)
    {
        instance = [[[self class]alloc]init];
    }
    return instance;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //数组初始化
        _imaArr = [[NSMutableArray alloc]init];
        _lableArr=[[NSMutableArray alloc]init];
        
        //self.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:2];
        self.navigationItem.title = @"消息";
        UIImage *backImg = [UIImage imageNamed:@"caidan@2x"];
        MyItemButton *backBtn = [[MyItemButton alloc] initWithFrame:CGRectMake(0.f, 0.f, backImg.size.width/0.6, backImg.size.height/0.6)];
        [backBtn addTarget:self action:@selector(push1) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:backImg forState:UIControlStateNormal];
        UIView *backBtnView = [[UIView alloc] initWithFrame:backBtn.bounds];
        backBtnView.bounds = CGRectOffset(backBtnView.bounds, 10, 0);
        [backBtnView addSubview:backBtn];
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
        self.navigationItem.leftBarButtonItem = backBarBtn;
        
        
        UIImage *backImg1 = [UIImage imageNamed:@"dingbu2@2x"];
        MyItemButton *backBtn1 = [[MyItemButton alloc] initWithFrame:CGRectMake(0.f, 0.f, backImg1.size.width/0.6, backImg1.size.height/0.6)];
        [backBtn1 addTarget:self action:@selector(push2) forControlEvents:UIControlEventTouchUpInside];
        [backBtn1 setImage:backImg1 forState:UIControlStateNormal];
        UIView *backBtnView1 = [[UIView alloc] initWithFrame:backBtn1.bounds];
        backBtnView1.bounds = CGRectOffset(backBtnView.bounds, -20, 0);
        [backBtnView1 addSubview:backBtn1];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:backBtnView1];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    return self;
}
-(void)push1{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController = [delegate siderViewController];
    [sideViewController showLeftViewController:YES];
    
    
    //显示主界面半透明视图
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewAppear" object:nil userInfo:nil];
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
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-49) style:UITableViewStylePlain];
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




- (void)creadData{
    _imaArr = [@[@"dingyu@2x.png",@"huodong@2x.png",@"speech-bubble-2@2x.png",@"touxiang@2x.png"] mutableCopy];
    _lableArr=[@[@"订阅消息",@"活动",@"我的评论",@"聊天"]mutableCopy];
    
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
    return _imaArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XiaoXiCustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    cell.headImg.image = [UIImage imageNamed:_imaArr[indexPath.row]];
    cell.headMessageName.text = [_lableArr objectAtIndex:indexPath.row];
    cell.time.text = @"昨天";
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        DingYueXiaoXiViewController*dingyue=[[DingYueXiaoXiViewController alloc]init];
        [self.navigationController pushViewController:dingyue animated:YES];
    }else if (indexPath.row == 1){
        HuoDongViewController*huoDong=[[HuoDongViewController alloc]init];
        [self.navigationController pushViewController:huoDong animated:YES];
    }else if (indexPath.row == 2){
        NewPingLunViewController*pinglun=[[NewPingLunViewController alloc]init];
        [self.navigationController pushViewController:pinglun animated:YES];
       
//        LunTanTableViewController *luntan=[[LunTanTableViewController alloc]init];
//        [self.navigationController pushViewController:luntan animated:YES];
    }else if (indexPath.row == 3){
     
        ChatViewController *dingye=[[ChatViewController alloc]init];
        [self.navigationController pushViewController:dingye animated:YES];
    }else if (indexPath.row == 4){
        daiChuLiViewController*daichuli=[[daiChuLiViewController alloc]init];
        [self.navigationController pushViewController:daichuli animated:YES];
        
    }else{
        
    }
}
/*- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideDock" object:nil userInfo:nil];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Dock" object:nil userInfo:nil];
}*/
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

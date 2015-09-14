//
//  xiangMuPinLunViewController.m
//  时时投
//
//  Created by h on 15/8/13.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "xiangMuPinLunViewController.h"
#import "XiangMuPingLunTableViewCell.h"
#import "XiangmuPinglunViewController.h"
#import "FootTabelView.h"
#import "MJRefresh.h"
#import "MJChiBaoZiFooter.h"
#import "RequestXlJ.h"

@interface xiangMuPinLunViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
//@property (strong, nonatomic)__block NSMutableArray *DataArray;
@property (strong, nonatomic)__block RequestXlJ *request;
@property (strong, nonatomic)FootTabelView * foot;
@end
//static xiangMuPinLunViewController *instance;
@implementation xiangMuPinLunViewController{

    AFHTTPRequestOperationManager *manager;
    NSMutableArray * _DataArray;
     __block  NSInteger pageNum;   //分页控制
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"项目评论";
        _DataArray=[[NSMutableArray alloc]init];
        
     }
    return self;
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"xiangmuPinglunViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"xiangmuPinglunViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    pageNum = 1;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"XiangMuPingLunTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
    _foot = [[NSBundle mainBundle] loadNibNamed:@"FootTabelView" owner:self options:0][0];
    _myTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    _myTableView.tableFooterView.userInteractionEnabled = YES;
    _myTableView.tableFooterView = _foot;
    //去掉tableivew的多余线
    _myTableView.tableFooterView=[[UIView alloc]init];
   
    NSString *urlStr = [NSString stringWithFormat:@"%@profile/comments?page=1&psize=10&access-token=%@",ApiUrlHead,_token];
    NSLog(@"_token = %@",_token);
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            [_DataArray addObjectsFromArray:arr];
            
            [_myTableView reloadData];
        }else if (![code isEqualToString:@"0"]){
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];
    
    
    // 下拉刷新
    _myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [_myTableView.header endRefreshing];
        });
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _myTableView.header.autoChangeAlpha = YES;
    
    MJChiBaoZiFooter *footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 当上拉刷新控件出现50%时（出现一半），就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新）
    //    footer.appearencePercentTriggerAutoRefresh = 0.5;
    // 隐藏刷新状态的文字
    footer.refreshingTitleHidden = YES;
    //设置footer
    _myTableView.footer = footer;
    
    
    
}
- (void)loadMoreData{
    // 1.添加假数据
    pageNum ++;
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@profile/comments?page=%li&psize=10&access-token=%@",ApiUrlHead,(long)pageNum,_token];
    NSLog(@"_token = %@",_token);
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            if (arr.count == 0) {
                pageNum --;
            }
            
//            if (pageNum<=6) {
//            // 隐藏刷新状态的文字
//            MJChiBaoZiFooter*footer=[[MJChiBaoZiFooter alloc]init];
//            footer.refreshingTitleHidden = YES;
//
//            }
            [_DataArray addObjectsFromArray:arr];
            
            [_myTableView reloadData];
        }else if (![code isEqualToString:@"0"]){
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];
    
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //刷新表格
        //[_tableview reloadData];
        //拿到当前的上拉刷新控件，结束刷新状态
        [_myTableView.footer endRefreshing];
    });
    
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
//******tableview分割线********************
#pragma mark-UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _DataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 73;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XiangMuPingLunTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString*titleStr=[NSString stringWithFormat:@"%@",_DataArray[indexPath.row][@"title"]];
    cell.nameLable.text=titleStr;
    
    NSString*tradeStr=[NSString stringWithFormat:@"%@",_DataArray[indexPath.row][@"trade"]];
    cell.hangYeLable.text=tradeStr;
    
    NSString*areaStr=[NSString stringWithFormat:@"%@",_DataArray[indexPath.row][@"area"]];
    cell.diQuLable.text=areaStr;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XiangmuPinglunViewController*pinglu=[[XiangmuPinglunViewController alloc]init];
    [self.navigationController pushViewController:pinglu animated:YES];
    
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

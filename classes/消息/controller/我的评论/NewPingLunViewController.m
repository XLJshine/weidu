//
//  NewPingLunViewController.m
//  时时投
//
//  Created by h on 15/8/22.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "NewPingLunViewController.h"
#import "NewPinglunTableViewCell.h"
#import "FootTabelView.h"
#import "MJRefresh.h"
#import "MJChiBaoZiFooter.h"
#import "UIImageView+MJWebCache.h"
#import "ToubiaoDetailViewController.h"
#import "GerenInfoViewController.h"
@interface NewPingLunViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
//footView
@property (strong, nonatomic)FootTabelView * foot;
@end

@implementation NewPingLunViewController{
   AFHTTPRequestOperationManager *manager;
    NSInteger pageNum;
    MJChiBaoZiFooter *footer;
    NSMutableArray *_DataArray;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"项目评论";
        
    }
    return self;
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    pageNum = 1;
    NSString *urlStr = [NSString stringWithFormat:@"%@profile/comments?access-token=%@&page=1&psize=10",ApiUrlHead,_token];
    NSLog(@"urlStr = %@",urlStr);
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        //如果没有项目评论，就出现这个图片。
        UIImageView*showImage = [[UIImageView alloc]init];
        if (self.view.bounds.size.height>500) {
            
            showImage.image = [UIImage imageNamed:@"暂无评论@2x"];
            
            showImage.frame=self.view.frame;
            [self.view addSubview:showImage];
        }else{
            
            
            showImage.image = [UIImage imageNamed:@"暂无评论22"];
            
            showImage.frame=self.view.frame;
            [self.view addSubview:showImage];
            
            
            
        }
        
        if ([code isEqualToString:@"0"]) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            [_DataArray removeAllObjects];
            [_DataArray addObjectsFromArray:arr];
            if (_DataArray.count > 0) {
                [showImage removeFromSuperview];
            }
            NSLog(@"_DataArray===========%lu",(unsigned long)_DataArray.count);
            
            [_mytableView reloadData];
        }else if (![code isEqualToString:@"0"]){
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        //网络不佳视图
        InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height * 0.75, self.view.bounds.size.width - 180, 25)];
        [self.view addSubview:errorView];
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _mytableView.delegate=self;
    _mytableView.dataSource=self;
    _DataArray = [NSMutableArray array];
    pageNum = 1;
    
    [self.mytableView registerNib:[UINib nibWithNibName:@"NewPinglunTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
     _mytableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    //在tableView下面接一个footView用来去掉tableView多余的线
    _foot = [[NSBundle mainBundle] loadNibNamed:@"FootTabelView" owner:self options:0][0];
    _mytableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    _mytableView.tableFooterView.userInteractionEnabled = YES;
    _mytableView.tableFooterView = _foot;
   
    //去掉tableivew的多余线
    _mytableView.tableFooterView=[[UIView alloc]init];
    
   
    
    _mytableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        pageNum = 1;
        NSString *urlStr = [NSString stringWithFormat:@"%@profile/comments?access-token=%@&page=1&psize=10",ApiUrlHead,_token];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSArray *arr = [responseObject objectForKey:@"data"];
                [_DataArray removeAllObjects];
                [_DataArray addObjectsFromArray:arr];
                [_mytableView reloadData];
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                NSLog(@"error=%@",error);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                [alert show];
                [_mytableView reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [_mytableView reloadData];
            //网络不佳视图
            InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height * 0.75, self.view.bounds.size.width - 180, 25)];
            [self.view addSubview:errorView];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [_mytableView.header endRefreshing];
        });
    }];
    
    //设置自动切换透明度(在导航栏下面自动隐藏)
    _mytableView.header.autoChangeAlpha = YES;
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
    _mytableView.footer = footer;
    
}
- (void)loadMoreData{
    //1.添加数据
    pageNum ++;
     NSString *urlStr = [NSString stringWithFormat:@"%@profile/comments?access-token=%@&page=%li&psize=10",ApiUrlHead,_token,(long)pageNum];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *data = [responseObject objectForKey:@"data"];
            [_DataArray addObjectsFromArray:data];
            [_mytableView reloadData];
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
        [_mytableView.footer endRefreshing];
    });
}


#pragma mark ----- tableview分割线从顶点开始
//******tableview分割线从顶点开始********************
-(void)viewDidLayoutSubviews
{
    if ([_mytableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_mytableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_mytableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_mytableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
    NSLog(@"====%lu", (unsigned long)_DataArray.count);
    return _DataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewPinglunTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *userImageStr = [[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"headpic"];
    NSString *userName = [[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"realname"];
    userName = [userName stringByRemovingPercentEncoding];
    cell.name.text = userName;
    NSString *count = [NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"count"]];
    NSString *comment = [NSString string];
    if ([count isEqualToString:@"1"]) {
         comment =  [[_DataArray objectAtIndex:indexPath.row] objectForKey:@"comment"];
    }else{
         comment =  [NSString stringWithFormat:@"等人发表了%@条评论",count];
    }
    comment = [comment stringByRemovingPercentEncoding];
    cell.jiTiaoPinglun.text = comment;
    
    cell.time.text = [[_DataArray objectAtIndex:indexPath.row] objectForKey:@"date"];
    cell.job.text = [[_DataArray objectAtIndex:indexPath.row] objectForKey:@"art_tit"];
    [cell.image setImageURLStr:userImageStr placeholder:placeImage];
    cell.image.userInteractionEnabled = YES;
    cell.image.tag = indexPath.row;
    [cell.image addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageSelect:)]];
    
    return cell;
}

- (void)imageSelect:(UITapGestureRecognizer *)tap{
    NSLog(@"tap.view.tag--%li",(long)tap.view.tag);
    GerenInfoViewController *GVC = [[GerenInfoViewController alloc]init];
    GVC.token = _token;
    GVC.uid = [NSString stringWithFormat:@"%@",[[[_DataArray objectAtIndex:tap.view.tag] objectForKey:@"user"] objectForKey:@"user_id"]];
    
    [self.navigationController pushViewController:GVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ToubiaoDetailViewController *Tvc = [[ToubiaoDetailViewController alloc]init];
    Tvc.token = _token;
    Tvc.uid = _uid;
    Tvc.toubiaoID = [NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"art_id"]];
    Tvc.time = nil;
    Tvc.ifShowPinglun = @"yes";
    [self.navigationController pushViewController:Tvc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
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

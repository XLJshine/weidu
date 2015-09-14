//
//  DingYueXiaoXiViewController.m
//  时时投
//
//  Created by h on 15/8/6.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "DingYueXiaoXiViewController.h"
#import "xiaoxiTableViewCell.h"
#import "FootTabelView.h"
#import "MyItemButton.h"
#import "DingyueViewController.h"
#import "DingyueMessageViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DingYueXiaoXiViewController ()<UITableViewDataSource,UITableViewDelegate,ErrorViewXLJDelegate>
{
    NSMutableArray * _imaArr;//存储图片的数组
    NSMutableArray*_lableArr;//存储名字
      AFHTTPRequestOperationManager *manager;
     NSMutableArray *messageArray;
}
@property (weak, nonatomic) IBOutlet UITableView *xiaoxiTableView;
@property (strong, nonatomic)FootTabelView * foot;
@property (strong, nonatomic)__block ErrorViewXLJ * errorView;
@end

@implementation DingYueXiaoXiViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"订阅消息";
        
        UIImage *backImg1 = [UIImage imageNamed:@"tianjia@2x"];
        UIButton *backBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 25,25)];
        [backBtn1 setImage:backImg1 forState:UIControlStateNormal];
        [backBtn1 addTarget:self action:@selector(dingyueAction) forControlEvents:UIControlEventTouchUpInside];
        //        [backBtn1 setImage:backImg1 forState:UIControlStateNormal];
        //        UIView *backBtnView1 = [[UIView alloc] initWithFrame:backBtn1.bounds];
        //        backBtnView1.bounds = CGRectOffset(backBtnView.bounds, -20, 0);
        //        [backBtnView1 addSubview:backBtn1];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn1];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    return self;
}
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dingyueAction{   //订阅设置
    DingyueViewController *dingYue = [[DingyueViewController alloc]init];
    dingYue.token = _token;
    dingYue.uid = _uid;
    [self.navigationController pushViewController:dingYue animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creadData];
    _xiaoxiTableView.delegate = self;
    _xiaoxiTableView.dataSource = self;
    [_xiaoxiTableView registerNib:[UINib nibWithNibName:@"xiaoxiTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
   _foot = [[NSBundle mainBundle] loadNibNamed:@"FootTabelView" owner:self options:0][0];
   _xiaoxiTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
   _xiaoxiTableView.tableFooterView.userInteractionEnabled = YES;
   _xiaoxiTableView.tableFooterView = _foot;
    //去掉tableivew的多余线
   _xiaoxiTableView.tableFooterView=[[UIView alloc]init];
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DingYueXiaoXiViewController"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DingYueXiaoXiViewController"];
    manager = [AFHTTPRequestOperationManager manager];
    messageArray = [NSMutableArray array];
    NSString *message = [NSString stringWithFormat:@"%@subscribe/tlist?access-token=%@",ApiUrlHead,_token];
    NSLog(@"message = %@",message);
    [manager GET:message parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        //如果没有订阅的消息，就出现这个图片。
        UIImageView*showImage = [[UIImageView alloc]init];
        if (self.view.bounds.size.height>500) {
            
            showImage.image = [UIImage imageNamed:@"我的订阅5S@2x"];
            
            showImage.frame=self.view.frame;
            [self.view addSubview:showImage];
        }else{
            
            showImage.image = [UIImage imageNamed:@"我的订阅"];
            showImage.frame=self.view.frame;
            [self.view addSubview:showImage];
            
            
            
        }

        if ([code isEqualToString:@"0"]) {
            NSArray *data = [responseObject objectForKey:@"data"];
            if (data.count > 0) {
                 [showImage removeFromSuperview];
            }
            [messageArray addObjectsFromArray:data];
            [_xiaoxiTableView reloadData];
        }else if (![code isEqualToString:@"0"]){
            NSString *error = [responseObject objectForKey:@"err"];
            NSLog(@"error=%@",error);
        
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        _errorView = [[ErrorViewXLJ alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 49)];
        _errorView.delegate = self;
        [self.view addSubview:_errorView];
    }];
}
#pragma mark -- 错误页面代理
- (void)errorView:(ErrorViewXLJ *)errorView  buttonAtIndex:(NSInteger)index{
    NSLog(@"index = %li",(long)index);
    if (index == 0) {
        NSString *message = [NSString stringWithFormat:@"%@subscribe/tlist?access-token=%@",ApiUrlHead,_token];
        NSLog(@"message = %@",message);
        [manager GET:message parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSArray *data = [responseObject objectForKey:@"data"];
                [messageArray addObjectsFromArray:data];
                [_xiaoxiTableView reloadData];
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                NSLog(@"error=%@",error);
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    
    }
}

- (void)creadData{
    _imaArr = [@[@"交通@2x.png",@"商业@2x.png",@"园林@2x.png",@"地产@2x.png",@"网络@2x.png"] mutableCopy];
    _lableArr=[@[@"交通运输",@"市场政房地产",@"园林绿化",@"商业服务",@"网络通信计算机"]mutableCopy];
    
}

//******tableview分割线从顶点开始********************
-(void)viewDidLayoutSubviews
{
    if ([self.xiaoxiTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.xiaoxiTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.xiaoxiTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.xiaoxiTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
//去掉tableivew的多余线
//_commentTableView.tableFooterView=[[UIView alloc]init];
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return messageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    xiaoxiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *picStr = [[messageArray objectAtIndex:indexPath.row] objectForKey:@"pic"];
    [cell.Image setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:nil];
    cell.name.text = [NSString stringWithFormat:@"%@",[[messageArray objectAtIndex:indexPath.row] objectForKey:@"trade"]];
    cell.jieshao.text = [NSString stringWithFormat:@"%@",[[messageArray objectAtIndex:indexPath.row] objectForKey:@"area"]];
    //cell.time.text = [NSString stringWithFormat:@"%@",[[messageArray objectAtIndex:indexPath.row] objectForKey:@"date"]];
    cell.time.text = @"";
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DingyueMessageViewController *DVC = [[DingyueMessageViewController alloc]init];
    DVC.token = _token;
    DVC.uid = _uid;
    DVC.mytitle = [[messageArray objectAtIndex:indexPath.row] objectForKey:@"trade"];
    NSString *ID = [NSString stringWithFormat:@"%@",[[messageArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    DVC.dinyueID = ID;
    [self.navigationController pushViewController:DVC animated:YES];
    
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

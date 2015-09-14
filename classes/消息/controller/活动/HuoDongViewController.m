//
//  HuoDongViewController.m
//  时时投
//
//  Created by h on 15/7/27.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "HuoDongViewController.h"
#import "HuoDongTableViewCell.h"
#import "FootTabelView.h"
#import "UIImageView+MJWebCache.h"

#import "HDXQViewController.h"
@interface HuoDongViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *huoDongTableView;
@property (strong, nonatomic)__block NSMutableArray *DataArray;
@property (strong, nonatomic)FootTabelView * foot;
@end

@implementation HuoDongViewController{
     AFHTTPRequestOperationManager *manager;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"活动";
        
        /*UIButton *lestButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lestButton setImage:[UIImage imageNamed:@"fanhuix@2x"] forState:UIControlStateNormal];
        [lestButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:lestButton];
        self.navigationItem.leftBarButtonItem = leftItem;*/
        
    }
    return self;
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _huoDongTableView.delegate=self;
    _huoDongTableView.dataSource=self;
    
    [self.huoDongTableView registerNib:[UINib nibWithNibName:@"HuoDongTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //加foot去除tableView多余的线
    _foot = [[NSBundle mainBundle] loadNibNamed:@"FootTabelView" owner:self options:0][0];
    _huoDongTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    _huoDongTableView.tableFooterView.userInteractionEnabled = YES;
    _huoDongTableView.tableFooterView = _foot;
    //去掉tableivew的多余线
    _huoDongTableView.tableFooterView=[[UIView alloc]init];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@activity/list?access-token=%@",ApiUrlHead,_token];
    NSLog(@"=============_token = %@",_token);
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSDictionary *dic1 = [responseObject objectForKey:@"data"];
            _DataArray = dic1;
            NSLog(@"_DataArray===========%@",_DataArray);
            
            [_huoDongTableView reloadData];
        }else if (![code isEqualToString:@"0"]){
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        //网络不佳视图
        InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height * 0.75, self.view.bounds.size.width - 180, 25)];
        [self.view addSubview:errorView];
        
    }];
}

#pragma mark ----- tableview分割线从顶点开始
//******tableview分割线从顶点开始********************
-(void)viewDidLayoutSubviews
{
    if ([_huoDongTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_huoDongTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_huoDongTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_huoDongTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
    return 170;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HuoDongTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *img=[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"pic"]];
        NSLog(@"img==========%@",img);
        
        [cell.image setImageWithURL:[NSURL URLWithString:img]];
        
        
        cell.name.text=[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"title"];
        cell.beginTime.text=[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"starttime" ];
        cell.endTime.text=[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"endtime" ];
    }else{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *img=[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"pic"]];
    NSLog(@"img==========%@",img);
    
    [cell.image setImageWithURL:[NSURL URLWithString:img]];
    
   
    cell.name.text=[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"title"];
    cell.beginTime.text=[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"starttime" ];
    cell.endTime.text=[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"endtime" ];
    
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HDXQViewController*HDXQ=[[HDXQViewController alloc]init];
    HDXQ.token=_token;
    HDXQ.uid=_uid;
    HDXQ.HuoDongID=[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
//    HuoDongXiangQinViewController *XVC = [[HuoDongXiangQinViewController alloc]init];
//    XVC.token = _token;
//    XVC.uid = _uid;
//    XVC.HuoDongID = [NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    [self.navigationController pushViewController:HDXQ animated:YES];

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

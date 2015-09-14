//
//  FangkeViewController.m
//  时时投
//
//  Created by h on 15/7/24.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "FangkeViewController.h"
#import "FangkeTableViewCell.h"
#import "GerenInfoViewController.h"
#import "FootTabelView.h"
#import "TimeXLJ.h"
#import "UIImageView+MJWebCache.h"
static FangkeViewController *instance;
@interface FangkeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *FangKeTableView;
@property (strong, nonatomic)__block NSMutableArray *DataArray;
@property (strong, nonatomic)FootTabelView * foot;
@end

@implementation FangkeViewController{

   AFHTTPRequestOperationManager *manager;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"我的访客";
        
       
        
    }
    return self;
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
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"FangkeViewController"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"FangkeViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _FangKeTableView.dataSource = self;
    _FangKeTableView.delegate = self;
    _FangKeTableView.backgroundColor = [UIColor clearColor];
    _FangKeTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    headview.backgroundColor = [UIColor clearColor];
    _FangKeTableView.tableHeaderView = headview;
    [self.FangKeTableView registerNib:[UINib nibWithNibName:@"FangkeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //加foot去除tableView多余的线
    _foot = [[NSBundle mainBundle] loadNibNamed:@"FootTabelView" owner:self options:0][0];
    _FangKeTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    _FangKeTableView.tableFooterView.userInteractionEnabled = YES;
    _FangKeTableView.tableFooterView = _foot;
    //去掉tableivew的多余线
    _FangKeTableView.tableFooterView=[[UIView alloc]init];
    

    
    _DataArray = [NSMutableArray array];
    NSString *urlStr = [NSString stringWithFormat:@"%@profile/visitor?access-token=%@",ApiUrlHead,_token];
    NSLog(@"=============_token = %@",_token);
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        self.edgesForExtendedLayout = UIRectEdgeNone;
       //如果没有访客，就出现这个图片。
        UIImageView*showImage = [[UIImageView alloc]init];
        if (self.view.bounds.size.height>500) {
            showImage.image = [UIImage imageNamed:@"暂无访客@2x"];
            showImage.frame=self.view.frame;
            [self.view addSubview:showImage];
            
        }else{
            showImage.image = [UIImage imageNamed:@"暂无访客22"];
            showImage.frame=self.view.frame;
            [self.view addSubview:showImage];
        }
        if ([code isEqualToString:@"0"]) {
            NSArray *dic1 = [responseObject objectForKey:@"data"];
            if (dic1.count > 0) {
                [showImage removeFromSuperview];
            }
            [_DataArray addObjectsFromArray:dic1];
            NSLog(@"_DataArray===========%@",_DataArray);
            
            [_FangKeTableView reloadData];
        }else if (![code isEqualToString:@"0"]){
           
                    }
   }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];
}
#pragma mark-UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _DataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     FangkeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell.TimeLable.text=[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"vtime"];
        NSString *img=[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"headpic"]];
        NSLog(@"img==========%@",img);
        //cell.touXiangImage.image=[UIImage imageNamed:img];
        [cell.touXiangImage setImageWithURL:[NSURL URLWithString:img]];
        
        cell.nameLable.text=[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"realname" ];
        cell.zhiWeiLable.text=[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"job"];
        cell.gongSiLable.text=[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"company_name"];
        cell.gongTongFriendLable.text=[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"area"];
        cell.renMaiImage.image=[UIImage imageNamed:@"renmai2@2x"];
    }else{
        
    cell.TimeLable.text= [[_DataArray objectAtIndex:indexPath.row] objectForKey:@"vtime"];
        NSString *img=[NSString stringWithFormat:@"%@",[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"headpic"]];
        NSLog(@"img==========%@",img);
    
        [cell.touXiangImage setImageWithURL:[NSURL URLWithString:img]];
    
    cell.nameLable.text=[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"realname" ];
    cell.zhiWeiLable.text=[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"job"];
    cell.gongSiLable.text=[[_DataArray objectAtIndex:indexPath.row]objectForKey:@"company_name"];
    cell.gongTongFriendLable.text=[[_DataArray objectAtIndex:indexPath.row] objectForKey:@"area"];
    cell.renMaiImage.image=[UIImage imageNamed:@"renmai2@2x"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GerenInfoViewController *GVC = [[GerenInfoViewController alloc]init];
    GVC.token = _token;
    GVC.uid = _uid;
    [self.navigationController pushViewController:GVC animated:YES];
    
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

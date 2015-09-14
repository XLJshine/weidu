//
//  ZhanghaoSafeViewController.m
//  时时投
//
//  Created by 熊良军 on 15/7/23.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "ZhanghaoSafeViewController.h"
#import "ZhanghaoSafeTableViewCell.h"
#import "QQViewController.h"
#import "PhoneViewController.h"
#import "MiMaViewController.h"
#import "YouXiangViewController.h"
#import "QQbangdingViewController.h"
#import "YouxiangBangdingViewController.h"
#import "PhoneBangdingViewController.h"
#import "MimaChangeViewController.h"

#import "ZhanghaoBandingViewController.h"
@interface ZhanghaoSafeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic ,strong)NSArray *titleArray;
@property (nonatomic ,strong)NSMutableArray *detailArray;
@property (nonatomic ,strong)NSArray *backgroundImageArray;

@end

@implementation ZhanghaoSafeViewController{
    AFHTTPRequestOperationManager *manager;
    NSDictionary * Data;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"账号安全";
        
//        UIButton *lestButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
//        [lestButton setImage:[UIImage imageNamed:@"fanhuix@2x"] forState:UIControlStateNormal];
//        [lestButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:lestButton];
//        self.navigationItem.leftBarButtonItem = leftItem;
        
    }
    return self;
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ZhanghaoSafeViewController"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ZhanghaoSafeViewController"];
    NSString *urlStr = [NSString stringWithFormat:@"%@account/info?access-token=%@",ApiUrlHead,_token];
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            Data = [responseObject objectForKey:@"data"];
            [_detailArray removeAllObjects];
            
           
            NSString *username = [NSString stringWithFormat:@"%@",[Data objectForKey:@"username"]];
            NSString *mobile = [NSString stringWithFormat:@"%@",[Data objectForKey:@"mobile"]];
            NSString *email = [NSString stringWithFormat:@"%@",[ Data objectForKey:@"email"]];
            [_detailArray addObject:username];
            [_detailArray addObject:mobile];
            [_detailArray addObject:email];
            [_detailArray addObject:@""];
            
            [_tableview reloadData];
        }else if (![code isEqualToString:@"0"]){
            NSString *error = [responseObject objectForKey:@"err"];
            NSLog(@"error = %@",error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backgrondview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beijing@2x"]];
    [self.view addSubview:backgrondview];
    
    [self data];//初始化数据
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.scrollEnabled = NO;
    [self.view addSubview:_tableview];
    
    NSLog(@"_token = %@",_token);
   
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    headview.backgroundColor = [UIColor clearColor];
    _tableview.tableHeaderView = headview;
    
    // Do any additional setup after loading the view.
}
- (void)data{
     _titleArray = [NSArray arrayWithObjects:@"账号",
                   @"手机号",
                   @"邮箱",
                   @"修改密码",
                   nil];
    _detailArray = [NSMutableArray arrayWithObjects:@"",
                    @"",
                    @"",
                    @"",
                    nil];
    _backgroundImageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"chaangtiao1@2x"],[UIImage imageNamed:@"chaangtiao2@2x"],[UIImage imageNamed:@"chaangtiao2@2x"],[UIImage imageNamed:@"chaangtiao2@2x"], nil];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier1 = @"statusCell3";
    ZhanghaoSafeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (cell == nil) {
        cell = [[ZhanghaoSafeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1 title:[_titleArray objectAtIndex:indexPath.row] detail:[_detailArray objectAtIndex:indexPath.row] backgroundimage:[_backgroundImageArray objectAtIndex:indexPath.row]];
        
    }else{
        [cell title:[_titleArray objectAtIndex:indexPath.row] detail:[_detailArray objectAtIndex:indexPath.row] backgroundimage:[_backgroundImageArray objectAtIndex:indexPath.row]];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 1||indexPath.row == 2||indexPath.row == 3||indexPath.row == 4) {
        UIImageView *arrawImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 42, 19, 12, 12)];
        [arrawImage setImage:[UIImage imageNamed:@"fangRight@2x"]];
        [cell.contentView addSubview:arrawImage];
        
        cell.detailtitle.frame = CGRectMake(cell.bounds.size.width * 0.4, 15, cell.bounds.size.width * 0.6 - 45, 20);
      
    }else{
        
        
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3) {
        MimaChangeViewController *bangding=[[MimaChangeViewController alloc]init];
        bangding.token = _token;
        bangding.uid = _uid;
        [self.navigationController pushViewController:bangding animated:YES];
//        QQViewController*qq=[[QQViewController alloc]init];
//        [self.navigationController pushViewController:qq animated:YES];
    }else if (indexPath.row==1){
        NSString *mobile = [NSString stringWithFormat:@"%@",[Data objectForKey:@"mobile"]];
        if (mobile.length > 0) {
            PhoneViewController*phone=[[PhoneViewController alloc]init];
            phone.token = _token;
            phone.uid = _uid;
            phone.phoneNum = [NSString stringWithFormat:@"%@",mobile];
            NSLog(@"===================%@",phone.phoneNum);
            [self.navigationController pushViewController:phone animated:YES];
        }else{
            PhoneBangdingViewController*pbd=[[PhoneBangdingViewController alloc]init];
            pbd.token = _token;
            pbd.uid = _uid;
            [self.navigationController pushViewController:pbd animated:YES];
        
        }
      
    }else if (indexPath.row==2){
        NSString *email = [NSString stringWithFormat:@"%@",[ Data objectForKey:@"email"]];
        if (email.length > 0) {
            YouXiangViewController*YOUXIANG=[[YouXiangViewController alloc]init];
            YOUXIANG.token = _token;
            YOUXIANG.uid = _uid;
            YOUXIANG.youxiangNum = [_detailArray objectAtIndex:indexPath.row];
            NSLog(@"YOUXIANG.youxiangNum===============%@",YOUXIANG.youxiangNum);
            [self.navigationController pushViewController:YOUXIANG animated:YES];
        }else{
            YouxiangBangdingViewController*yxBangding=[[YouxiangBangdingViewController alloc]init];
            yxBangding.token = _token;
            yxBangding.uid = _uid;
            [self.navigationController pushViewController:yxBangding animated:YES];
        }
    }else if (indexPath.row==0){
        NSString*zhanghao=[NSString stringWithFormat:@"%@",[Data objectForKey:@"username"]];
        if ([zhanghao isEqualToString:@"(null)"]||[zhanghao isEqualToString:@""]) {
            ZhanghaoBandingViewController*ZHVC=[[ZhanghaoBandingViewController alloc]init];
            ZHVC.token=_token;
            NSLog(@"_token = %@",_token);
            ZHVC.uid=_uid;
            [self.navigationController pushViewController:ZHVC animated:YES];
        }
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

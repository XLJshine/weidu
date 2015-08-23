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
@interface FangkeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *FangKeTableView;

@end

@implementation FangkeViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"我的访客";
        
        /*UIButton *lestButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lestButton setImage:[UIImage imageNamed:@"fanhuix@2x"] forState:UIControlStateNormal];
        [lestButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:lestButton];
        self.navigationItem.leftBarButtonItem = leftItem;*/
        
    }
    return self;
}
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
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
}
#pragma mark-UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
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
    cell.TimeLable.text=@"5分钟";
    cell.touXiangImage.image=[UIImage imageNamed:@"touxiang11@2x"];
    cell.nameLable.text=@"林迪";
    cell.zhiWeiLable.text=@"总经理";
    cell.gongSiLable.text=@"北京光宇在线科技有限公司";
    cell.gongTongFriendLable.text=@"共同好友33人";
    cell.renMaiImage.image=[UIImage imageNamed:@"renmai2@2x"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GerenInfoViewController *GVC = [[GerenInfoViewController alloc]init];
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

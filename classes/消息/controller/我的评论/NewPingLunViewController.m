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
@interface NewPingLunViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mytableView;

//footView
@property (strong, nonatomic)FootTabelView * foot;
@end

@implementation NewPingLunViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"我的评论";
        
    }
    return self;
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _mytableView.delegate=self;
    _mytableView.dataSource=self;
    
    [self.mytableView registerNib:[UINib nibWithNibName:@"NewPinglunTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //在tableView下面接一个footView用来去掉tableView多余的线
    _foot = [[NSBundle mainBundle] loadNibNamed:@"FootTabelView" owner:self options:0][0];
    _mytableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    _mytableView.tableFooterView.userInteractionEnabled = YES;
    _mytableView.tableFooterView = _foot;
    //去掉tableivew的多余线
    _mytableView.tableFooterView=[[UIView alloc]init];
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
    return 8;
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
    
    return cell;
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

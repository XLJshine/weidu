//
//  JiFenViewController.m
//  时时投
//
//  Created by h on 15/7/25.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "JiFenViewController.h"
#import "JiFenTableViewCell.h"
#import "renWuTableViewCell.h"

@interface JiFenViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic)UISegmentedControl *mySegmentedControl1;
@property (strong, nonatomic)UIView *headview;
@end

@implementation JiFenViewController{
    BOOL jiFen_or_Not;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"我的积分";
        
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JiFenViewController"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JiFenViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    jiFen_or_Not = YES;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    _myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.frame = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 104);
    _headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    _headview.backgroundColor = [UIColor clearColor];
    _myTableView.tableHeaderView = _headview;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"JiFenTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"renWuTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
   
      _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mySegmentedControl1 =[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"我的积分",@"积分任务", nil]];
    _mySegmentedControl1.frame = CGRectMake(self.view.bounds.size.width - 220, 5, 200, 30);
    _mySegmentedControl1.backgroundColor = [UIColor whiteColor];
    [_mySegmentedControl1 setTintColor:[UIColor colorWithRed:0.2667 green:0.6941 blue:0.9059 alpha:1]];
    _mySegmentedControl1.selectedSegmentIndex = 0;
    _mySegmentedControl1.layer.cornerRadius = 4;
    _mySegmentedControl1.layer.masksToBounds = YES;
    [self.view addSubview:_mySegmentedControl1];
    [_mySegmentedControl1 addTarget:self action:@selector(Change:) forControlEvents:UIControlEventValueChanged];
}
- (void)Change:(UISegmentedControl *)segmentedControl{
    if (segmentedControl.selectedSegmentIndex == 0) {
        NSLog(@"我的积分");
        self.title = @"我的积分";
        jiFen_or_Not = YES;
          _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _headview.frame = CGRectMake(0, 0, self.view.bounds.size.width, 10);
        _headview.backgroundColor = [UIColor clearColor];
        _myTableView.tableHeaderView = _headview;
        
        [_myTableView reloadData];
    }else if (segmentedControl.selectedSegmentIndex == 1){
        NSLog(@"积分任务");
        self.title = @"积分任务";
          _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        jiFen_or_Not = NO;
        _myTableView.tableHeaderView = nil;
        
        [_myTableView reloadData];
    
    }
}

#pragma mark-UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (jiFen_or_Not) {
          return 114;
    }else{
        return 126;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (jiFen_or_Not) {
        JiFenTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.shangPinImage.image=[UIImage imageNamed:@"shangpin@2x"];
        cell.shangPinNameLabel.text=@"苏泊尔热水壶";
        cell.jiFen.text=@"4200";
        
        
        
        return cell;
    }else{
        renWuTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.xinShoRenwuLable.text=@"新手任务1";
        cell.renWuLable.text=@"完善信息";
        cell.ZhiXingRenwuLable.text=@"登录个人中心完善个人信息";
        cell.jiangLiLable.text=@"奖励:+5积分";
        
        
        
        return cell;
    }
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

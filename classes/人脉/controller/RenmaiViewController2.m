//
//  RenmaiViewController2.m
//  时时投
//
//  Created by 熊良军 on 15/7/29.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "RenmaiViewController2.h"
#import "MJRefresh.h"
#import "MJChiBaoZiFooter.h"
#import "AppDelegate.h"
#import "TongxunluViewController.h"
#import "RenmaiTongxunTableViewCell.h"
#import "RenmaiTuijianTableViewCell.h"
#import "RenmaiQQTableViewCell.h"
#import "RemaiButton.h"
static RenmaiViewController2 *instance;
@interface RenmaiViewController2 ()<UITableViewDataSource,UITableViewDelegate,RenmaiTongxunTableViewCellDelegate,RenmaiTuijianTableViewCellDelegate,RenmaiQQTableViewCellDelegate>
@property (nonatomic ,strong)UITableView *tableview;
/** 用来显示的假数据 */
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic)RemaiButton *RB;
@property (strong, nonatomic)RemaiButton *RB1;
@property (strong, nonatomic)RemaiButton *RB2;
@end

@implementation RenmaiViewController2{
    int controlNum;
}
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
        
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人脉";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing@2x"]];
    controlNum = 0;
    [self selectButtonInit];
  
    [self initTableView];
    // Do any additional setup after loading the view.
}
- (void)selectButtonInit{
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    [self.view addSubview:headview];
    NSArray *normalArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"renmai03@2x"],[UIImage imageNamed:@"renmai05@2x"], nil];
    NSArray *selectArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"renmai02@2x"],[UIImage imageNamed:@"renmai00@2x"], nil];
    NSArray *titleArray = [NSArray arrayWithObjects:@"通讯录",@"QQ",nil];
    
    _RB = [[RemaiButton alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width * 0.5, 40) normalimage:[normalArray objectAtIndex:0] hImage:nil SImage:[selectArray objectAtIndex:0]];
    _RB.backgroundColor = [UIColor whiteColor];
    [_RB setTitleColor:[UIColor colorWithRed:0.2745 green:0.6588 blue:0.8471 alpha:1] forState:UIControlStateSelected];
    [_RB setTitleColor:[UIColor colorWithWhite:0.5020 alpha:1] forState:UIControlStateNormal];
    [_RB setTitle:[titleArray objectAtIndex:0] forState:UIControlStateNormal];
    _RB.selected = YES;
    _RB.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _RB.titleLabel.textAlignment = NSTextAlignmentLeft;
    _RB.tag = 0;
    [_RB addTarget:self action:@selector(renmaiAction:) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:_RB];
    
    
    _RB1 = [[RemaiButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * 0.5 * 1, 0,self.view.bounds.size.width * 0.5, 40) normalimage:[normalArray objectAtIndex:1] hImage:nil SImage:[selectArray objectAtIndex:1]];
    _RB1.backgroundColor = [UIColor whiteColor];
    [_RB1 setTitleColor:[UIColor colorWithRed:0.2745 green:0.6588 blue:0.8471 alpha:1] forState:UIControlStateSelected];
    [_RB1 setTitleColor:[UIColor colorWithWhite:0.5020 alpha:1] forState:UIControlStateNormal];
    [_RB1 setTitle:[titleArray objectAtIndex:1] forState:UIControlStateNormal];
    _RB1.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _RB1.titleLabel.textAlignment = NSTextAlignmentLeft;
    _RB1.tag = 1;
    [_RB1 addTarget:self action:@selector(renmaiAction:) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:_RB1];
    
    
  
    
    UIImageView *sepLine = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * 0.5, 4, 1, headview.bounds.size.height - 8)];
    sepLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [headview addSubview:sepLine];
    
   

}
- (void)renmaiAction:(RemaiButton *)btn{
    if (btn.selected == NO) {
        btn.selected = !btn.selected;
        switch (btn.tag) {
            case 0:
            {
                controlNum = 0;
                _RB1.selected = NO;
           
                
                
                
                [_tableview reloadData];
                NSLog(@"1");
            }
                break;
            case 1:
            {
                controlNum = 1;
                _RB.selected = NO;
          
                
                [_tableview reloadData];
                NSLog(@"2");
            }
                break;
      
                
            default:
                break;
        }
    }
    
    
    
}
#pragma mark----实例化---
- (void)initTableView{
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height- 64 - 50)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableview.backgroundColor = [UIColor clearColor];
    [_tableview registerNib:[UINib nibWithNibName:@"RenmaiTongxunTableViewCell" bundle:nil] forCellReuseIdentifier:@"RenmaiCell"];
     //[_tableview registerNib:[UINib nibWithNibName:@"RenmaiTuijianTableViewCell" bundle:nil] forCellReuseIdentifier:@"RenmaiCell1"];
     [_tableview registerNib:[UINib nibWithNibName:@"RenmaiQQTableViewCell" bundle:nil] forCellReuseIdentifier:@"RenmaiCell2"];
    [self.view addSubview:_tableview];
    
    // 下拉刷新
    _tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [_tableview.header endRefreshing];
        });
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableview.header.autoChangeAlpha = YES;
    
    //上拉刷新
    /*_tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
     // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     // 结束刷新
     [_tableview.footer endRefreshing];
     });
     }];*/
    MJChiBaoZiFooter *footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 当上拉刷新控件出现50%时（出现一半），就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新）
    //    footer.appearencePercentTriggerAutoRefresh = 0.5;
    
    // 隐藏刷新状态的文字
    footer.refreshingTitleHidden = YES;
    //设置footer
    _tableview.footer = footer;
    
}
- (void)loadMoreData{
    // 1.添加假数据
    
      
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableview reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [_tableview.footer endRefreshing];
    });
}
#pragma mark ----- tableview分割线从顶点开始
//******tableview分割线从顶点开始********************
-(void)viewDidLayoutSubviews
{
    if ([_tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
#pragma mark -tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (controlNum == 0) {
         return 60;
    }else{
        return 60;
    }
   
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (controlNum == 0) {
        RenmaiTongxunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RenmaiCell"];
        cell.delegate = self;
        cell.userImageView.image = [UIImage imageNamed:@"touxiang11"];
        cell.userName.text = [NSString stringWithFormat:@"林晓霞%li",(long)indexPath.row];
        cell.resource.text = [NSString stringWithFormat:@"手机联系人：%@",@"晓霞"];
        [cell addButton:indexPath.row];
       
        
        return cell;
    }else{
        RenmaiQQTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RenmaiCell2"];
        cell.delegate = self;
        cell.userImageView.image = [UIImage imageNamed:@"touxiang11"];
        cell.userName.text = [NSString stringWithFormat:@"王祖蓝%li",(long)indexPath.row];
        cell.resource.text = [NSString stringWithFormat:@"QQ好友：%@",@"祖蓝"];
        [cell addButton:indexPath.row];
        
        return cell;
    }
    
    /*{
        RenmaiTuijianTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RenmaiCell1"];
        cell.delegate = self;
        cell.gongsi.text = [NSString stringWithFormat:@"扩大科技有限公司%li",(long)indexPath.row];
        cell.userImageView.image = [UIImage imageNamed:@"touxiang11"];
        cell.name.text = [NSString stringWithFormat:@"王大锤%li",(long)indexPath.row];
        cell.zhiwu.text = [NSString stringWithFormat:@"技术总监%li",(long)indexPath.row];
        cell.haoyouNum.text = [NSString stringWithFormat:@"23%li",(long)indexPath.row];
        cell.jifenNum.text = [NSString stringWithFormat:@"32%li",(long)indexPath.row];
        cell.meiliNum.text = [NSString stringWithFormat:@"22%li",(long)indexPath.row];
        cell.shoucangNum.text = [NSString stringWithFormat:@"43%li",(long)indexPath.row];
        cell.userDetail.text = [NSString stringWithFormat:@"只要你确定自己正确就去做。做了有人说不好，不做还是有人说不好，不要逃避批判%li",(long)indexPath.row];
        [cell addButton:indexPath.row];
        
        return cell;
        
    }*/
}
- (void)TongxuntableViewCell:(RenmaiTongxunTableViewCell *)cell  index:(NSInteger)index{
    NSLog(@"通讯%li",(long)index);

}
- (void)TuijiantableViewCell:(RenmaiTuijianTableViewCell *)cell index:(NSInteger)index{
     NSLog(@"推荐%li",(long)index);
    
}
- (void)QQtableViewCell:(RenmaiQQTableViewCell *)cell index:(NSInteger)index{
   NSLog(@"QQ%li",(long)index);

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

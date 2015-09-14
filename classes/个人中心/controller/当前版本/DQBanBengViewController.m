//
//  DQBanBengViewController.m
//  时时投
//
//  Created by h on 15/8/26.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "DQBanBengViewController.h"
#import "DQBanBengTableViewCell.h"
#import "YiJianViewController.h"
#import "WelcomeScrollViewController.h"

static DQBanBengViewController *instance;
@interface DQBanBengViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong)UIAlertView*PFalter;
@end

@implementation DQBanBengViewController
{
    NSMutableArray*_lableArr;//存储头部名字
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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DangqianBan_ban_ViewController"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DangqianBan_ban_ViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"当前版本";
     [self creadData];
    _PFalter.delegate=self;
    
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.bounces = NO;
    [_myTableView registerNib:[UINib nibWithNibName:@"DQBanBengTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}


- (void)creadData{
   
    _lableArr=[@[@"去评分",@"欢迎页",@"意见与反馈",@"更新版本"]mutableCopy];
    
}

//******tableview分割线从顶点开始********************
-(void)viewDidLayoutSubviews
{
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DQBanBengTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.Title.text=[_lableArr objectAtIndex:indexPath.row] ;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //去评分
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        _PFalter = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"去给'%@'打分吧！",appName]
                                                            message:@"您的评价对我们很重要"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"稍后评价",@"去评价",nil];
        _PFalter.tag = 1;
        [_PFalter show];
        
           }else if (indexPath.row == 1){
        //欢迎页
        WelcomeScrollViewController * wel = [[WelcomeScrollViewController alloc]init];
        [self presentViewController:wel animated:YES completion:nil];
    }else if (indexPath.row == 2){
        //意见与反馈
        YiJianViewController*YJVC=[[YiJianViewController alloc]init];
        YJVC.token=_token;
        YJVC.uid=_uid;
        [self.navigationController pushViewController:YJVC animated:YES];
        
    }else if (indexPath.row == 3){
        //更新版本
        UIAlertView*alter=[[UIAlertView alloc]initWithTitle:@"恭喜" message:@"您是最新版本" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _PFalter) {
        if (buttonIndex==0) {
            NSLog(@"取消评论");
        }else{
            NSLog(@"给好评");
            
            NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id990170805"];
            //只针对IOS7及以上版本
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        
    }
    
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

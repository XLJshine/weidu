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

@interface DingYueXiaoXiViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * _imaArr;//存储图片的数组
    NSMutableArray*_lableArr;//存储名字
}
@property (weak, nonatomic) IBOutlet UITableView *xiaoxiTableView;
@property (strong, nonatomic)FootTabelView * foot;

@end

@implementation DingYueXiaoXiViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"订阅消息";
        
        
        
    }
    return self;
}
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return _imaArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    xiaoxiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.Image.image = [UIImage imageNamed:_imaArr[indexPath.row]];
    cell.name.text = [_lableArr objectAtIndex:indexPath.row];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1){
       
    }else if (indexPath.row == 2){
        
    }else if (indexPath.row == 3){
        
        
    }else if (indexPath.row == 4){
        
        
    }else{
        
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

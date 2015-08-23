//
//  ShouCangViewController.m
//  dayang
//
//  Created by chendong on 15/7/20.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "ShouCangViewController.h"
#import "ToubiaoTableViewCell.h"
#import "MyShouCangTableViewCell.h"
#import "AppDelegate.h"
#import "MyItemButton.h"
#import "XiangmuPinglinButton.h"
#import "MobClick.h"
#import "ToubiaoDetailViewController.h"
static ShouCangViewController *instance;
@interface ShouCangViewController ()<UITableViewDataSource,UITableViewDelegate,ShouCangTableViewCellDelegate>
@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@end

@implementation ShouCangViewController
+ (id)shareInstance
{
    if (instance == nil)
    {
        instance = [[[self class]alloc]init];
    }
    return instance;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // this UIViewController is about to re-appear, make sure we remove the current selection in our table view
    NSIndexPath *tableSelection = [self.tableview indexPathForSelectedRow];
    [self.tableview deselectRowAtIndexPath:tableSelection animated:NO];
    [MobClick beginLogPageView:@"StoreMainPage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"StoreMainPage"];
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"收藏";
        
        
        UIImage *backImg = [UIImage imageNamed:@"caidan@2x"];
        MyItemButton *backBtn = [[MyItemButton alloc] initWithFrame:CGRectMake(0.f, 0.f, backImg.size.width/0.6, backImg.size.height/0.6)];
        [backBtn addTarget:self action:@selector(push1) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:backImg forState:UIControlStateNormal];
        UIView *backBtnView = [[UIView alloc] initWithFrame:backBtn.bounds];
        backBtnView.bounds = CGRectOffset(backBtnView.bounds, 10, 0);
        [backBtnView addSubview:backBtn];
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
        self.navigationItem.leftBarButtonItem = backBarBtn;
        
        
        UIImage *backImg1 = [UIImage imageNamed:@"tianjia@2x"];
        MyItemButton *backBtn1 = [[MyItemButton alloc] initWithFrame:CGRectMake(0.f, 0.f, backImg1.size.width/0.6, backImg1.size.height/0.6)];
        [backBtn1 addTarget:self action:@selector(push2) forControlEvents:UIControlEventTouchUpInside];
        [backBtn1 setImage:backImg1 forState:UIControlStateNormal];
        UIView *backBtnView1 = [[UIView alloc] initWithFrame:backBtn1.bounds];
        backBtnView1.bounds = CGRectOffset(backBtnView.bounds, -20, 0);
        [backBtnView1 addSubview:backBtn1];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:backBtnView1];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        //self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

-(void)push1{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController = [delegate siderViewController];
    [sideViewController showLeftViewController:YES];
    
    //显示主界面半透明视图
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewAppear" object:nil userInfo:nil];
    
}
-(void)push2{

    
}
- (void)viewDidAppear:(BOOL)animated{
    if (_ifModelNavigation.length > 0) {  //xianshicehua
        [[NSNotificationCenter defaultCenter]postNotificationName:@"xianshicehua" object:nil userInfo:nil];
    }
    _ifModelNavigation = @"";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.tabBarController.tabBar.hidden = YES;
    
    _dataArray = [[NSMutableArray alloc]initWithObjects:@"1",@"1",@"1",@"1",@"1", nil];
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 49 - 64)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.tag = 1;
    [self.view addSubview:_tableview];
    UIView *footview = [[UIView alloc]init];
    footview.backgroundColor = [UIColor whiteColor];
    _tableview.tableFooterView = footview;
}

#pragma mark -tableViewDelegate
/*- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return _tableview.tag;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //判断表格是否需要删除数据
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_dataArray removeObjectAtIndex:indexPath.row];
        [_tableview deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
        
     }
}*/
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier1 = @"statusCell2";
    MyShouCangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (cell == nil) {
        cell = [[MyShouCangTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1 title:@"110kv花期法律；化工二库萨机构埃及俄独立的 v 叫啊人家过快仨当局 i 肉看看女哦哦啊让 v空间都 is 减肥 i 哦是多哈工人难过IE化工 i 然后古俄奥PDF红人哦 i 阿萨德譬如结果i 哦素古人配爱破啊俄方将陪我哈土坷垃无奈方法叫阿俄华人旅客啊防护屙咖了入户率妇女节lakh 吞弗兰克首都人"
                                                   hangye:@"网络通讯计算机" location:@"上海" time:@"2015-07-20" detail:@"期法律；化工二库萨机构埃及俄独立的 v 叫啊人家过快仨当局 i 肉看看女哦哦啊让 v空间都 is 减肥 i 哦是多哈工人难过IE化工 i 然后古俄奥PDF红人哦 i 阿萨德譬如结果i 哦素古人配爱破啊俄方将陪我哈土坷垃无奈方法叫阿俄华人旅客啊防护屙咖了入户率妇女节lakh 吞弗兰克首都人"];
    }else{
        cell.title.text = @"110kv花期法律；化工二库萨机构埃及俄独立的 v 叫啊人家过快仨当局 i 肉看看女哦哦啊让 v空间都 is 减肥 i 哦是多哈工人难过IE化工 i 然后古俄奥PDF红人哦 i 阿萨德譬如结果i 哦素古人配爱破啊俄方将陪我哈土坷垃无奈方法叫阿俄华人旅客啊防护屙咖了入户率妇女节lakh 吞弗兰克首都人";
        cell.hangye.text = @"网络通讯计算机";
        cell.location.text = @"上海";
        cell.time.text = @"2015-07-20";
        cell.detail.text = @"期法律；化工二库萨机构埃及俄独立的 v 叫啊人家过快仨当局 i 肉看看女哦哦啊让 v空间都 is 减肥 i 哦是多哈工人难过IE化工 i 然后古俄奥PDF红人哦 i 阿萨德譬如结果i 哦素古人配爱破啊俄方将陪我哈土坷垃无奈方法叫阿俄华人旅客啊防护屙咖了入户率妇女节lakh 吞弗兰克首都人";
    }
    
    NSString *zannum1 = @"46";
    [cell.zanbtn setTitle:zannum1 forState:UIControlStateNormal];
    [cell.liulanbtn setTitle:@"29" forState:UIControlStateNormal];
    [cell.pinglunbtn setTitle:[NSString stringWithFormat:@"%li",(long)indexPath.row] forState:UIControlStateNormal];
    
    
     __block int number1 = 0;
    [cell blockButtonAction:^(NSInteger index){
        NSLog(@"index = %li,indexPath.row = %li",(long)index,(long)indexPath.row);
        if (index == 0) {
            NSString *zannumStr = zannum1;
            int zannum = [zannumStr intValue];
            zannum ++;
            NSLog(@"zannum = %i",zannum);
            [cell.zanbtn setTitle:[NSString stringWithFormat:@"%i",zannum] forState:UIControlStateNormal];
            
            
        }else if (index == 1){
            
            
        }else if (index == 2){
            
            
        }else{
            if (number1 == 0) {
                cell.tanChuangView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 155, 45, 140, 25)];
                cell.tanChuangView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
                [cell.contentView addSubview:cell.tanChuangView];
                
                XiangmuPinglinButton *fenxiangButton = [[XiangmuPinglinButton alloc]initWithFrame:CGRectMake(10, cell.tanChuangView.bounds.size.height * 0.2, cell.tanChuangView.bounds.size.width * 0.5, cell.tanChuangView.bounds.size.height * 0.6)];
                [fenxiangButton setTitle:@"分享" forState:UIControlStateNormal];
                [fenxiangButton setBackgroundColor:[UIColor clearColor]];
                [fenxiangButton setImage:[UIImage imageNamed:@"shareImg@2x"] forState:UIControlStateNormal];
                fenxiangButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
                [fenxiangButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                fenxiangButton.tag = 0;
                [fenxiangButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.tanChuangView addSubview:fenxiangButton];
                
                XiangmuPinglinButton *shoucanButton = [[XiangmuPinglinButton alloc]initWithFrame:CGRectMake(cell.tanChuangView.bounds.size.width * 0.5 + 10, cell.tanChuangView.bounds.size.height * 0.2, cell.tanChuangView.bounds.size.width * 0.5, cell.tanChuangView.bounds.size.height * 0.6)];
                [shoucanButton setTitle:@"收藏" forState:UIControlStateNormal];
                [shoucanButton setBackgroundColor:[UIColor clearColor]];
                [shoucanButton setImage:[UIImage imageNamed:@"zhaobiaozan@2x"] forState:UIControlStateNormal];
                shoucanButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
                [shoucanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                shoucanButton.tag = 1;
                [shoucanButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.tanChuangView addSubview:shoucanButton];
                
                cell.tanChuangView.layer.masksToBounds = YES;
                cell.tanChuangView.layer.cornerRadius = 4;
                
                number1 = 1;
            }else if (number1 == 1){
                [cell.tanChuangView removeFromSuperview];
                number1 = 0;
            }

        
        }
        
        
    }];
    
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    return cell;
}
- (void)moreAction:(XiangmuPinglinButton *)btn{
    switch (btn.tag) {
        case 0:
        {
            NSLog(@"分享");
        }
            break;
        case 1:
        {
            NSLog(@"收藏");
        }
            break;
            
        default:
            break;
    }
    
}
-(void)didCellWillHide:(id)aSender{

}
-(void)didCellHided:(id)aSender{

}
-(void)didCellWillShow:(id)aSender{

}
-(void)didCellShowed:(id)aSender{

}
-(void)didCellClickedDeleteButton:(id)aSender  index:(NSInteger)index{
    NSLog(@"删除,index = %li",(long)index);
    
    NSIndexPath *vIndex = [_tableview indexPathForCell:aSender];
    [_dataArray removeObjectAtIndex:index];
    //[_tableview deleteRowsAtIndexPaths:[NSArray arrayWithObjects:vIndex, nil] withRowAnimation:UITableViewRowAnimationLeft];
    [_tableview deleteRowsAtIndexPaths:[NSArray arrayWithObjects:vIndex, nil] withRowAnimation:UITableViewRowAnimationLeft];
    [_tableview reloadData];
}
-(void)didCellClickedMoreButton:(id)aSender{
    NSLog(@"分享");
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ToubiaoDetailViewController *TVC = [[ToubiaoDetailViewController alloc]init];
    [self.navigationController pushViewController:TVC animated:YES];
}
/*- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideDock" object:nil userInfo:nil];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Dock" object:nil userInfo:nil];
}*/
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

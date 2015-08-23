//
//  NoMessageViewController.m
//  时时投
//
//  Created by 熊良军 on 15/7/23.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "NoMessageViewController.h"
#import "NoMessageTableViewCell.h"
#import "LableXLJ.h"
#import "WBBooksManager.h"
@interface NoMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic ,strong)NSArray *titleArray;
@property (nonatomic ,strong)NSArray *backgroundImageArray;


@end

@implementation NoMessageViewController{
    NSString *noMessage;
    NSArray *gouArray;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"功能消息免打扰";
        
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
    
    gouArray = [NSArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backgrondview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beijing@2x"]];
    [self.view addSubview:backgrondview];
    
    [self readBook];
    [self data];
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableview setBackgroundColor:[UIColor clearColor]];
    _tableview.scrollEnabled = NO;
    [self.view addSubview:_tableview];
    
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    headview.backgroundColor = [UIColor clearColor];
    _tableview.tableHeaderView = headview;
    
    
    LableXLJ *lable = [[LableXLJ alloc]initWithFrame:CGRectMake(10, 165, self.view.bounds.size.width - 20, 55) text:@"开启后，“QQ邮箱提醒”在收到邮件后，手机不会震动与发出提示音。如果设置为“只在夜间开启”，则只在22:00到8:00间生效。" textColor:[UIColor colorWithWhite:0.35 alpha:1] font:11 numberOfLines:3 lineSpace:7];
    [_tableview addSubview:lable];
    // Do any additional setup after loading the view.
}
- (void)readBook{
    NSMutableDictionary * resultDictionary = [[NSMutableDictionary alloc] init];
    [[WBBooksManager sharedInstance] readPlist:&resultDictionary];
    NSDictionary *tuiSongDic = [resultDictionary objectForKey:@"NoMessage"];
    noMessage = [tuiSongDic objectForKey:@"NoMessage"];
    if (noMessage.length == 0) {
        noMessage = @"2";
        gouArray = [NSArray arrayWithObjects:@"1",@"0",@"0", nil];
    }else if ([noMessage isEqualToString:@"2"]){
       gouArray = [NSArray arrayWithObjects:@"1",@"0",@"0", nil];
    }else if ([noMessage isEqualToString:@"1"]){
        gouArray = [NSArray arrayWithObjects:@"0",@"1",@"0", nil];
    }else if ([noMessage isEqualToString:@"0"]){
        gouArray = [NSArray arrayWithObjects:@"0",@"0",@"1", nil];
    }
}
- (void)data{
    _titleArray = [NSArray arrayWithObjects:@"开启",
                   @"只在夜间开启",
                   @"关闭",
                   nil];
    
    _backgroundImageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"chaangtiao1@2x"],[UIImage imageNamed:@"chaangtiao2@2x"],[UIImage imageNamed:@"chaangtiao3@2x"], nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier1 = @"statusCell3";
    NoMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    NSLog(@"noMessage = %@",noMessage);
    if (cell == nil) {
        cell = [[NoMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1 title:[_titleArray objectAtIndex:indexPath.row] detail:nil backgroundimage:[_backgroundImageArray objectAtIndex:indexPath.row] indexRow:(int)indexPath.row  messageNum:[gouArray objectAtIndex:indexPath.row]];
    }else{
        [cell title:[_titleArray objectAtIndex:indexPath.row] detail:nil backgroundimage:[_backgroundImageArray objectAtIndex:indexPath.row] indexRow:(int)indexPath.row  messageNum:[gouArray objectAtIndex:indexPath.row]];
    }
    
    if (indexPath.row == 0&&[noMessage isEqualToString:@"2"]) {
        cell.selected = YES;
        cell.chooseImage.hidden = NO;
    }else if (indexPath.row == 1&&[noMessage isEqualToString:@"1"]){
        cell.selected = YES;
        cell.chooseImage.hidden = NO;
    }else if(indexPath.row == 2&&[noMessage isEqualToString:@"0"]){
        cell.selected = YES;
        cell.chooseImage.hidden = NO;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    
    if (indexPath.row == 0){
        NSLog(@"开启");
        [userDic setValue:@"2" forKey:@"NoMessage"];
         gouArray = [NSArray arrayWithObjects:@"1",@"0",@"0", nil];
    }else if(indexPath.row == 1){
        NSLog(@"只在夜间开启");
        [userDic setValue:@"1" forKey:@"NoMessage"];
         gouArray = [NSArray arrayWithObjects:@"0",@"1",@"0", nil];
    }else{
        NSLog(@"关闭");
        [userDic setValue:@"0" forKey:@"NoMessage"];
         gouArray = [NSArray arrayWithObjects:@"0",@"0",@"1", nil];
    }
    
    //判断给出的Key对应的数据是否存在
    if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"NoMessage"]) {
        //存在，则替换之
        NSLog(@"存在，则替换之");
        [[WBBooksManager sharedInstance] replaceDictionary:userDic withDictionaryKey:@"NoMessage"];
    }else{//不存在，则写入
        NSLog(@"不存在，则写入");
        [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"NoMessage"];
    }
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_tableview reloadData];
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

//
//  NewMessageViewController.m
//  时时投
//
//  Created by 熊良军 on 15/7/23.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "NewMessageViewController.h"
#import "ZhanghaoSafeTableViewCell.h"
#import "NoMessageViewController.h"
#import "WBBooksManager.h"
@interface NewMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic ,strong)NSArray *titleArray;
@property (nonatomic ,strong)NSArray *backgroundImageArray;
@end

@implementation NewMessageViewController{
    NSString *messageDetail;
    NSString *video;
    NSString *zhendong;
     NSString *tuiSong;   //判断是否开启推送0
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"新消息通知";
        
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"NewMessageViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"NewMessageViewController"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
 
    // Do any additional setup after loading the view.
}
- (void)readBook{
    NSMutableDictionary * resultDictionary = [[NSMutableDictionary alloc] init];
    [[WBBooksManager sharedInstance] readPlist:&resultDictionary];
    NSDictionary *messageDetailDic = [resultDictionary objectForKey:@"messageDetail"];
    messageDetail = [messageDetailDic objectForKey:@"messageDetail"];
    if (messageDetail.length == 0) {
        messageDetail = @"0";
    }
    NSDictionary *videoDic = [resultDictionary objectForKey:@"video"];
    video = [videoDic objectForKey:@"video"];
    if (video.length == 0) {
        video = @"0";
    }
    NSDictionary *zhendongDic = [resultDictionary objectForKey:@"zhendong"];
    zhendong = [zhendongDic objectForKey:@"zhendong"];
    if (zhendong.length == 0) {
        zhendong = @"0";
    }
    
    NSDictionary *tuiSongDic = [resultDictionary objectForKey:@"shezhi"];
    tuiSong = [tuiSongDic objectForKey:@"tuiSong"];
    if (tuiSong.length == 0) {
        tuiSong = @"0";
    }
    NSLog(@"%@%@%@%@",tuiSong,messageDetail,video,zhendong);


}
- (void)data{
    _titleArray = [NSArray arrayWithObjects:@"推送通知",@"接收新消息",
                   @"通知显示消息详情",
                   @"功能消息免打扰",
                   @"声音",
                   @"震动",
                   nil];
 
    _backgroundImageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"chaangtiao1@2x"],[UIImage imageNamed:@"chaangtiao2@2x"],[UIImage imageNamed:@"chaangtiao2@2x"],[UIImage imageNamed:@"chaangtiao2@2x"],[UIImage imageNamed:@"chaangtiao2@2x"],[UIImage imageNamed:@"chaangtiao3@2x"], nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier1 = @"statusCell3";
    ZhanghaoSafeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (cell == nil) {
        cell = [[ZhanghaoSafeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1 title:[_titleArray objectAtIndex:indexPath.row] detail:nil backgroundimage:[_backgroundImageArray objectAtIndex:indexPath.row]];
        
    }else{
        [cell title:[_titleArray objectAtIndex:indexPath.row] detail:nil backgroundimage:[_backgroundImageArray objectAtIndex:indexPath.row]];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 1) {
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 72, 19, 40, 12)];
        lable.text = @"已开启";
        lable.textAlignment = NSTextAlignmentRight;
        lable.textColor = [UIColor grayColor];
        lable.font = [UIFont systemFontOfSize:12.0];
        [cell.contentView addSubview:lable];
    }
    
    if (indexPath.row == 3) {
        UIImageView *arrawImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 42, 19, 12, 12)];
        [arrawImage setImage:[UIImage imageNamed:@"fangRight@2x"]];
        [cell.contentView addSubview:arrawImage];
    }
    if (indexPath.row == 0) {
        UISwitch *switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 80, 10, 30, 10)];
        if ([tuiSong isEqualToString:@"1"]) {
            switchBtn.on = YES;
        }else{
            switchBtn.on = NO;
        }
        
        [switchBtn addTarget:self action:@selector(switchAction1:) forControlEvents:UIControlEventTouchUpInside];
        switchBtn.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:switchBtn];
    }
    if(indexPath.row == 2||indexPath.row == 4||indexPath.row == 5){
        UISwitch *switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 80, 10, 30, 10)];
        if (indexPath.row == 2&&[messageDetail isEqualToString:@"1"]) {
            switchBtn.on = YES;
        }else if(indexPath.row == 2&&[messageDetail isEqualToString:@"0"]){
            switchBtn.on = NO;
        }else if(indexPath.row == 4&&[video isEqualToString:@"1"]){
            switchBtn.on = YES;
        }else if(indexPath.row == 4&&[video isEqualToString:@"0"]){
             switchBtn.on = NO;
        }else if(indexPath.row == 5&&[zhendong isEqualToString:@"1"]){
            switchBtn.on = YES;
        }else if(indexPath.row == 5&&[zhendong isEqualToString:@"0"]){
             switchBtn.on = NO;
        }
        switchBtn.tag = indexPath.row;
        [switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        switchBtn.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:switchBtn];
    }
    return cell;
}
- (void)switchAction1:(UISwitch *)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    if (isButtonOn){
        NSLog(@"打开");
        [userDic setValue:@"1" forKey:@"tuiSong"];
        
    }else{
        NSLog(@"关闭");
        [userDic setValue:@"0" forKey:@"tuiSong"];
    }
    
    //判断给出的Key对应的数据是否存在
    if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"shezhi"]) {
        //存在，则替换之
        NSLog(@"存在，则替换之");
        [[WBBooksManager sharedInstance] replaceDictionary:userDic withDictionaryKey:@"shezhi"];
    }else{//不存在，则写入
        NSLog(@"不存在，则写入");
        [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"shezhi"];
    }
}
- (void)switchAction:(UISwitch *)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    switch (sender.tag) {
        case 2:
        {
            
            NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
            if (isButtonOn){
                NSLog(@"打开1");
                [userDic setValue:@"1" forKey:@"messageDetail"];
            }else{
                NSLog(@"关闭1");
                 [userDic setValue:@"0" forKey:@"messageDetail"];
            }
            //判断给出的Key对应的数据是否存在
            if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"messageDetail"]) {
                //存在，则替换之
                NSLog(@"存在，则替换之");
                [[WBBooksManager sharedInstance] replaceDictionary:userDic withDictionaryKey:@"messageDetail"];
            }else{//不存在，则写入
                NSLog(@"不存在，则写入");
                [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"messageDetail"];
            }
        }
            break;
        case 4:
        {
            NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
            if (isButtonOn){
                NSLog(@"打开3");
                 [userDic setValue:@"1" forKey:@"video"];
            }else{
                NSLog(@"关闭3");
                 [userDic setValue:@"0" forKey:@"video"];
            }
            //判断给出的Key对应的数据是否存在
            if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"video"]) {
                //存在，则替换之
                NSLog(@"存在，则替换之");
                [[WBBooksManager sharedInstance] replaceDictionary:userDic withDictionaryKey:@"video"];
            }else{//不存在，则写入
                NSLog(@"不存在，则写入");
                [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"video"];
            }
        }
            break;
        case 5:
        {
            NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
            if (isButtonOn){
                NSLog(@"打开4");
                 [userDic setValue:@"1" forKey:@"zhendong"];
            }else{
                NSLog(@"关闭4");
                 [userDic setValue:@"0" forKey:@"zhendong"];
            }
            //判断给出的Key对应的数据是否存在
            if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"zhendong"]) {
                //存在，则替换之
                NSLog(@"存在，则替换之");
                [[WBBooksManager sharedInstance] replaceDictionary:userDic withDictionaryKey:@"zhendong"];
            }else{//不存在，则写入
                NSLog(@"不存在，则写入");
                [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"zhendong"];
            }
        }
            break;

        default:
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3) {
        NoMessageViewController *NVC = [[NoMessageViewController alloc]init];
        [self.navigationController pushViewController:NVC animated:YES];
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

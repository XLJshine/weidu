//
//  ShezhiViewController.m
//  时时投
//
//  Created by 熊良军 on 15/7/23.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "ShezhiViewController.h"
#import "ShezhiTableViewCell.h"
#import "ZhanghaoSafeViewController.h"

#import "ShowWaysViewController.h"
#import "WBBooksManager.h"
#import "DangqianBanbenTableViewController.h"
#import "DQBanBengViewController.h"
static ShezhiViewController *instance;
#define seplineColor  [UIColor colorWithWhite:0.8 alpha:1]
@interface ShezhiViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic ,strong)NSArray *imageArray;
@property (nonatomic ,strong)NSArray *titleArray;
@property (nonatomic ,strong)NSArray *backgroundImageArray;
@end

@implementation ShezhiViewController{
    NSString *tuiSong;    //判断是否开启推送0为关，1为开
    AFHTTPRequestOperationManager *manager;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"设置";
        
        /*UIButton *lestButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lestButton setImage:[UIImage imageNamed:@"fanhuix@2x"] forState:UIControlStateNormal];
        [lestButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:lestButton];
        self.navigationItem.leftBarButtonItem = leftItem;*/
    
    }
    return self;
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
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ShezhiViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShezhiViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //网络
    manager = [AFHTTPRequestOperationManager manager];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backgrondview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beijing@2x"]];
    [self.view addSubview:backgrondview];
    
    [self readBook];
    
    [self data];
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = [UIColor clearColor];
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
    NSDictionary *tuiSongDic = [resultDictionary objectForKey:@"shezhi"];
    tuiSong = [tuiSongDic objectForKey:@"tuiSong"];
    if (tuiSong.length == 0) {
        tuiSong = @"0";
    }
}
- (void)data{
    _imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"shezhi1@2x"],[UIImage imageNamed:@"shezhi4@2x"],[UIImage imageNamed:@"shezhi6@2x"], nil];
    
    _titleArray = [NSArray arrayWithObjects:@"账户安全",
                   
                   @"清理缓存",
                   
                   @"当前版本",nil];
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
    static NSString *cellIdentifier1 = @"statusCell2";
    ShezhiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    
    if (cell == nil) {
        cell = [[ShezhiTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1 image:[_imageArray objectAtIndex:indexPath.row] title:[_titleArray objectAtIndex:indexPath.row] backgroundimage:[_backgroundImageArray objectAtIndex:indexPath.row]];
    
    }else{
        [cell image:[_imageArray objectAtIndex:indexPath.row] title:[_titleArray objectAtIndex:indexPath.row] backgroundimage:[_backgroundImageArray objectAtIndex:indexPath.row]];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    if (indexPath.row == 0||indexPath.row == 2||indexPath.row == 3) {
//        UIImageView *arrawImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 42, 19, 12, 12)];
//        [arrawImage setImage:[UIImage imageNamed:@"fangRight@2x"]];
//        [cell.contentView addSubview:arrawImage];
//        
//       
//    }
    //添加switch
    /*if (indexPath.row == 1) {
        UISwitch *switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 80, 10, 30, 10)];
        if ([tuiSong isEqualToString:@"1"]) {
            switchBtn.on = YES;
            NSLog(@"11111");
        }else{
            switchBtn.on = NO;
            NSLog(@"00000");
        }
        
        [switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
       
        [cell.contentView addSubview:switchBtn];
    }*/
    
    return cell;
}

-(void)switchAction1:(UISwitch*)send{
    
   
    

}
- (void)switchAction:(UISwitch *)sender{
    NSLog(@"sender.on=========%i",sender.on);
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
    
  
    NSString*URl=[NSString stringWithFormat:@"%@account/save-setting?access-token=%@",ApiUrlHead,_token];
    NSDictionary *_textDIC = [NSDictionary dictionary];
    if (sender.on) {
        _textDIC = @{@"push_msg": @"1"};
        [manager POST:URl parameters:_textDIC success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSLog(@"消息发送成功");
                //判断给出的Key对应的数据是否存在
                if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"shezhi"]) {
                    //存在，则替换之
                    NSLog(@"存在，则替换之");
                    [[WBBooksManager sharedInstance] replaceDictionary:userDic withDictionaryKey:@"shezhi"];
                }else{//不存在，则写入
                    NSLog(@"不存在，则写入");
                    [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"shezhi"];
                }
                
                
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                NSLog(@"error=%@",error);
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            
        }];
        
    }else{
        _textDIC = @{@"push_msg": @"0"};
        [manager POST:URl parameters: _textDIC success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSLog(@"消息发送成功");
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
            else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                NSLog(@"error=%@",error);
                
            }
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
                  
                  
              }];
    }
    

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ZhanghaoSafeViewController *ZVC = [[ZhanghaoSafeViewController alloc]init];
        ZVC.token = _token;
        ZVC.uid = _uid;
        [self.navigationController pushViewController:ZVC animated:YES];
    }else if (indexPath.row == 1){
        //提示窗弹出
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否确定清理缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert1 show];
    }else if (indexPath.row == 2){
//        DangqianBanbenTableViewController *DVC = [[DangqianBanbenTableViewController alloc]init];
//        [self.navigationController pushViewController:DVC animated:YES];
        DQBanBengViewController*DQVC=[[DQBanBengViewController alloc]init];
        DQVC.token = _token;
        DQVC.uid = _uid;
        [self.navigationController pushViewController:DQVC animated:YES];
        
    }else if (indexPath.row == 5){
        
        
    }else if (indexPath.row == 6){
        
    }else{
    
    }
}

#pragma mark -- UIAlertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //删除缓存
        NSString *cachPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/PermanentStore"];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        
        NSLog(@"files :%i",(int)[files count]);
        
        for (NSString *p in files) {
            
            NSError *error;
            
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                
            }
        }
        //计算缓存文件大小
        
        float a =  [self folderSizeAtPath:cachPath];
         UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"已清理%.2fM缓存",a] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
          [alert1 show];
    }
    else return;
}
//单个文件的大小

- (long long) fileSizeAtPath:(NSString*) filePath
{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    return 0;
    
}
//遍历文件夹获得文件夹大小，返回多少M

- (float ) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString * fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
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

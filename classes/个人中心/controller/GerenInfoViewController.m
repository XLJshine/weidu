//
//  GerenInfoViewController.m
//  时时投
//
//  Created by 熊良军 on 15/7/27.
//  Copyright (c) 2015年 chendong. All rights reserved.
//
//他的个人信息
#import "GerenInfoViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+MJWebCache.h"
#import "GerenInfoTableViewCell.h"

#import "AddMoreTableViewCell.h"
#import "STAlertView.h"
#import "ChangeInfoViewController.h"
#import "MyItemButton.h"
#import "Reduce_Simple_image.h"
#import "AFNetworking.h"
#import "ChatViewController.h"

@interface GerenInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSMutableArray * _proArr;//用来存储地区的数据
    NSMutableArray*_jobArr;//用来存储职位的数组
    NSMutableArray*_tradeArr;//用来存储行业的数组

}

@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic ,strong)NSArray *titleArray;
@property (nonatomic ,strong)NSArray *detailTitleArray;
@property (nonatomic ,strong)NSArray *headTitleArray;
@property (nonatomic, strong) STAlertView *stAlertView;

@property(nonatomic,strong)NSMutableArray*mainArray;

@end

@implementation GerenInfoViewController{
    BOOL isPhoto;
    UIImageView *userImageView;
    
    AFHTTPRequestOperationManager *manager;
    NSMutableDictionary * _DataArray;//存储数据

}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"个人信息";
        
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"GerenInfo_His_ViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"GerenInfo_His_ViewController"];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    UIImageView *backgrondview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beijing@2x"]];
//    [self.view addSubview:backgrondview];
    [self initdata];
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_tableview];
    
    [self addTableviewHead];
    
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"geren" userInfo:nil];
   //==================下面写的是刷数据===============
    
    _proArr=[[NSMutableArray alloc]init];
    _jobArr=[[NSMutableArray alloc]init];
    _tradeArr=[[NSMutableArray alloc]init];
    
    NSArray *arr1= [NSArray arrayWithObjects:@"",@"",@"",nil];
    NSArray *arr2= [NSArray arrayWithObjects:@"",@"",@"",nil];
    NSArray *arr3= [NSArray arrayWithObjects:@"",@"",@"",nil];
    _mainArray = [NSMutableArray arrayWithObjects:arr1,arr2, arr3,nil];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@user-view/info?uid=%@",ApiUrlHead,_uid];
    NSLog(@"_uid = %@",_uid);
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSDictionary *dic1 = [responseObject objectForKey:@"data"];
            _DataArray = dic1;
            NSString *userImageUrl = [NSString stringWithFormat:@"%@",[ _DataArray objectForKey:@"headpic"]];
            [userImageView setImageURLStr:userImageUrl placeholder:[UIImage imageNamed:@"touxiang2222@2x"]];
            
            
            NSString *userName = [NSString stringWithFormat:@"%@",[ _DataArray objectForKey:@"realname"]];
            userName = [userName stringByRemovingPercentEncoding];
            NSMutableArray*  arr1= [NSMutableArray arrayWithObjects:userName,[NSString stringWithFormat:@"%@",[_DataArray objectForKey:@"sex"]],[NSString stringWithFormat:@"%@",[_DataArray objectForKey:@"area"]], nil];
            
            
            NSMutableArray *arr3 = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@",[ _DataArray objectForKey:@"company_name"]],[NSString stringWithFormat:@"%@",[ _DataArray objectForKey:@"job"]] ,[NSString stringWithFormat:@"%@",[ _DataArray objectForKey:@"trade"]],nil];
            
            
            
            NSString *userName1 = [NSString string];
            if ([[_DataArray objectForKey:@"username"] isKindOfClass:[NSNull class]]) {
                userName1 = @"";
            }else{
                userName1 = [NSString stringWithFormat:@"%@",[_DataArray objectForKey:@"username"]];
            }
            
            NSString *mobile1 = [NSString string];
            if ([[_DataArray objectForKey:@"mobile"] isKindOfClass:[NSNull class]]) {
                mobile1 = @"";
            }else{
                mobile1 = [NSString stringWithFormat:@"%@",[_DataArray objectForKey:@"mobile"]];
            }
            NSString *email1 = [NSString string];
            if ([[_DataArray objectForKey:@"email"] isKindOfClass:[NSNull class]]) {
               email1 = @"";
            }else{
               email1 = [NSString stringWithFormat:@"%@",[_DataArray objectForKey:@"email"]];
             
            }
            NSMutableArray *arr2= [NSMutableArray arrayWithObjects:userName1,mobile1,email1,nil];
            [_mainArray removeAllObjects];
            _mainArray = [NSMutableArray arrayWithObjects:arr1,arr2, arr3,nil];
            NSLog(@"_mainArray = %@",_mainArray);
            [_tableview reloadData];
        }else if (![code isEqualToString:@"0"]){
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];
    
}

- (void)addTableviewHead{
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 130)];
    UIButton*SiXinBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    SiXinBtn.frame=CGRectMake(130, 90, 60, 20);
    [SiXinBtn setImage:[UIImage imageNamed:@"conversation@2x"] forState:UIControlStateNormal];
    [SiXinBtn addTarget:self action:@selector(siXin) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:SiXinBtn];
//    UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(62, (headview.bounds.size.height - 30)*0.5, 30, 30)];
//    leftImage.backgroundColor = [UIColor grayColor];
//    [headview addSubview:leftImage];
//    
//    UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 62 - 30), leftImage.frame.origin.y, 30, 30)];
//    rightImage.backgroundColor = [UIColor grayColor];
//    [headview addSubview:rightImage];
    
    
    UIView *backgroundview = [[UIView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 62)*0.5, (headview.bounds.size.height - 62)*0.5, 62, 62)];
    [headview addSubview:backgroundview];
    userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, 62, 62)];
   
    userImageView.image = [UIImage imageNamed:@"touxiang2222@2x"];
    userImageView.backgroundColor = [UIColor whiteColor];
    userImageView.layer.masksToBounds = YES;
    userImageView.layer.cornerRadius = 4;
    userImageView.clipsToBounds = YES;
    userImageView.contentMode = UIViewContentModeScaleAspectFill;
    userImageView.userInteractionEnabled = YES;
    [userImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserImage1:)]];
    [backgroundview addSubview:userImageView];
    headview.backgroundColor = [UIColor clearColor];
    _tableview.tableHeaderView = headview;
}
-(void)siXin{
    NSLog(@"私信");
    ChatViewController *dingye=[[ChatViewController alloc]init];
    dingye.uid = _uid;
    dingye.token = _token;
    dingye.realname = [NSString stringWithFormat:@"%@",[ _DataArray objectForKey:@"realname"]];
    dingye.user_id = [NSString stringWithFormat:@"%@",[ _DataArray objectForKey:@"user_id"]];
    [self.navigationController pushViewController:dingye animated:YES];
}
- (void)tapUserImage1:(UITapGestureRecognizer *)tap{
    NSMutableArray *imageUrlArray = [NSMutableArray arrayWithObjects:[_DataArray objectForKey:@"headpic"], nil];
    int count = (int)imageUrlArray.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [imageUrlArray objectAtIndex:i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = [tap.view.superview.subviews objectAtIndex:i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc]init];
    browser.currentPhotoIndex = 0; //弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
    
    
}
- (void)initdata{
    NSArray *array1 = [NSArray arrayWithObjects:@"姓名",@"性别",@"地区", nil];
     NSArray *array2 = [NSArray arrayWithObjects:@"账户",@"联系方式",@"邮箱", nil];
     NSArray *array3 = [NSArray arrayWithObjects:@"公司名称",@"职务",@"行业", nil];

      _titleArray = [NSArray arrayWithObjects:array1,
                      array2,
                      array3,

                       nil];
    
    
    NSArray *array11 = [NSArray arrayWithObjects:@"林珊珊",@"女",@"福州", nil];
    NSArray *array12 = [NSArray arrayWithObjects:@"czy2226",@"15677773333",@"1091527668@qq.com", nil];
    NSArray *array13 = [NSArray arrayWithObjects:@"上海海华科技有限公司",@"人事经理",@"机械制造",nil];

    _detailTitleArray = [NSArray arrayWithObjects:array11,
                         array12,
                         array13,
                         nil];
    
    _headTitleArray = [NSArray arrayWithObjects:@"联系方式",
                       @"公司",
                       nil];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array  = [_titleArray objectAtIndex:section];
    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 100, 14)];
        lable.text = [_headTitleArray objectAtIndex:section - 1];
        lable.font = [UIFont systemFontOfSize:11];
        lable.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        [headview addSubview:lable];
        headview.backgroundColor = [UIColor clearColor];
        return headview;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        return 30;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *cellIdentifier1 = @"statusCell3";
    GerenInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (cell == nil) {
        cell = [[GerenInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
    }
    if (indexPath.row == 0) {
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kuangctiao@2x"]];
    }else{
          cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kuangbtiao@2x"]];
    }
    
    if (indexPath.section > 2) {
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1];
    }else if (indexPath.section==0&&indexPath.row==1){
        if ([@"1"isEqualToString:[NSString stringWithFormat:@"%@",[_DataArray objectForKey:@"sex"]]]) {
            NSLog(@"男");
            cell.textLabel.text = [[_titleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            cell.detailTextLabel.text=@"男";
            
        }else{
            NSLog(@"女");
            cell.textLabel.text = [[_titleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            cell.detailTextLabel.text=@"女";
        }
        
    
    }else{
//    if ([cell.detailTextLabel.text  isEqualToString:@"<null>" ]) {
//            cell.detailTextLabel.text=@"";
//        }else{
    cell.textLabel.text = [[_titleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[_mainArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
        }
    

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

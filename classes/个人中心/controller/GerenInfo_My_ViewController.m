//
//  GerenInfo_My_ViewController.m
//  时时投
//
//  Created by 熊良军 on 15/7/27.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "GerenInfo_My_ViewController.h"
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
#import "ZhanghaoBandingViewController.h"
#import "YouxiangBangdingViewController.h"
#import "YouXiangViewController.h"
#import "PhoneBangdingViewController.h"
#import "WBBooksManager.h"
#import "ZHPickView.h"
@interface GerenInfo_My_ViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZHPickViewDelegate>
{
    NSMutableArray * _proArr;//用来存储地区的数据
    NSMutableArray*_jobArr;//用来存储职位的数组
    NSMutableArray*_tradeArr;//用来存储行业的数组
    NSInteger _section;
    NSInteger _row;

    ZHPickView * _myPickerView;
    NSDictionary*_dic;//地区字典
    NSDictionary*_dic2;//职务字典
    NSDictionary*_dic3;//行业字典
}
@property (nonatomic,strong)GerenInfoTableViewCell*mycell;

@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic, strong) STAlertView *stAlertView;
@property (nonatomic ,strong)NSMutableArray *titleArray;
@property (nonatomic ,strong)NSMutableArray *detailTitleArray;
@property (nonatomic ,strong)NSArray *headTitleArray;
@property(nonatomic,strong)NSMutableArray*mainArray;
@end

@implementation GerenInfo_My_ViewController{
    BOOL isPhoto;
    UIImageView *userImageView;
    
    AFHTTPRequestOperationManager *manager;
    NSDictionary * _DataArray;//存储数据
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"个人信息";
        _DataArray=[[NSDictionary alloc]init];
        
        UIImage *backImg = [UIImage imageNamed:@"caidan@2x"];
        MyItemButton *backBtn = [[MyItemButton alloc] initWithFrame:CGRectMake(0.f, 0.f, backImg.size.width/0.6, backImg.size.height/0.6)];
        [backBtn setImage:backImg forState:UIControlStateNormal];
        UIView *backBtnView = [[UIView alloc] initWithFrame:backBtn.bounds];
       backBtnView.bounds = CGRectOffset(backBtnView.bounds, 10, 0);
//        [backBtnView addSubview:backBtn];
//        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
//        self.navigationItem.leftBarButtonItem = backBar;
        
        
        //右边按钮
//        UIImage *backImg1 = [UIImage imageNamed:@"矩形-2@2x(1)"];
//        MyItemButton *backBtn1 = [[MyItemButton alloc] initWithFrame:CGRectMake(0.f, 0.f, backImg1.size.width/0.6, backImg1.size.height/0.6)];
//        [backBtn1 addTarget:self action:@selector(bianJiAction) forControlEvents:UIControlEventTouchUpInside];
//        [backBtn1 setImage:backImg1 forState:UIControlStateNormal];
//        UIView *backBtnView1 = [[UIView alloc] initWithFrame:backBtn1.bounds];
//        //backBtnView1.bounds = CGRectOffset(backBtnView.bounds, -20, 0);
//        [backBtnView1 addSubview:backBtn1];
//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:backBtnView1];
//        self.navigationItem.rightBarButtonItem = rightItem;
        
    }
    return self;
}
-(void)bianJiAction{
    NSLog(@"编辑");
    
}
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    _proArr=[[NSMutableArray alloc]init];
    _jobArr=[[NSMutableArray alloc]init];
    _tradeArr=[[NSMutableArray alloc]init];
    
    NSArray *arr1= [NSArray arrayWithObjects:@"",@"",@"",nil];
      NSArray *arr2= [NSArray arrayWithObjects:@"",@"",@"",nil];
      NSArray *arr3= [NSArray arrayWithObjects:@"",@"",@"",nil];
    _mainArray = [NSMutableArray arrayWithObjects:arr1,arr2, arr3,nil];
   //NSLog(@"_mainArray = %@",_mainArray);
    //读取初始化数据
    NSMutableDictionary * resultDictionary = [[NSMutableDictionary alloc] init];
    [[WBBooksManager sharedInstance] readPlist:&resultDictionary];
    NSDictionary *ArticleDic = [resultDictionary objectForKey:@"Article"];
    NSLog(@"ArticleDic = %@",ArticleDic);
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backgrondview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beijing@2x"]];
    [self.view addSubview:backgrondview];
    [self initdata];
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_tableview];
    
    [self addTableviewHead];
   
    NSString *urlStr = [NSString stringWithFormat:@"%@profile/info?access-token=%@",ApiUrlHead,_token];
    NSLog(@"_token = %@",_token);
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSDictionary *dic1 = [responseObject objectForKey:@"data"];
            _DataArray = dic1;
            NSString *userImageUrl = [_DataArray objectForKey:@"headpic"];
            [userImageView setImageURLStr:userImageUrl placeholder:nil];
            
            NSMutableArray*  arr1= [NSMutableArray arrayWithObjects:[_DataArray objectForKey:@"realname"],[NSString stringWithFormat:@"%@",[_DataArray objectForKey:@"sex"]],[NSString stringWithFormat:@"%@",[_DataArray objectForKey:@"area"]], nil];
            
            NSMutableArray *arr3 = [NSMutableArray arrayWithObjects:[_DataArray objectForKey:@"company_name"],[_DataArray objectForKey:@"job"] ,[_DataArray objectForKey:@"trade"],nil];
            
            NSMutableArray *arr2= [NSMutableArray arrayWithObjects:[_DataArray objectForKey:@"username"],[_DataArray objectForKey:@"mobile"],[_DataArray objectForKey:@"email"],nil];
            [_mainArray removeAllObjects];
            _mainArray = [NSMutableArray arrayWithObjects:arr1,arr2, arr3,nil];
            NSLog(@"_mainArray = %@",_mainArray);
            [_tableview reloadData];
        }else if (![code isEqualToString:@"0"]){
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];
    
    
//    UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
//    
//    [self.view addSubview:picker];

    
    [self getPickerData];
    
    
}

//读取pickview的数据
- (void)getPickerData{
//地区
    NSString *urlStr = [NSString stringWithFormat:@"%@gen/dict?name=province&access-token=%@",ApiUrlHead,_token];
    NSLog(@"_token = %@",_token);
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            _dic = responseObject[@"data"][@"province"];
            NSArray * array = [_dic allKeys];
            for (id num in array) {
                [_proArr addObject:_dic[num]];
            }
            //[_myPickerView show];
            //[_myTableView reloadData];
        }else if (![code isEqualToString:@"0"]){
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];
    
    
    //职务
    NSString *urlStr2 = [NSString stringWithFormat:@"%@gen/dict?name=job&access-token=%@",ApiUrlHead,_token];
    NSLog(@"_token = %@",_token);
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr2 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            _dic2 = responseObject[@"data"][@"job"];
            NSArray * array = [_dic2 allKeys];
            for (id num in array) {
                [_jobArr addObject:_dic2[num]];
            }
            //[_myPickerView show];
            //[_myTableView reloadData];
        }else if (![code isEqualToString:@"0"]){
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];
    
    
    //行业
    NSString *urlStr3 = [NSString stringWithFormat:@"%@gen/dict?name=trade&access-token=%@",ApiUrlHead,_token];
    NSLog(@"_token = %@",_token);
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr3 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            _dic3 = responseObject[@"data"][@"trade"];
            NSArray * array = [_dic3 allKeys];
            for (id num in array) {
                [_tradeArr addObject:_dic3[num]];
            }
            //[_myPickerView show];
            //[_myTableView reloadData];
        }else if (![code isEqualToString:@"0"]){
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];





}
#pragma mark - ZHDelegate

- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    NSLog(@"resultString%@",resultString);
  
    _mainArray[_section][_row]=resultString;
    
    NSLog(@"_dic.count%ld",_dic.count);
    NSArray*arr=[_dic allKeys];
    for (id num in arr) {
        if ([_dic[num] isEqualToString:resultString]) {
            
            NSLog(@"num=%@",num);
      
        
    //上传地区的ID；
   
   NSString* URLStr = [NSString stringWithFormat:@"%@profile/chg-item?k=area_id&v=%@&access-token=%@",ApiUrlHead,num, _token];
            NSLog(@"_token = %@",_token);
            manager = [AFHTTPRequestOperationManager manager];
            [manager GET:URLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"JSON: %@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                if ([code isEqualToString:@"0"]) {
                //responseObject[@"data"][@"area"];
                   // NSLog(@"-----------%@",responseObject[@"data"][@"area"]);
                    
                    [_tableview reloadData];
                }else if (![code isEqualToString:@"0"]){
                    NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"err"]];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:code delegate:nil cancelButtonTitle: @"OK"otherButtonTitles: nil];
                    [alert show];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                
            }];
            
        }}
            
        //上传职务ID
            
                    
            
    NSArray*arr1=[_dic2 allKeys];
    for (id num2 in arr1) {
    if ([_dic2[num2] isEqualToString:resultString]) {
            NSLog(@"num=%@",num2);
            NSString* URLStr2 = [NSString stringWithFormat:@"%@profile/chg-item?k=job_id&v=%@&access-token=%@",ApiUrlHead,num2, _token];
            NSLog(@"_token = %@",_token);
            manager = [AFHTTPRequestOperationManager manager];
            [manager GET:URLStr2 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"JSON: %@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                if ([code isEqualToString:@"0"]) {
                    //responseObject[@"data"][@"area"];
                    // NSLog(@"-----------%@",responseObject[@"data"][@"area"]);
                    
                    [_tableview reloadData];
                }else if (![code isEqualToString:@"0"]){
                    NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"err"]];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:code delegate:nil cancelButtonTitle: @"OK"otherButtonTitles: nil];
                    [alert show];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                
            }];
            
    }}
    
            //上传行业ID
            
            NSArray*arr2=[_dic3 allKeys];
            
            for (id num3 in arr2) {
            if ([_dic3[num3] isEqualToString:resultString]) {
                    NSLog(@"num=%@",num3);
            NSString* URLStr3 = [NSString stringWithFormat:@"%@profile/chg-item?k=trade_id&v=%@&access-token=%@",ApiUrlHead,num3, _token];
            NSLog(@"_token = %@",_token);
            manager = [AFHTTPRequestOperationManager manager];
            [manager GET:URLStr3 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"JSON: %@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                if ([code isEqualToString:@"0"]) {
                    //responseObject[@"data"][@"area"];
                    // NSLog(@"-----------%@",responseObject[@"data"][@"area"]);
                    
                    [_tableview reloadData];
                }else if (![code isEqualToString:@"0"]){
                    NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"err"]];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:code delegate:nil cancelButtonTitle: @"OK"otherButtonTitles: nil];
                    [alert show];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                
            }];
            
            
        }

    
    
    }
    
    
    [_tableview reloadData];
    

}
    

- (void)addTableviewHead{
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 84)];
  
    UIView *backgroundview = [[UIView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 62)*0.5, (headview.bounds.size.height - 62)*0.5, 62, 62)];
    [headview addSubview:backgroundview];
    userImageView = [[UIImageView alloc]initWithFrame:backgroundview.bounds];
   
    userImageView.backgroundColor = [UIColor whiteColor];
    userImageView.layer.masksToBounds = YES;
    userImageView.layer.cornerRadius = 4;
    userImageView.clipsToBounds = YES;
    userImageView.contentMode = UIViewContentModeScaleAspectFill;
    userImageView.userInteractionEnabled = YES;
    [userImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserImage11:)]];
    [backgroundview addSubview:userImageView];
    headview.backgroundColor = [UIColor clearColor];
    _tableview.tableHeaderView = headview;
}
- (void)tapUserImage11:(UITapGestureRecognizer *)tap{
    /*NSMutableArray *imageUrlArray = [NSMutableArray arrayWithObjects:@"http://i3.tietuku.com/926b01c17441d559s.jpg", nil];
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
    [browser show];*/
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
}
- (void)initdata{
    NSArray *array1 = [NSArray arrayWithObjects:@"姓名",@"性别",@"地区", nil];
    NSArray *array2 = [NSArray arrayWithObjects:@"账户",@"手机号码",@"邮箱", nil];
    NSArray *array3 = [NSArray arrayWithObjects:@"公司名称",@"职务",@"行业", nil];

    _titleArray = [NSMutableArray arrayWithObjects:array1,
                   array2,
                   array3,
                   nil];
    
    
    NSArray *array11 = [NSArray arrayWithObjects:@"林珊珊",@"",@"福州", nil];
    NSArray *array12 = [NSArray arrayWithObjects:@"czy2226",@"15677773333",@"1091527668@qq.com", nil];
    NSArray *array13 = [NSArray arrayWithObjects:@"上海海华科技有限公司",@"人事经理",@"机械制造",nil];

    _detailTitleArray = [NSMutableArray arrayWithObjects:array11,
                         array12,
                         array13,

                         nil];
    
    _headTitleArray = [NSArray arrayWithObjects:@"联系方式",
                       @"公司",
                        nil];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
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
    static NSString *cellIdentifier2 = @"statusCell4";
    
    GerenInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    AddMoreTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
   
    if (indexPath.section == 3) {
        if  (cell1 == nil) {
        cell1 = [[AddMoreTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier2];
        }else{
            [cell1 cellReuse];
        }
        
        return cell1;
        
    }else{
        if (cell == nil) {
            cell = [[GerenInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
            
            if (indexPath.section == 0&&indexPath.row == 1) {
                UISegmentedControl *mySegmentedControl1 =[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"女",@"男", nil]];
                mySegmentedControl1.frame = CGRectMake(self.view.bounds.size.width - 90, 5, 80, 20);
                mySegmentedControl1.backgroundColor = [UIColor whiteColor];
                [mySegmentedControl1 setTintColor:[UIColor colorWithRed:0.2667 green:0.6941 blue:0.9059 alpha:1]];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:nil size:10.f],UITextAttributeFont,nil];
                [mySegmentedControl1 setTitleTextAttributes:dic forState:UIControlStateSelected];
                [mySegmentedControl1 setTitleTextAttributes:dic forState:UIControlStateNormal];
                mySegmentedControl1.selectedSegmentIndex = 0;
                
                [cell.contentView addSubview:mySegmentedControl1];
                [mySegmentedControl1 addTarget:self action:@selector(Change:) forControlEvents:UIControlEventValueChanged];
           }
        }else{
            NSArray *subViewArr = cell.contentView.subviews;
            for (UIView *view in subViewArr) {
                [view removeFromSuperview];
            }
            if (indexPath.section == 0&&indexPath.row == 1) {
                
                UISegmentedControl *mySegmentedControl1 =[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"女",@"男", nil]];
                mySegmentedControl1.frame = CGRectMake(self.view.bounds.size.width - 90, 5, 80, 20);
                mySegmentedControl1.backgroundColor = [UIColor whiteColor];
                [mySegmentedControl1 setTintColor:[UIColor colorWithRed:0.2667 green:0.6941 blue:0.9059 alpha:1]];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:nil size:10.f],UITextAttributeFont,nil];
                [mySegmentedControl1 setTitleTextAttributes:dic forState:UIControlStateSelected];
                [mySegmentedControl1 setTitleTextAttributes:dic forState:UIControlStateNormal];
                NSString *sex = [NSString stringWithFormat:@"%@",[_DataArray objectForKey:@"sex"]];
                if ([sex isEqualToString:@"1"]) {
                    mySegmentedControl1.selectedSegmentIndex = 1;
                    
                }else{
                   mySegmentedControl1.selectedSegmentIndex = 0;
                }
                
                
                
                [cell.contentView addSubview:mySegmentedControl1];
                [mySegmentedControl1 addTarget:self action:@selector(Change:) forControlEvents:UIControlEventValueChanged];
                
                
                
            }
            
            
        }
        if (indexPath.row == 0) {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kuangctiao@2x"]];
        }else{
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kuangbtiao@2x"]];
        }
        
        
        if (indexPath.section > 2) {
            cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1];
        }
        cell.textLabel.text = [[_titleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[_mainArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
        
        if (indexPath.section == 0&&indexPath.row == 1) {
            cell.detailTextLabel.text = @"";
        }
        
        return cell;
    }
    
}
- (void)Change:(UISegmentedControl *)segmentedControl{
    NSString *sex1 = [NSString string];
    if (segmentedControl.selectedSegmentIndex == 0) {
        NSLog(@"女");
        sex1 = @"2";
        
    }else if (segmentedControl.selectedSegmentIndex == 1){
        NSLog(@"男");
         sex1 = @"1";
    }
    
    
    NSString*URLStr = [NSString stringWithFormat:@"%@profile/chg-item?k=sex&v=%@&access-token=%@",ApiUrlHead,sex1, _token];
    NSLog(@"URLStr = %@",URLStr);
    NSLog(@"_stAlertView.message=%@",_stAlertView.message);
    
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            
            
            //[_tableview reloadData];
        }else if (![code isEqualToString:@"0"]){
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"err"]];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:code delegate:nil cancelButtonTitle: @"OK"otherButtonTitles: nil];
            [alert show];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0&&indexPath.row == 0) {
        __block NSString *URLStr = [NSString string];
        _stAlertView = [[STAlertView alloc] initWithTitle:@"姓名"
            message:nil textFieldHint:@"请输入姓名" textFieldValue:_mainArray[indexPath.section][indexPath.row] cancelButtonTitle:@"取消"  otherButtonTitles:@"确定"
                cancelButtonBlock:^{
                
                NSLog(@"取消!");
                } otherButtonBlock:^(NSString * result){
                NSLog(@"名称设置成功，名称为：%@", result);
                    
            
            _stAlertView.message = result;
            _mainArray[indexPath.section][indexPath.row]=result;
            
            URLStr = [NSString stringWithFormat:@"%@profile/chg-item?k=realname&v=%@&access-token=%@",ApiUrlHead,_stAlertView.message, _token];
                NSLog(@"_token = %@",_token);
                NSLog(@"_stAlertView.message=%@",_stAlertView.message);
          
           manager = [AFHTTPRequestOperationManager manager];
           [manager GET:URLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                    
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                if ([code isEqualToString:@"0"]) {
                                                        
                                                        
                [_tableview reloadData];
                }else if (![code isEqualToString:@"0"]){
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"err"]];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:code delegate:nil cancelButtonTitle: @"OK"otherButtonTitles: nil];
                        [alert show];
                    
                                                    }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"Error: %@", error);
                                                    
                                                    
                }];
                    
                    
                                                
                    [_detailTitleArray removeAllObjects];
                                                NSArray *array11 = [NSArray arrayWithObjects:result,@"",@"福州", nil];
                                                NSArray *array12 = [NSArray arrayWithObjects:@"czy2226",@"15677773333",@"1091527668@qq.com", nil];
                                                NSArray *array13 = [NSArray arrayWithObjects:@"上海海华科技有限公司",@"人事经理",@"机械制造",@"上海",nil];

                                                [_detailTitleArray addObject:array11];
                                                [_detailTitleArray addObject:array12];
                                                [_detailTitleArray addObject:array13];
                                                
                                                [_tableview reloadData];
                                                
                                            }];
    
    }else if (indexPath.section == 0 && indexPath.row == 2){
        //选择地区
        //_myPickerView.showsSelectionIndicator = YES;
        
        //_proArr = [@[@"地区1",@"地区2",@"地区3"] mutableCopy];
        
        _myPickerView = [[ZHPickView alloc]initPickviewWithArray:_proArr isHaveNavControler:NO];
        _myPickerView.delegate = self;
        [_myPickerView show];
        _section=indexPath.section;
        _row=indexPath.row;
        
       
        
        
    }else if (indexPath.section == 2 && indexPath.row == 1){
        //选择职务
        //_proArr = [@[@"职务1",@"职务2",@"职务3"] mutableCopy];
        _myPickerView = [[ZHPickView alloc]initPickviewWithArray:_jobArr isHaveNavControler:NO];
        _myPickerView.delegate = self;
        [_myPickerView show];
        _section=indexPath.section;
        _row=indexPath.row;
    }else if (indexPath.section == 2 && indexPath.row == 2){
        //选择行业
        //_proArr = [@[@"行业1",@"行业2",@"行业3"] mutableCopy];
        _myPickerView = [[ZHPickView alloc]initPickviewWithArray:_tradeArr isHaveNavControler:NO];
        _myPickerView.delegate = self;
        [_myPickerView show];
        _section=indexPath.section;
        _row=indexPath.row;
        
    }else if (indexPath.section==1&&indexPath.row==0){
        //账号
        ZhanghaoBandingViewController*zhanghao=[[ZhanghaoBandingViewController alloc]init];
        [self.navigationController pushViewController:zhanghao animated:YES];
       
        
    
    }else if (indexPath.section==1&&indexPath.row==1){
        //电话号码
        PhoneBangdingViewController*phone=[[PhoneBangdingViewController alloc]init];
        [self.navigationController pushViewController:phone animated:YES];
        
    }else if (indexPath.section==1&&indexPath.row==2){
        //邮箱
        if ([_mainArray[indexPath.section][indexPath.row] isEqualToString:@""]) {
            YouxiangBangdingViewController*youxiang=[[YouxiangBangdingViewController alloc]init];
            [self.navigationController pushViewController:youxiang animated:YES];
        }else{
            YouXiangViewController * youxiang = [[YouXiangViewController alloc]init];
            [self.navigationController pushViewController:youxiang animated:YES];
        }
        
        

    }if (indexPath.section == 2&&indexPath.row == 0) {
        
        __block NSString *URLStr = [NSString string];
        _stAlertView = [[STAlertView alloc] initWithTitle:@"公司名称"
                                                  message:nil textFieldHint:@"请输入公司名称" textFieldValue:_mainArray[indexPath.section][indexPath.row] cancelButtonTitle:@"取消"  otherButtonTitles:@"确定"
                                        cancelButtonBlock:^{
                                            NSLog(@"取消!");
                                        } otherButtonBlock:^(NSString * result){
                                            NSLog(@"公司名称设置成功，名称为：%@", result);
                                            _stAlertView.message = result;
                                            //让公司名称刷新
                                            _mainArray[indexPath.section][indexPath.row]=result;
                                            
                                            URLStr = [NSString stringWithFormat:@"%@profile/chg-item?k=company_name&v=%@&access-token=%@",ApiUrlHead,_stAlertView.message, _token];
                                            NSLog(@"_token = %@",_token);
                                            NSLog(@"_stAlertView.message=%@",_stAlertView.message);
                                            
                                            manager = [AFHTTPRequestOperationManager manager];
                                            [manager GET:URLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSLog(@"JSON: %@", responseObject);
                                                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                                                if ([code isEqualToString:@"0"]) {
                                                    
                                                    
                                                    [_tableview reloadData];
                                                }else if (![code isEqualToString:@"0"]){
                                                    NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"err"]];
                                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:code delegate:nil cancelButtonTitle: @"OK"otherButtonTitles: nil];
                                                    [alert show];
                                                    
                                                }
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                NSLog(@"Error: %@", error);
                                                
                                                
                                            }];

                                            [_tableview reloadData];
                                            
                                        }];
        
        
    }
    
}


#pragma mark ---- 相机／相册处理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"照相");
        isPhoto = YES;
        [self actionStart];
    }else if (buttonIndex == 1){
        NSLog(@"图片");
        isPhoto = NO;
        [self LocalPhoto];
    }
    
}
//调用摄像头
- (void)actionStart
{
    // UIImagePickerControllerCameraDeviceRear 后置摄像头
    // UIImagePickerControllerCameraDeviceFront 前置摄像头
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera)
    {
        NSLog(@"没有摄像头");
        return ;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    //编辑模式
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:^{
    }];
    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
//判断图片大小用
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/(1024);
    }
    return 0;
}
//照相功能代理方法********************************
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    NSLog(@"图片保存失败");
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (isPhoto)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    NSLog(@"w= %f",image.size.width);
    NSLog(@"h = %f",image.size.height);
    //图片进行压缩
    UIImage *reduceImage = [Reduce_Simple_image reduceImage:image percent:1];
    /****/
    //UIImage *theImage = [Reduce_Simple_image imageWithImageSimple:image scaledToSize:CGSizeMake(120.0, 120.0)];
    //UIImage *midImage = [Reduce_Simple_image imageWithImageSimple:image scaledToSize:CGSizeMake(210.0, 210.0)];
    UIImage *bigImage = [Reduce_Simple_image imageWithImageSimple:reduceImage scaledToSize:CGSizeMake(100.0, 100.0)];
    
    NSData *bigImageData = UIImageJPEGRepresentation(bigImage, 1);
    NSString *sizeStr = [NSByteCountFormatter stringFromByteCount:bigImageData.length countStyle:NSByteCountFormatterCountStyleBinary];
    NSLog(@"%@", sizeStr);
    
    float f = (float)bigImageData.length/1024.0f;
    NSLog(@"f = %f",f);
    while (f > 200) {
        UIImage *cutImageSmall = [UIImage imageWithData:bigImageData];
        bigImageData = UIImageJPEGRepresentation(cutImageSmall, 0.99);
        f = (float)bigImageData.length/1024.0f;
        NSLog(@"f = %f",f);
    }
   
    
    NSString *urlStr = [NSString stringWithFormat:@"%@profile/set-head?access-token=%@",ApiUrlHead,_token];
    AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
    NSLog(@"bigImageData = %@",bigImageData);
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:bigImageData,@"pcode", nil];
    [manager1 POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON2: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            userImageView.image = image;
            
            
        }else if (![code isEqualToString:@"0"]){
            NSString *error = [responseObject objectForKey:@"err"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
      
    }];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)upLoadSalesBigImage:(NSString *)bigImage MidImage:(NSString *)midImage SmallImage:(NSString *)smallImage
{
    //[uploadImageRequest setPostValue:@"photo" forKey:@"type"];
    //[uploadImageRequest startAsynchronous];
}
/****************************/
//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];
}
//当选择一张图片后进入这里
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissModalViewControllerAnimated:YES];
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

//
//  GerenInfoViewController.m
//  时时投
//
//  Created by 熊良军 on 15/7/27.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "GerenInfoViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+MJWebCache.h"
#import "GerenInfoTableViewCell.h"
@interface GerenInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic ,strong)NSArray *titleArray;
@property (nonatomic ,strong)NSArray *detailTitleArray;
@property (nonatomic ,strong)NSArray *headTitleArray;
@end

@implementation GerenInfoViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"他的个人信息";
        /*UIButton *lestButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lestButton setImage:[UIImage imageNamed:@"fanhuix@2x"] forState:UIControlStateNormal];
        [lestButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:lestButton];
        self.navigationItem.leftBarButtonItem = leftItem;*/
        
    }
    return self;
}
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
    // Do any additional setup after loading the view.
}
- (void)addTableviewHead{
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 84)];
    UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(62, (headview.bounds.size.height - 30)*0.5, 30, 30)];
    leftImage.backgroundColor = [UIColor grayColor];
    [headview addSubview:leftImage];
    
    UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 62 - 30), leftImage.frame.origin.y, 30, 30)];
    rightImage.backgroundColor = [UIColor grayColor];
    [headview addSubview:rightImage];
    
    UIView *backgroundview = [[UIView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 62)*0.5, (headview.bounds.size.height - 62)*0.5, 62, 62)];
    [headview addSubview:backgroundview];
    UIImageView *userImageView = [[UIImageView alloc]initWithFrame:backgroundview.bounds];
    [userImageView setImageURLStr:@"http://i3.tietuku.com/926b01c17441d559s.jpg" placeholder:nil];
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
- (void)tapUserImage1:(UITapGestureRecognizer *)tap{
    NSMutableArray *imageUrlArray = [NSMutableArray arrayWithObjects:@"http://i3.tietuku.com/926b01c17441d559s.jpg", nil];
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
     NSArray *array3 = [NSArray arrayWithObjects:@"公司名称",@"职务",@"行业",@"地区", nil];
     NSArray *array4 = [NSArray arrayWithObjects:@"1988年－1995年   北京祥和文化传播有限公司",
                        @"1996年－2000年   上海大易集团",
                        @"2000年－2015年   瑞新人事事务所",nil];
     NSArray *array5 = [NSArray arrayWithObjects:@"1978年－1981年   北京人大附中",
                        @"1981年－1985年   北京大学",
                        @"1985年－1988年   北京大学",
                        @"1988年－1991年   北京大学", nil];
     NSArray *array6 = [NSArray arrayWithObjects:@"组织",@"兴趣爱好",@"奖励荣誉",nil];
      _titleArray = [NSArray arrayWithObjects:array1,
                      array2,
                      array3,
                      array4,
                      array5,
                      array6,
                       nil];
    
    
    NSArray *array11 = [NSArray arrayWithObjects:@"林珊珊",@"女",@"福州", nil];
    NSArray *array12 = [NSArray arrayWithObjects:@"czy2226",@"15677773333",@"1091527668@qq.com", nil];
    NSArray *array13 = [NSArray arrayWithObjects:@"上海海华科技有限公司",@"人事经理",@"机械制造",@"上海",nil];
    NSArray *array14 = [NSArray arrayWithObjects:@"项目经理",@"行政经理",@"CEO",nil];
    NSArray *array15 = [NSArray arrayWithObjects:@"高中",@"新闻专业   本科",@"新闻专业   硕士",@"新闻专业   博士", nil];
    NSArray *array16 = [NSArray arrayWithObjects:@"",@"",@"",nil];
    _detailTitleArray = [NSArray arrayWithObjects:array11,
                         array12,
                         array13,
                         array14,
                         array15,
                         array16,
                         nil];
    
    _headTitleArray = [NSArray arrayWithObjects:@"联系方式",
                       @"公司",
                       @"个人经历",
                       @"教育经历",
                       @"其他信息", nil];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
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
    }
    cell.textLabel.text = [[_titleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [[_detailTitleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    return cell;
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

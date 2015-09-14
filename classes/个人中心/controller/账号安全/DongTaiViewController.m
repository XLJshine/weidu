//
//  DongTaiViewController.m
//  时时投
//
//  Created by h on 15/8/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "DongTaiViewController.h"
#import "DongTaiTableViewCell.h"
#import "DongTaiModel.h"
static DongTaiViewController *instance;
@interface DongTaiViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIImageView *boliImgView;
    NSMutableArray * _dataArr;
    NSMutableArray * _heightArr;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic)__block NSMutableArray *DataArray;
@property(strong,nonatomic)NSArray*KeysArr;
@end

@implementation DongTaiViewController{
      AFHTTPRequestOperationManager *manager;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"我的动态";
        
        
        
    }
    return self;
}
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [MobClick endLogPageView:@"DongTaiViewController"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DongTaiViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _KeysArr=[[NSArray alloc]init];
    
    _myTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    [_myTableView registerNib:[UINib nibWithNibName:@"DongTaiTableViewCell" bundle:nil] forCellReuseIdentifier:@"dongtaicell"];
    
   
    
    NSString *urlStr = [NSString stringWithFormat:@"%@profile/action?access-token=%@",ApiUrlHead,_token];
    NSLog(@"=============_token = %@",_token);
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
       // NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        UIImageView*showImage = [[UIImageView alloc]init];
        if (self.view.bounds.size.height>500) {
            //如果没有动态，就出现这个图片。
            showImage.image = [UIImage imageNamed:@"我的动态5S@2X"];
           
            showImage.frame=self.view.frame;
            [self.view addSubview:showImage];
        }else{
            //如果没有动态，就出现这个图片。
            showImage.image = [UIImage imageNamed:@"我的动态"];
            
            showImage.frame=self.view.frame;
            [self.view addSubview:showImage];
        
        
        
        }
      
       boliImgView.hidden = YES;

        if ([code isEqualToString:@"0"]) {
              _DataArray = [responseObject objectForKey:@"data"];
            //showView.backgroundColor = [UIColor clearColor];
            //showView.userInteractionEnabled = YES;
            if (_DataArray.count > 0) {
                [showImage removeFromSuperview];
            }
            [self createData];
            
            [_myTableView reloadData];
        }else if (![code isEqualToString:@"0"]){
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];
    
    
}
-(void)createData{
    _heightArr = [NSMutableArray array];

    for (int i = 0; i<_DataArray.count; i++) {
//        DongTaiModel * model = [[DongTaiModel alloc]init];
//        model.timeStr = _DataArray[i][@"time"];
//        model.xinxiStr = _DataArray[i][@"title"];
        CGFloat height = [_DataArray[i][@"title"] sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(210, 1000)].height;
        [_heightArr addObject:[NSNumber numberWithFloat:height]];
        //[_dataArr addObject:model];
    }
    //NSLog(@"%ld",_heightArr.count);
    [self.myTableView reloadData];
}
#pragma mark- tableview


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _DataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DongTaiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"dongtaicell"];
//    DongTaiModel * model = _dataArr[indexPath.row];
    NSNumber * num = _heightArr[indexPath.row];
    
//    cell.timeLabel.text = model.timeStr;
    
    NSArray * array = cell.subviews;
    for (UIView * test in array) {
        if ([test isKindOfClass:[UILabel class]] && test.frame.size.width > 200) {
            [test removeFromSuperview];
        }
    }
    
    UILabel * xinxiLabel = [[UILabel alloc]initWithFrame:CGRectMake(83, 14, 222, [num floatValue])];
    xinxiLabel.numberOfLines = 0;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 10;//缩进
    style.firstLineHeadIndent = 10;
    //style.lineSpacing = 10;//行距
    NSMutableAttributedString * AString = [[NSMutableAttributedString  alloc]initWithString:_DataArray[indexPath.row][@"title"]];
    [AString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, AString.length)];
    xinxiLabel.attributedText = AString;
    xinxiLabel.font = [UIFont systemFontOfSize:13];
    xinxiLabel.backgroundColor = [UIColor whiteColor];
    //xinxiLabel.text=_DataArray[indexPath.row][@"title"];
    
    [cell addSubview:xinxiLabel];
    NSString * str = _DataArray[indexPath.row][@"time"];
    NSArray * timeArr = [str componentsSeparatedByString:@" "];
    cell.timeLabel.text = [timeArr lastObject];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"_heightArr.COUNT = %lu",(unsigned long)_heightArr.count);
    NSNumber * number = _heightArr[indexPath.row];
    // NSLog(@"[number floatValue]+20==%f",[number floatValue]+20);
    return [number floatValue]+30;
    //return 30;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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

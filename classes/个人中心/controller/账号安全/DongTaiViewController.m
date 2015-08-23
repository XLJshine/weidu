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

@interface DongTaiViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * _dataArr;
    NSMutableArray * _heightArr;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation DongTaiViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"我的动态";
        
        
        
    }
    return self;
}
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [_myTableView registerNib:[UINib nibWithNibName:@"DongTaiTableViewCell" bundle:nil] forCellReuseIdentifier:@"dongtaicell"];
    
    [self createData];
}
-(void)createData{
    _heightArr = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    NSArray * timeArr = @[@"刚刚",@"14:30",@"14:30"];
    NSArray * xinxiArr = @[@"徐曦腕请求添加您为好友",@"你已经添加林淑芬为好友，你们现在可以进行通话",@"你分享了《甘肃烟草工业有限责任公司精品“兰州”烟卷专用生产线技术改造项目旧联台》到朋友圈"];
    for (int i = 0; i<timeArr.count*4; i++) {
        DongTaiModel * model = [[DongTaiModel alloc]init];
        model.timeStr = timeArr[i%3];
        model.xinxiStr = xinxiArr[i%3];
        NSString * xinxi = xinxiArr[i%3];
        
        CGFloat height = [xinxi sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(210, 1000)].height;
        [_heightArr addObject:[NSNumber numberWithFloat:height]];
        [_dataArr addObject:model];
    }
    [self.myTableView reloadData];
}
#pragma mark- tableview


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DongTaiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"dongtaicell"];
    DongTaiModel * model = _dataArr[indexPath.row];
    NSNumber * num = _heightArr[indexPath.row];
    
    cell.timeLabel.text = model.timeStr;
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
    NSMutableAttributedString * AString = [[NSMutableAttributedString  alloc]initWithString:model.xinxiStr];
    [AString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, AString.length)];
    xinxiLabel.attributedText = AString;
    xinxiLabel.font = [UIFont systemFontOfSize:11];
    xinxiLabel.backgroundColor = [UIColor whiteColor];
    
//    UILabel * xinxiLabel = [[UILabel alloc]initWithFrame:CGRectMake(83, 14, 222, [num floatValue])];
//    xinxiLabel.numberOfLines = 0;
//    xinxiLabel.text = model.xinxiStr;
//    xinxiLabel.font = [UIFont systemFontOfSize:11];
//    xinxiLabel.backgroundColor = [UIColor whiteColor];
    [cell addSubview:xinxiLabel];
    
//    cell.xinxiLable.frame = CGRectMake(8, 0, 210, 200);
//    cell.xinxiLable.backgroundColor = [UIColor redColor];
//    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(78, 8, 228, [num floatValue]+10)];
//    imageView.image = [UIImage imageNamed:@"圆角矩形-5@2x_1.png"];
//    [cell addSubview:imageView];
//    cell.model = model;
//    cell.timeLabel.text = model.timeStr;
//    _xinxiImageView.frame = CGRectMake(78,8,228, _model.xinxiImageViewHeight);

    //cell.model = model;
//    cell.timeLabel.text = model.timeStr;
//    cell.xinxiLable.text = model.xinxiStr;
//    CGFloat xinxiLableHeight = [model.xinxiStr sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(210, MAXFLOAT)].height;
//    cell.xinxiLable.frame = CGRectMake(89, 13, 210, xinxiLableHeight);
//    CGRect rect = cell.frame;
//    rect.size.height = xinxiLableHeight+20;
//    cell.frame = rect;

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        NSNumber * number = _heightArr[indexPath.row];
        NSLog(@"[number floatValue]+20==%f",[number floatValue]+20);
        return [number floatValue]+30;
//    DongTaiModel * model = _dataArr[indexPath.row];
//    //NSLog(@"model.xinxiImageViewHeight+20==%f",model.xinxiImageViewHeight+20);
//    NSLog(@"model.xinxiImageViewHeight==%f",model.xinxiImageViewHeight);
//    return model.xinxiImageViewHeight+200;
//    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
    
    
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

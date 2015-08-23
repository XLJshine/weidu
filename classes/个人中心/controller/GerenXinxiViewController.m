//
//  GerenXinxiViewController.m
//  时时投
//
//  Created by h on 15/7/22.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "GerenXinxiViewController.h"
#import "UIImageView+MJWebCache.h"
#import "GeRenTableViewCell.h"
#import "HeadTableView.h"
#import "FootTabelView.h"
#import "ShezhiViewController.h"
#import "FangkeViewController.h"
#import "JiFenViewController.h"
#import "GerenInfo_My_ViewController.h"
#import "BiaoqianView.h"
#import "MyNavigationController.h"
#import "GongsiViewController.h"
@interface GerenXinxiViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _imgArr;
    NSArray * _higlightArr;
}
@property (weak, nonatomic) IBOutlet UITableView *myTabelView;
@property (strong, nonatomic)HeadTableView * header;
@property (strong, nonatomic)FootTabelView * foot;
@end

@implementation GerenXinxiViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _imgArr = [[NSArray alloc]initWithObjects:@"dongtaibb1@2x",@"kehub@2x",@"jifenl@2x",@"xiangmub@2x",@"shezhib@2x", nil];
        _higlightArr = [[NSArray alloc]initWithObjects:@"dongtail@2x",@"kehul@2x",@"jifenll@2x",@"xiangmul@2x",@"shezhil@2x", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _myTabelView.dataSource = self;
    _myTabelView.delegate = self;
    [self.myTabelView registerNib:[UINib nibWithNibName:@"GeRenTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _header = [[NSBundle mainBundle] loadNibNamed:@"HeadTableView" owner:self options:0][0];
    _header.userHeadImage.clipsToBounds = YES;
    _header.userHeadImage.contentMode = UIViewContentModeScaleAspectFill;
    [_header.userHeadImage setImageURLStr:@"http://i3.tietuku.com/926b01c17441d559s.jpg" placeholder:nil];
    _header.userHeadImage.layer.masksToBounds = YES;
    _header.userHeadImage.layer.cornerRadius = 4;
    _header.userHeadImage.userInteractionEnabled = YES;
    [_header.userHeadImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserImage:)]];
    _header.toJianjie.userInteractionEnabled = YES;
     [_header.toJianjie addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toJianjie)]];
    //BiaoqianView
    NSArray *lableArray = [NSArray arrayWithObjects:@"有内涵",
                           @"大美女",
                           @"有爱人士",
                           @"美食家",
                           @"古典美",nil];
    NSArray *btnArray = [NSArray arrayWithObjects:@"8",
                           @"7",
                           @"7",
                           @"5",
                           @"2",nil];
    for (int i = 0; i < 6; i ++) {
        int x = i%3;
        int y = i/3;
        int distance = 10;
        if ( i < 5) {
            BiaoqianView *biaoqian = [[BiaoqianView alloc]initWithFrame:CGRectMake(distance + ((self.view.bounds.size.width - distance * 4)*0.333 + distance)* x, 200 + (25 + distance)*y , (self.view.bounds.size.width - distance * 4)*0.333, 25) title:[lableArray objectAtIndex:i] btnTitle:[btnArray objectAtIndex:i] viewtag:i BlockButton:^(int index,NSString *btnTitle){
                NSLog(@"index = %i",index);
               
                
                
            }];
            
            [_header addSubview:biaoqian];
        }else{
            UIButton *moreButton = [[UIButton alloc]initWithFrame:CGRectMake(distance + ((self.view.bounds.size.width - distance * 4)*0.333 + distance)* x, 200 + (25 + distance)*y , 30, 25)];
            [moreButton setTitle:@"更多" forState:UIControlStateNormal];
            [moreButton setTitle:@"收起" forState:UIControlStateSelected];
            [moreButton setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
            moreButton.titleLabel.font = [UIFont systemFontOfSize:11];
            [moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
            [_header addSubview:moreButton];
        }
    }
    _foot = [[NSBundle mainBundle] loadNibNamed:@"FootTabelView" owner:self options:0][0];
    _myTabelView.tableHeaderView.backgroundColor = [UIColor clearColor];
    _myTabelView.tableFooterView.userInteractionEnabled = YES;
    _myTabelView.tableHeaderView.userInteractionEnabled = YES;
    _myTabelView.tableHeaderView = _header;
    _myTabelView.tableFooterView = _foot;
    UIImageView * bgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.myTabelView.frame.size.width, self.myTabelView.frame.size.height)];
    _myTabelView.backgroundView = bgV;
    
}
- (void)toJianjie{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"gongsi" userInfo:nil];}
- (void)tapUserImage:(UITapGestureRecognizer *)tap{
     [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"mycenter" userInfo:nil];
}
- (void)moreAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    int i = 5;
    int x = i%3;
    int y = i/3;
    int distance = 10;
    
    if (btn.selected) {
        [UIView animateWithDuration:0.25 animations:^{ btn.frame = CGRectMake(distance + ((self.view.bounds.size.width - distance * 4)*0.333 + distance)* x  - 30, 200 + (25 + distance)*y + (440 - 274), 30, 25);
            _header.frame = CGRectMake(0, 0, self.view.bounds.size.width, 440);
            _myTabelView.tableHeaderView = _header;
            _myTabelView.tableFooterView = nil;
            _myTabelView.tableFooterView = _foot;} completion:nil];
    }else{
        [UIView animateWithDuration:0.25 animations:^{  btn.frame = CGRectMake(distance + ((self.view.bounds.size.width - distance * 4)*0.333 + distance)* x  - 30, 200 + (25 + distance)*y , 30, 25);
            _header.frame = CGRectMake(0, 0, self.view.bounds.size.width, 274);
            _myTabelView.tableHeaderView = _header;
            _myTabelView.tableFooterView = nil;
            _myTabelView.tableFooterView = _foot;} completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITabelView
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 30;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 100;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",_imgArr.count);
    return _imgArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GeRenTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:cell.contentView.bounds];
    [cell.contentView addSubview:btn];
    //cell.headImage.image = [UIImage imageNamed:_imgArr[indexPath.row]];
    //cell.headTitle.text = _nameArr[indexPath.row];
    btn.tag = indexPath.row;
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setBackgroundImage:[UIImage imageNamed:[_imgArr objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    //[cell.caidanButton setImage: forState:];
    [btn setBackgroundImage:[UIImage imageNamed:[_higlightArr objectAtIndex:indexPath.row]] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(caidanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)caidanButtonAction:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
        {
            NSLog(@"0");
           
            
        }
            break;
        case 1:
        {
            NSLog(@"1");
          
             [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"fangke" userInfo:nil];
        }
            break;
        case 2:
        {
            NSLog(@"2");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"jifen" userInfo:nil];
        }
            break;
        case 3:
        {
            NSLog(@"3");
        }
            break;
        case 4:
        {
            NSLog(@"4");
            //设置
            [[NSNotificationCenter defaultCenter]postNotificationName:@"myCenterPush" object:@"shezhi" userInfo:nil];
        }
            break;
            
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 28;
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    FootTabelView * foot = [[NSBundle mainBundle] loadNibNamed:@"FootTabelView" owner:self options:0][0];
//    return foot;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    HeadTableView * header = [[NSBundle mainBundle] loadNibNamed:@"HeadTableView" owner:self options:0][0];
//    return header;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

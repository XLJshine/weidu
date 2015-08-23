//
//  ShowWaysViewController.m
//  时时投
//
//  Created by 熊良军 on 15/7/23.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "ShowWaysViewController.h"
#import "ZhanghaoSafeTableViewCell.h"
#import "TiaotianBeijingViewController.h"
#import "WBBooksManager.h"
@interface ShowWaysViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic ,strong)NSArray *titleArray;
@property (nonatomic ,strong)NSArray *backgroundImageArray;
@property (nonatomic ,assign)int sliderValue;
@property (nonatomic ,strong)NSString * sliderValueStr;

@end

@implementation ShowWaysViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"显示方式";
        
       /* UIButton *lestButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
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
    NSDictionary *mimaSafeDic = [resultDictionary objectForKey:@"sliderValue"];
    NSLog(@"mimaSafeDic = %@",mimaSafeDic);
    _sliderValueStr = [mimaSafeDic objectForKey:@"sliderValue"];
    _sliderValue = [[mimaSafeDic objectForKey:@"sliderValue"] intValue];
    
}
- (void)data{
    _titleArray = [NSArray arrayWithObjects:@"字体大小",
                   @"聊天背景",
                   nil];
    
    _backgroundImageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"chaangtiao1@2x"],[UIImage imageNamed:@"chaangtiao3@2x"], nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 2;
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
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 1) {
        UIImageView *arrawImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 42, 19, 12, 12)];
        [arrawImage setImage:[UIImage imageNamed:@"fangRight@2x"]];
        [cell.contentView addSubview:arrawImage];
        
    }else{
      
        UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(135, 5, 150, 40)];
        [cell.contentView addSubview:slider];
        slider.maximumValue = 2;
        slider.minimumValue = 0;
        NSLog(@"_sliderValue = %i",_sliderValue);
        slider.value = _sliderValue;
        slider.minimumTrackTintColor = [UIColor greenColor];
        [slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
        //[slider setThumbImage:[UIImage imageNamed:@"qq@2x"] forState:UIControlStateNormal];
    }
    
    return cell;
}
- (void)updateValue:(UISlider *)slider{
    float f = slider.value; //读取滑块的值
    NSLog(@"f = %.f",f);
    if (f>0&&f<0.66) {
        _sliderValue = 0;
    }else if (f>=0.66&&f<1.33){
        _sliderValue = 1;
    }else if(f>=1.33&&f<2){
        _sliderValue = 2;
    }
    _sliderValueStr = [NSString stringWithFormat:@"%i",_sliderValue];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    [userDic setValue:_sliderValueStr forKey:@"sliderValue"];
    NSLog(@"==%@",_sliderValueStr);
    //判断给出的Key对应的数据是否存在
    if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"sliderValue"]) {
        //存在，则替换之
        NSLog(@"存在，则替换之");
        [[WBBooksManager sharedInstance] replaceDictionary:userDic withDictionaryKey:@"sliderValue"];
    }else{//不存在，则写入
        NSLog(@"不存在，则写入");
        [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"sliderValue"];
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        TiaotianBeijingViewController *TVC = [[TiaotianBeijingViewController alloc]init];
        [self.navigationController pushViewController:TVC animated:YES];
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

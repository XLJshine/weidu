//
//  PhoneViewController.m
//  时时投
//
//  Created by h on 15/7/23.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "PhoneViewController.h"
#import "ExchangePhoneNumViewController.h"
#import "jieChuBangDinShouJiViewController.h"
@interface PhoneViewController ()

@end

@implementation PhoneViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"绑定手机号";
        
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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PhoneViewController"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PhoneViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _phoneNumLable.text = [NSString stringWithFormat:@"你的手机号：%@",_phoneNum];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)exchangNum:(id)sender {
    ExchangePhoneNumViewController*exchange=[[ExchangePhoneNumViewController alloc]init];
    exchange.phoneNum = _phoneNum;
    exchange.token = _token;
    exchange.uid = _uid;
    [self.navigationController pushViewController:exchange animated:YES];
}
- (IBAction)jieBangPhoneBtn:(id)sender {
    
}

- (IBAction)jjieChuBangDingShouJIHao:(id)sender {
    jieChuBangDinShouJiViewController*JCSJ=[[jieChuBangDinShouJiViewController alloc]init];
    JCSJ.phoneNum = _phoneNum;
    JCSJ.token = _token;
    JCSJ.uid = _uid;
    [self.navigationController pushViewController:JCSJ animated:YES];
    
}
@end

//
//  YouXiangViewController.m
//  时时投
//
//  Created by h on 15/8/8.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "YouXiangViewController.h"
#import "MailJieBang_ViewController.h"
#import "JieChuBangDingYXViewController.h"
@interface YouXiangViewController ()

@end

@implementation YouXiangViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"邮箱";
        
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
    [MobClick endLogPageView:@"YouxiangViewController"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"YouxiangViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _youxiangLable.text = [NSString stringWithFormat:@"您当前邮箱:%@",_youxiangNum];
    
    
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

- (IBAction)jiechuBangding:(id)sender {
    JieChuBangDingYXViewController*JVC=[[JieChuBangDingYXViewController alloc]init];
    JVC.token=_token;
    JVC.uid=_uid;
    JVC.youxiangNum =_youxiangNum;
    NSLog(@"YOUXIANG.youxiangNum===============%@",JVC.youxiangNum);
    [self.navigationController pushViewController:JVC animated:YES];
    
}

- (IBAction)xiuGaiBangdIng:(id)sender {
    MailJieBang_ViewController *MVC = [[MailJieBang_ViewController alloc]init];
    MVC.token = _token;
    MVC.uid = _uid;
    [self.navigationController pushViewController:MVC animated:YES];
}
@end

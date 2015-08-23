//
//  RenmaiViewController.m
//  时时投
//
//  Created by 熊良军 on 15/7/20.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "RenmaiViewController.h"
#import "RemaiButton.h"
#import "AppDelegate.h"
#import "TongxunluViewController.h"
static RenmaiViewController *instance;
@interface RenmaiViewController ()

@end

@implementation RenmaiViewController
+ (id)shareInstance
{
    if (instance == nil)
    {
        instance = [[[self class]alloc]init];
    }
    return instance;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        //自定义tabbar
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"人脉" image:[UIImage imageNamed:@"renmai@2x"] selectedImage:[UIImage imageNamed:@"renmai1@2x"]];
        
        self.navigationItem.title = @"人脉";
        UIButton *lestButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lestButton setImage:[UIImage imageNamed:@"caidan@2x"] forState:UIControlStateNormal];
        [lestButton addTarget:self action:@selector(push1) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:lestButton];
        
        self.navigationItem.leftBarButtonItem = leftItem;
        
        //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"caidan@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(push1)];
        
        UIButton *Button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [Button setImage:[UIImage imageNamed:@"tianjia@2x"] forState:UIControlStateNormal];
        [Button addTarget:self action:@selector(push2) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:Button];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    return self;
}
-(void)push1{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController = [delegate siderViewController];
    [sideViewController showLeftViewController:YES];
    
    //显示主界面半透明视图
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewAppear" object:nil userInfo:nil];
}

-(void)push2{
    TongxunluViewController *TVC = [[TongxunluViewController alloc]init];
    [self.navigationController pushViewController:TVC animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人脉";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9484 alpha:1];
    // Do any additional setup after loading the view.
    NSArray *titleArray = [NSArray arrayWithObjects:@"管理一度人脉",@"发现二度人脉",@"最新活动",@"影响力排行榜",nil];
    NSArray *imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"yidu@2x"],[UIImage imageNamed:@"erdu@2x"],[UIImage imageNamed:@"huodon@2x"],[UIImage imageNamed:@"fenxiang@2x"],nil];
    for (int i = 0; i < 4; i ++) {
        int x = i%2;  //0,1,0,1
        int y = i/2;  //0,0,1,1
        RemaiButton *rBtn = [[RemaiButton alloc]initWithFrame:CGRectMake(10 + ((self.view.bounds.size.width - 30)*0.5 + 10) * x , 10 + ((self.view.bounds.size.width - 30)*0.5 + 10) * y , (self.view.bounds.size.width - 30)*0.5, (self.view.bounds.size.width - 30)*0.5)
                                                  normalimage:[imageArray objectAtIndex:i]
                                                       hImage:nil
                                                       SImage:nil];
        rBtn.layer.masksToBounds = YES;
        rBtn.layer.cornerRadius = 3;
        rBtn.backgroundColor = [UIColor whiteColor];
        [rBtn setTitleColor:[UIColor colorWithRed:0.2745 green:0.6588 blue:0.8471 alpha:1] forState:UIControlStateNormal];
        [rBtn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        rBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        rBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        rBtn.tag = i;
        [rBtn addTarget:self action:@selector(renmaiAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rBtn];
    }
    
    
    
}
- (void)renmaiAction:(RemaiButton *)btn{
    switch (btn.tag) {
        case 0:
        {
            NSLog(@"1");
        }
            break;
        case 1:
        {
            NSLog(@"2");
        }
            break;
        case 2:
        {
            NSLog(@"3");
        }
            break;
        case 3:
        {
            NSLog(@"4");
        }
            break;
        default:
            break;
    }


}
/*- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideDock" object:nil userInfo:nil];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Dock" object:nil userInfo:nil];
}*/
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

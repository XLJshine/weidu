//
//  MiMaViewController.m
//  时时投
//
//  Created by h on 15/7/24.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "MiMaViewController.h"
#import "WBBooksManager.h"
@interface MiMaViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *mimaSwitch;

@end

@implementation MiMaViewController{
    NSString *mimaSafe;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"密码保护";
        
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
    [MobClick endLogPageView:@"MimaViewController"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MimaViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self readBook];
   
    if ([mimaSafe isEqualToString:@"1"]) {
        _mimaSwitch.on = YES;
    }else if ([mimaSafe isEqualToString:@"0"]){
        _mimaSwitch.on = NO;
    }
    [_mimaSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    _mimaSwitch.backgroundColor = [UIColor clearColor];
   
    // Do any additional setup after loading the view from its nib.
}
- (void)readBook{
    NSMutableDictionary * resultDictionary = [[NSMutableDictionary alloc] init];
    [[WBBooksManager sharedInstance] readPlist:&resultDictionary];
    NSDictionary *mimaSafeDic = [resultDictionary objectForKey:@"mimaSafe"];
    mimaSafe = [mimaSafeDic objectForKey:@"mimaSafe"];
    if (mimaSafe.length == 0) {
        mimaSafe = @"0";
    }
}

- (void)switchAction:(UISwitch *)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    if (isButtonOn){
        NSLog(@"打开1");
        [userDic setValue:@"1" forKey:@"mimaSafe"];
    }else{
        NSLog(@"关闭1");
        [userDic setValue:@"0" forKey:@"mimaSafe"];
    }
    //判断给出的Key对应的数据是否存在
    if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"mimaSafe"]) {
        //存在，则替换之
        NSLog(@"存在，则替换之");
        [[WBBooksManager sharedInstance] replaceDictionary:userDic withDictionaryKey:@"mimaSafe"];
    }else{//不存在，则写入
        NSLog(@"不存在，则写入");
        [[WBBooksManager sharedInstance] writePlist:userDic forKey:@"mimaSafe"];
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

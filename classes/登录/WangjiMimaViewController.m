//
//  WangjiMimaViewController.m
//  时时投
//
//  Created by h on 15/8/11.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "WangjiMimaViewController.h"

@interface WangjiMimaViewController ()

@end

@implementation WangjiMimaViewController{
    NSInteger t;
    NSTimer*_myTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"找回密码";
    _phoneNumber.delegate=self;
    _NewMima.delegate=self;
    _NewMimaAgain.delegate=self;
    _YanZhengMa.delegate=self;
    
    //_huoqueButton验证码的获取，时间倒计时
    [_HuoQuYanZhengMa addTarget:self action:@selector(Jishi) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)Jishi{
    t = 60;
    _myTimer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(action) userInfo:nil repeats:YES];
}
- (void)action{
    t --;
    [_HuoQuYanZhengMa setTitle:[NSString stringWithFormat:@"%lds",(long)t] forState:UIControlStateNormal];
    
    if (t <=0) {
        
        if ([_myTimer isValid]) {
            [_myTimer invalidate];
        }
        [_HuoQuYanZhengMa setTitle:@"重发验证码" forState:UIControlStateNormal];
        _HuoQuYanZhengMa.enabled=YES;
        [_HuoQuYanZhengMa addTarget:self action:@selector(Chongfa) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    
}
-(void)Chongfa{
    // [_huoqueButton setTitle:@"重发验证码" forState:UIControlStateNormal];
    
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)HuoQuYanZhengMa:(id)sender {
    NSLog(@"获取验证码");
}
- (IBAction)TiJiao:(id)sender {
    NSLog(@"提交");
}
@end

//
//  ZhanghaoBandingViewController.m
//  时时投
//
//  Created by h on 15/8/12.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "ZhanghaoBandingViewController.h"
#import "AFNetworking.h"
@interface ZhanghaoBandingViewController ()

@end

@implementation ZhanghaoBandingViewController{

    NSInteger t;
    NSTimer*_myTimer;
    
    AFHTTPRequestOperationManager *manager;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
       
        
        /*UIButton *lestButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
         [lestButton setImage:[UIImage imageNamed:@"fanhuix@2x"] forState:UIControlStateNormal];
         [lestButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
         UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:lestButton];
         self.navigationItem.leftBarButtonItem = leftItem;*/
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ZhanghaoBangdingViewController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ZhanghaoBangdingViewController"];
    //通知刷新我的个人中心
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyInfo" object:nil userInfo:nil];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    [textField resignFirstResponder];
    return YES;

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        [self backAction];
    }


}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _MimaAgaintextFeild.hidden = YES;
    _MimaAgainImageView.hidden = YES;
    _MimaImageview.hidden = YES;
    _MimaTextFeild.hidden = YES;
    _zhangHaoBangDingButton.frame = CGRectMake(10, 126, self.view.bounds.size.width - 20, 40);
    _lable.frame=CGRectMake(10,50, self.view.bounds.size.width - 20, 44);
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"账号绑定";
    _zhangHaoTextField.delegate = self;
    _MimaTextFeild.delegate = self;
    _MimaAgaintextFeild.delegate = self;
    NSLog(@"_token = %@",_token);
    NSString*urlString=[NSString stringWithFormat:@"%@account/is-set-pwd?access-token=%@",ApiUrlHead,_token];
    NSLog(@"urlString = %@",urlString);
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]];
        if ([code isEqualToString:@"1"]) {
            //设置过密码了
            _zhangHaoBangDingButton.frame = CGRectMake(10, 126, self.view.bounds.size.width - 20, 40);
            _lable.frame=CGRectMake(10,50, self.view.bounds.size.width - 20, 44);
            _MimaAgaintextFeild.hidden = YES;
            _MimaAgainImageView.hidden = YES;
            _MimaImageview.hidden = YES;
            _MimaTextFeild.hidden = YES;
        
        }else{
            //未设置密码
            _MimaAgaintextFeild.hidden = NO;
            _MimaAgainImageView.hidden = NO;
            _MimaImageview.hidden = NO;
            _MimaTextFeild.hidden = NO;
            
            _zhangHaoBangDingButton.frame = CGRectMake(10, 240, self.view.bounds.size.width - 20, 40);
            _lable.frame=CGRectMake(10, 170,  self.view.bounds.size.width - 20, 44);
            
           //            //设置密码
            //            NSString*URLString=[NSString stringWithFormat:@"%@user/login?account=%@&password=%@",ApiUrlHead,,_mima.text];
            //            NSLog(@"urlString = %@",urlString);
            //            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            //            [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //                NSLog(@"JSON: %@", responseObject);
            //                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            //                if ([code isEqualToString:@"0"]) {
            //                    [self dismissModalViewControllerAnimated:YES];
            //
            //                }
            //
            //            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //                NSLog(@"Error: %@", error);
            //
            //            }];
            //            
            
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
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

- (IBAction)zhangHaoBanDingButton:(id)sender {
    if (_zhangHaoTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入账号" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else if(![_MimaTextFeild.text isEqualToString:_MimaAgaintextFeild.text]&&_MimaTextFeild.hidden == NO){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码重复不一致" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }else if (_zhangHaoTextField.text.length > 0&&_MimaTextFeild.text.length == 0&&_MimaTextFeild.hidden == NO){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        
    }else if (_zhangHaoTextField.text.length == 0&&_MimaTextFeild.text.length > 0&&_MimaTextFeild.hidden == NO){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入账号" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        
    }else  if (_zhangHaoTextField.text.length>0&&[_MimaTextFeild.text isEqualToString:_MimaAgaintextFeild.text]) {
         NSString *urlStr = [NSString stringWithFormat:@"%@account/bind-username?access-token=%@",ApiUrlHead,_token];
        
      
        NSDictionary * _zhanghaoBD = [NSDictionary dictionary];
        if (_MimaTextFeild.hidden == NO) {
           _zhanghaoBD = @{@"username":_zhangHaoTextField.text,
                                           @"password":_MimaTextFeild.text,
                                           };
         
        }else{
        
            _zhanghaoBD = @{@"username":_zhangHaoTextField.text,
                        
                            };
        }
     
        
        
        [manager POST:urlStr parameters:_zhanghaoBD success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                //NSDictionary * Data = [responseObject objectForKey:@"data"];
                //通知刷新我的个人中心
               [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMyInfo" object:nil userInfo:nil];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"绑定成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.tag = 1;
                [alert show];
                
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入账号" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
}

#pragma MARK-UITextFieldDelegate

@end

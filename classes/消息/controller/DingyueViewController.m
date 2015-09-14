//
//  DingyueViewController.m
//  时时投
//
//  Created by 熊良军 on 15/8/25.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "DingyueViewController.h"
#import "WBBooksManager.h"
#import "MyDingyueView.h"
#import "DingyueView.h"
#import "DingyueChooseView.h"
@interface DingyueViewController ()<UIAlertViewDelegate>
@property (nonatomic ,strong)__block DingyueChooseView *shaixuanView;
@property (nonatomic ,strong)__block UIControl *shaixuanControl;
@property (nonatomic ,strong) DingyueView *Dv;
@property (nonatomic ,strong) MyDingyueView *mDv;
@property (nonatomic ,assign)__block  NSInteger dingyueIndex;
@end

@implementation DingyueViewController{
    AFHTTPRequestOperationManager *manager;
    NSMutableArray *tradeDataArray;  //订阅的消息
    NSMutableArray *tradeIDArray;  //订阅的消息
    NSMutableArray *titleArray;     //未订阅
    NSMutableArray *idArray;        //未订阅ID
    NSDictionary * _parameters;
    NSMutableArray *tradeTitleArray;
    LoadingViewXLJ *_loadingView;
    UILabel *titlelable;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DingyueViewController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DingyueViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订阅";
    self.view.backgroundColor = [UIColor whiteColor];
    manager = [AFHTTPRequestOperationManager manager];
    tradeDataArray = [NSMutableArray array];
    tradeIDArray = [NSMutableArray array];
    titleArray = [NSMutableArray array];
    idArray = [NSMutableArray array];
    _parameters = [NSDictionary dictionary];
    
    
    _shaixuanControl = [[UIControl alloc]initWithFrame:self.view.bounds];
    _shaixuanControl.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [_shaixuanControl addTarget:self action:@selector(hideShaixuan) forControlEvents:UIControlEventTouchUpInside];
    
    titlelable = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, self.view.bounds.size.width - 200, 20)];
    titlelable.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    titlelable.font = [UIFont systemFontOfSize:16.0];
    titlelable.textAlignment = NSTextAlignmentCenter;;
   
    NSString *message = [NSString stringWithFormat:@"%@subscribe/get-set?access-token=%@",ApiUrlHead,_token];
    //NSLog(@"message = %@",message);
    [manager GET:message parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [_loadingView removeFromSuperview];
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *data = [responseObject objectForKey:@"data"];
            NSLog(@"data = %@",data);
            [tradeDataArray addObjectsFromArray:data];  //订阅过的
             NSLog(@"tradeDataArray = %@",tradeDataArray);
            //未订阅的
            NSMutableDictionary * resultDictionary = [[NSMutableDictionary alloc] init];
            [[WBBooksManager sharedInstance] readPlist:&resultDictionary];
            NSDictionary *ArticleDic = [resultDictionary objectForKey:@"Article"];
            //NSLog(@"ArticleDic = %@",ArticleDic);
            NSDictionary *tradeDic = [ArticleDic objectForKey:@"trades"];
            NSArray *arr1 = [tradeDic allValues];
            [titleArray addObjectsFromArray:arr1];
            NSArray *arr2 = [tradeDic allKeys];
            [idArray addObjectsFromArray:arr2];
            
           
            tradeTitleArray = [NSMutableArray array];
            for (int i = 0; i < tradeDataArray.count; i ++) {
                NSString *tradeId = [NSString stringWithFormat:@"%@",[[tradeDataArray objectAtIndex:i]objectForKey:@"trade"]];
                [tradeIDArray addObject:tradeId];
                for (int j = 0;j < titleArray.count;j++) {
                    NSString *tradeId1 = [NSString stringWithFormat:@"%@",[idArray objectAtIndex:j]];
                    if ([tradeId isEqualToString:tradeId1]) {
                        NSString *title = [titleArray objectAtIndex:j];
                        [tradeTitleArray addObject:title];
                        
                        [titleArray removeObject:[titleArray objectAtIndex:j]];
                         [idArray removeObject:[idArray objectAtIndex:j]];
                        
                    }
                }
                
            }
            
            
            int num1 = (int)tradeDataArray.count/3;
            int h1;
            if (tradeDataArray.count%3 == 0) {
                h1 = 30 * num1 + 45;
            }else{
               h1 = 30 * num1 + 75;
                
            }
            //订阅视图
            _mDv = [[MyDingyueView alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, h1) titleArray:tradeTitleArray block:^(NSInteger index){
                _dingyueIndex = index;
                
                
                UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否取消订阅“%@”？",[tradeTitleArray objectAtIndex:_dingyueIndex]] delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                [alertview show];
                
                
             }];
            [self.view addSubview:_mDv];
            
            
            //未订阅视图
            int num = (int)titleArray.count/3;
            int h;
            if (titleArray.count%3 == 0) {
                h = 30 * num + 45;
            }else{
                h = 30 * num + 75;
            
            }
           
            _Dv = [[DingyueView alloc]initWithFrame:CGRectMake(10, _mDv.frame.origin.y + _mDv.bounds.size.height + 10, self.view.bounds.size.width - 20, h) titleArray:titleArray idArray:idArray block:^(NSInteger index){
                NSLog(@"index = %ld",(long)index);
                _dingyueIndex = index;
                __block  NSString *ID = [NSString stringWithFormat:@"%@",[idArray objectAtIndex:index]];
                
                titlelable.text = [titleArray objectAtIndex:_dingyueIndex];
                //筛选界面
                _shaixuanView = [[DingyueChooseView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 250,self.view.bounds.size.width, 250) block:^(NSDictionary *parameters, NSArray *array,NSString *fID,NSInteger index) {
                    //NSInteger indexNum = _dingyueIndex;
                    if (index == 0) {        //取消
                        [_shaixuanView removeFromSuperview];
                        _shaixuanView = nil;
                        [_shaixuanControl removeFromSuperview];
                    }else if (index == 1){   //确定
                        NSString *urlStr =[NSString stringWithFormat:@"%@subscribe/set?access-token=%@&trade=%@",ApiUrlHead,_token,ID];
                        [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSLog(@"JSON: %@", responseObject);
                            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                            if ([code isEqualToString:@"0"]) {
                                NSLog(@"设置成功");
                                [_shaixuanControl removeFromSuperview];
                                [_shaixuanView removeFromSuperview];
                                NSString *tradeStr =  [titleArray objectAtIndex:_dingyueIndex];
                                [tradeTitleArray addObject:tradeStr];
                                NSString *tradeId = [NSString stringWithFormat:@"%@",[idArray objectAtIndex:_dingyueIndex]];
                                [tradeIDArray addObject:tradeId];
                                int num1 = (int)tradeTitleArray.count/3;
                                int h1;
                                if (tradeTitleArray.count%3 == 0) {
                                    h1 = 30 * num1 + 45;
                                }else{
                                    h1 = 30 * num1 + 75;
                                    
                                }
                                [_mDv frame:CGRectMake(10, 10, self.view.bounds.size.width - 20, h1) titleArray:tradeTitleArray];
                                
                                
                                [titleArray removeObjectAtIndex:_dingyueIndex];
                                [idArray removeObjectAtIndex:_dingyueIndex];
                                
                                int num = (int)titleArray.count/3;
                                int h;
                                if (titleArray.count%3 == 0) {
                                    h = 30 * num + 45;
                                }else{
                                    h = 30 * num + 75;
                                }
                                [_Dv frame:CGRectMake(10, _mDv.frame.origin.y + _mDv.bounds.size.height + 10, self.view.bounds.size.width - 20, h) titleArray:titleArray idArray:idArray];
                             
                                
                            }else if (![code isEqualToString:@"0"]){
                                NSString *error = [responseObject objectForKey:@"err"];
                                NSLog(@"error=%@",error);
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择行业所在地区" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                                [alert show];
                                
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"Error: %@", error);
                             [_loadingView removeFromSuperview];
                            //网络不佳视图
                            InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height * 0.75, self.view.bounds.size.width - 180, 25)];
                            [self.view addSubview:errorView];
                        }];
                        
                    }
                    
                }];
                
              
                [_shaixuanView addSubview:titlelable];
                [self.view addSubview:_shaixuanControl];
                _shaixuanView.token = _token;
                [self.view addSubview:_shaixuanView];
                
                
            }];
            
            [self.view addSubview:_Dv];
            
        }else if (![code isEqualToString:@"0"]){
            NSString *error = [responseObject objectForKey:@"err"];
            NSLog(@"error=%@",error);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        //网络不佳视图
        InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height * 0.75, self.view.bounds.size.width - 180, 25)];
        [self.view addSubview:errorView];
        
    }];
   
    
    _loadingView = [[LoadingViewXLJ alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 200)*0.5, self.view.bounds.size.height*0.5 - 120, 200,100) title:@"正在加载，请稍后。。。"];
    [self.view addSubview:_loadingView];
        //NSLog(@"idArray = %@",idArray);
    //Do any additional setup after loading the view.
}
- (void)hideShaixuan{
    [_shaixuanView removeFromSuperview];
    [_shaixuanControl removeFromSuperview];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *urlStr =[NSString stringWithFormat:@"%@subscribe/del?access-token=%@&trade=%@",ApiUrlHead,_token,[tradeIDArray objectAtIndex:_dingyueIndex]];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSLog(@"删除成功");
                //[_shaixuanView removeFromSuperview];
                NSString *tradeStr =  [tradeTitleArray objectAtIndex:_dingyueIndex];
                NSString *tradeID =  [tradeIDArray objectAtIndex:_dingyueIndex];
                [tradeTitleArray removeObject:tradeStr];
                [tradeIDArray removeObject:tradeID];
                
                int num1 = (int)tradeTitleArray.count/3;
                int h1;
                if (tradeTitleArray.count%3 == 0) {
                    h1 = 30 * num1 + 45;
                }else{
                    h1 = 30 * num1 + 75;
                    
                }
                [_mDv frame:CGRectMake(10, 10, self.view.bounds.size.width - 20, h1) titleArray:tradeTitleArray];
                
                
                [titleArray addObject:tradeStr];
                [idArray addObject:tradeID];
                
                int num = (int)titleArray.count/3;
                int h;
                if (titleArray.count%3 == 0) {
                    h = 30 * num + 45;
                }else{
                    h = 30 * num + 75;
                    
                }
                [_Dv frame:CGRectMake(10, _mDv.frame.origin.y + _mDv.bounds.size.height + 10, self.view.bounds.size.width - 20, h) titleArray:titleArray idArray:idArray];
                
                
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                NSLog(@"error=%@",error);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                [alert show];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            //网络不佳视图
            InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height * 0.75, self.view.bounds.size.width - 180, 25)];
            [self.view addSubview:errorView];
        }];
        
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

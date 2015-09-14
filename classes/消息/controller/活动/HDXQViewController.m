//
//  HDXQViewController.m
//  时时投
//
//  Created by h on 15/8/27.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "HDXQViewController.h"

@interface HDXQViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *myWeiView;
@property (strong, nonatomic)__block NSMutableDictionary *DataDic;//存储数据

@end

@implementation HDXQViewController{
   AFHTTPRequestOperationManager *manager;
   
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"活动详情";
        
        UIButton *lestButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        [lestButton setTitle:@"分享" forState:UIControlStateNormal];
        lestButton.titleLabel.font=[UIFont systemFontOfSize:14];
        
        //[lestButton setImage:[UIImage imageNamed:@"fanhuix@2x"] forState:UIControlStateNormal];
        [lestButton addTarget:self action:@selector(fengxiang) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:lestButton];
        self.navigationItem.rightBarButtonItem = leftItem;
        
    }
    return self;
}
-(void)fengxiang{
    
    NSLog(@"分享");
    NSString *title = [_DataDic objectForKey:@"title"];
    //NSString *Title = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *content = [_DataDic objectForKey:@"content"];
    NSString *Content = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[_DataDic objectForKey:@"share_url"],@"share_url",title,@"title",Content,@"content", nil];
    //通知分享
    [[NSNotificationCenter defaultCenter]postNotificationName:@"toShareViewController" object:dic userInfo:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@activity/show?id=%@&access-token=%@",ApiUrlHead,_HuoDongID,_token];
    NSLog(@"=============_token = %@",_token);
    NSLog(@"_HuoDongID=============%@",_HuoDongID);
    manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSDictionary *dic1 = [responseObject objectForKey:@"data"];
            _DataDic = dic1;
            NSLog(@"_DataDic===========%@",_DataDic);
 //让lable自适应
//            CGFloat fl=[_huodongXiangQing.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(self.view.bounds.size.width, MAXFLOAT)].height;
//            _huodongXiangQing.frame=CGRectMake(5, 78, 310, fl);
//
            _titleLable.text=[_DataDic objectForKey:@"title"];
            
           
           
            _titleLable.frame=CGRectMake(0,- 80, self.view.bounds.size.width, 80);
            //_titleLable.frame=CGRectMake(self.view.bounds.size.width,self , 280, 25) ;
            
            
            _myWeiView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
            _myWeiView.scrollView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
            _myWeiView.scrollView.contentOffset = CGPointMake(0,  - 80);
            NSString*text1=[_DataDic objectForKey:@"content"];
            NSData*data1=[text1 dataUsingEncoding:NSUTF8StringEncoding];
            //将数据加载到UIWebView中
            [_myWeiView loadData:data1 MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
            //_myWeiView.scrollView.scrollEnabled = NO;
            [_myWeiView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '75%'"];
          
            //字体颜色
            [_myWeiView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#4f4f4f'"];
            _myWeiView.backgroundColor = [UIColor whiteColor];
            [_myWeiView.scrollView addSubview:_titleLable];
            [self.view addSubview:_myWeiView];
            
            
           
           // [_myWeiView addSubview:_titleLable];
        }else if (![code isEqualToString:@"0"]){
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        //网络不佳视图
        InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height * 0.75, self.view.bounds.size.width - 180, 25)];
        [self.view addSubview:errorView];
        
    }];
    
    
    //_title=[[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 10, self.view.bounds.size.height-20, 300, 20)];

   // [_myWeiView addSubview:_title];
    
//    _myWeiView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//    NSString*text1=_DataDic;
//    NSData*data1=[text1 dataUsingEncoding:NSUTF8StringEncoding];
//    //将数据加载到UIWebView中
//    [_myWeiView loadData:data1 MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
//    _myWeiView.scrollView.scrollEnabled = NO;
//    _myWeiView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_myWeiView];
    
    
    
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

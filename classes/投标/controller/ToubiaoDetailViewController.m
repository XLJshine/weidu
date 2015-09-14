//
//  ToubiaoDetailViewController.m
//  时时投
//
//  Created by 熊良军 on 15/8/12.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "ToubiaoDetailViewController.h"
#import "LableXLJ.h"
#import "XiangmuPinglinButton.h"
#import "AFHTTPRequestOperationManager.h"
#import "TimeXLJ.h"
#import "PinglunTableView.h"
#import "GerenInfoViewController.h"
#import "LoadingViewXLJ.h"
#import "WBBooksManager.h"
@interface ToubiaoDetailViewController ()<UIWebViewDelegate,UIAlertViewDelegate>

@property (nonatomic ,strong)UIScrollView *scroll;
@property (nonatomic ,strong)UIView *sendView;
@property (nonatomic ,strong)UIControl *control;
@property (nonatomic ,strong)UITextView *textView;
@property (nonatomic ,strong)PinglunTableView *tableView;
@property (nonatomic ,strong)UIView *changeFontView;
@end

@implementation ToubiaoDetailViewController{
    NSDictionary *Data;
    AFHTTPRequestOperationManager *manager;
    NSInteger *pingControlNum; //控制tableview的弹出收起
    UIView *tableviewHeadView;
    UIButton *nimingButton;
    NSInteger ifpinglun;
    __block NSInteger commonedNum;
    NSString * _user_id;  //楼主id
    NSString * _pid;   //楼主评论id
    NSString * _aid;   //楼主评论的评论id
    
    NSInteger h;
      LoadingViewXLJ *_loadingView;
    UIButton *StoreButton;   //收藏按钮
    NSString *faved;
    UIButton *rightItemButton;
    NSInteger replyNumCon;  //控制发布次数
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
       
        //UIImage *backImg1 = [UIImage imageNamed:@"dingbu2@2x"];
        rightItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 25,25)];
        //[backBtn1 setImage:backImg1 forState:UIControlStateNormal];
        //[backBtn1 setImage:[UIImage imageNamed:@"search_delete_img@2x"] forState:UIControlStateSelected];
        [rightItemButton setTitle:@"Aa" forState:UIControlStateNormal];
        [rightItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightItemButton addTarget:self action:@selector(changeFont:) forControlEvents:UIControlEventTouchUpInside];
         UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
        self.navigationItem.rightBarButtonItem = rightItem;
        //self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}
- (void)changeFont:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected == YES) {
        [_control removeFromSuperview];
        [_sendView removeFromSuperview];
       [UIView animateWithDuration:0.25 animations:^{
            _changeFontView.frame = CGRectMake(0, self.view.bounds.size.height - 172, self.view.bounds.size.width,172);
        
        } completion:nil];
        
        _control = [[UIControl alloc]initWithFrame:self.view.bounds];
        _control.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [_control addTarget:self action:@selector(hideSendView) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:_control belowSubview:_changeFontView];
    }else{
        [_control removeFromSuperview];
        [UIView animateWithDuration:0.25 animations:^{
            _changeFontView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width,172);
            
        } completion:nil];
    
    }
    
}
- (void)InitchangeFontView{
    _changeFontView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width,172)];
    _changeFontView.backgroundColor = [UIColor whiteColor];
    
    
    UISegmentedControl *segmented = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"小",@"中",@"大", nil]];
    segmented.frame = CGRectMake(50, 45, self.view.bounds.size.width - 100, 40);
    if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"Font"]) {
        //读取字体
        NSMutableDictionary * resultDictionary = [[NSMutableDictionary alloc] init];
        [[WBBooksManager sharedInstance] readPlist:&resultDictionary];
        NSDictionary *fontDic = [resultDictionary objectForKey:@"Font"];
        NSString *titleFont = [fontDic objectForKey:@"titleFont"];
        _titleFont = [titleFont integerValue];
        if (_titleFont == 19) {
            segmented.selectedSegmentIndex = 0;
        }else if (_titleFont == 20){
            segmented.selectedSegmentIndex = 1;
        }else if (_titleFont == 23){
            segmented.selectedSegmentIndex = 2;
        }
    }else{
       segmented.selectedSegmentIndex = 0;
    }

    [segmented addTarget:self action:@selector(segmentedChange:) forControlEvents:UIControlEventValueChanged];
    segmented.tintColor = [UIColor colorWithRed:0.2667 green:0.6941 blue:0.9059 alpha:1];
    [_changeFontView addSubview:segmented];
    
    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0,  _changeFontView.bounds.size.height - 50, self.view.bounds.size.width, 0.5)];
    sepLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    [_changeFontView addSubview:sepLine];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, _changeFontView.bounds.size.height - 49, self.view.bounds.size.width, 49)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithWhite:0.15 alpha:1] forState:UIControlStateNormal];
    [_changeFontView addSubview:backButton];
    [backButton addTarget:self action:@selector(hideSendView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeFontView];
}
- (void)segmentedChange:(UISegmentedControl *)segmened{
    NSLog(@"segmened.selectedSegmentIndex = %li",(long)segmened.selectedSegmentIndex);
     NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (segmened.selectedSegmentIndex == 0) {
        NSLog(@"小");
       [dictionary setValue:@"19" forKey:@"titleFont"];
       [dictionary setValue:@"12" forKey:@"lableFont"];
       [dictionary setValue:@"14" forKey:@"detailFont"];
       [dictionary setValue:@"8" forKey:@"titleSepFont"];
       [dictionary setValue:@"10" forKey:@"detailSepFont"];
        _titleFont = 19;
        _lableFont = 12;
        _detailFont = 14;
        _titleSepFont = 8;
        _detailSepFont = 10;
    }else if (segmened.selectedSegmentIndex == 1){
        NSLog(@"中");
       [dictionary setValue:@"20" forKey:@"titleFont"];
       [dictionary setValue:@"12" forKey:@"lableFont"];
       [dictionary setValue:@"16" forKey:@"detailFont"];
       [dictionary setValue:@"8" forKey:@"titleSepFont"];
       [dictionary setValue:@"11" forKey:@"detailSepFont"];
        _titleFont = 20;
        _lableFont = 12;
        _detailFont = 16;
        _titleSepFont = 8;
        _detailSepFont = 11;
    }else if (segmened.selectedSegmentIndex == 2){
        NSLog(@"大");
      [dictionary setValue:@"23" forKey:@"titleFont"];
      [dictionary setValue:@"12" forKey:@"lableFont"];
      [dictionary setValue:@"18" forKey:@"detailFont"];
      [dictionary setValue:@"9" forKey:@"titleSepFont"];
      [dictionary setValue:@"14" forKey:@"detailSepFont"];
        _titleFont = 23;
        _lableFont = 12;
        _detailFont = 18;
        _titleSepFont = 9;
        _detailSepFont = 14;
    }
    NSArray *subViewArr = tableviewHeadView.subviews;
    for (UIView *view in subViewArr) {
        [view removeFromSuperview];
    }
    
    [self title:[Data objectForKey:@"title"]
           mail:nil
           time:_time
  xiangmuDetail:[Data objectForKey:@"content"]
   tanpanDeatil:nil
     zigeDetail:nil];
    
    
    if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"Font"]) {
        //存在，则替换之
        NSLog(@"存在，则替换之");
        [[WBBooksManager sharedInstance] replaceDictionary:dictionary withDictionaryKey:@"Font"];
    }else{//不存在，则写入
        NSLog(@"不存在，则写入");
        [[WBBooksManager sharedInstance] writePlist:dictionary forKey:@"Font"];
    }
}
- (void)readTextFont{
    if ([[WBBooksManager sharedInstance] isBookExistsForKey:@"Font"]) {
        //读取字体
        NSMutableDictionary * resultDictionary = [[NSMutableDictionary alloc] init];
        [[WBBooksManager sharedInstance] readPlist:&resultDictionary];
        NSDictionary *fontDic = [resultDictionary objectForKey:@"Font"];
        NSString *titleFont = [fontDic objectForKey:@"titleFont"];
        NSString *lableFont = [fontDic objectForKey:@"lableFont"];
        NSString *detailFont = [fontDic objectForKey:@"detailFont"];
        NSString *titleSepFont = [fontDic objectForKey:@"titleSepFont"];
        NSString *detailSepFont = [fontDic objectForKey:@"detailSepFont"];
        _titleFont = [titleFont integerValue];
        _lableFont = [lableFont integerValue];
        _detailFont = [detailFont integerValue];
        _titleSepFont = [titleSepFont integerValue];
        _detailSepFont = [detailSepFont integerValue];
        
    }else{
        _titleFont = 19;
        _lableFont = 12;
        _detailFont = 14;
        _titleSepFont = 8;
        _detailSepFont = 10;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目信息";
    self.view.backgroundColor = [UIColor whiteColor];
    pingControlNum = 0;
    ifpinglun = 1;
    commonedNum = 0;
    replyNumCon = 0; //控制发布次数
    [self readTextFont];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@article/show?id=%@&access-token=%@",ApiUrlHead,_toubiaoID,_token];
     manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        [_loadingView removeFromSuperview];
        if ([code isEqualToString:@"0"]) {
            Data = [responseObject objectForKey:@"data"];
            NSLog(@"Data = %@",Data);
            faved = [NSString stringWithFormat:@"%@",[Data objectForKey:@"faved"]];
            if ([faved isEqualToString:@"1"]) {
                [StoreButton setImage:[UIImage imageNamed:@"faved_img_big@2x"] forState:UIControlStateNormal];
            }
            [_loadingView removeFromSuperview];
            [self title:[Data objectForKey:@"title"]
                   mail:nil
                   time:_time
          xiangmuDetail:[Data objectForKey:@"content"]
           tanpanDeatil:nil
             zigeDetail:nil];
         
        }else if (![code isEqualToString:@"0"]){
            NSString *error = [responseObject objectForKey:@"err"];
      
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
      [_loadingView removeFromSuperview];
        //网络不佳视图
        InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.view.bounds.size.height * 0.75, self.view.bounds.size.width - 180, 25)];
        [self.view addSubview:errorView];
    }];
    
  
    _tableView = [[PinglunTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 40) toubiaoID:_toubiaoID  token:_token block:^(NSInteger index,NSString *user_id,NSString *pid,NSInteger indexPath_row){
        if (index == -1) {  //隐藏tableview
            if (_ifShowPinglun.length > 0) { //判断是否显示评论列表
                if (_tableView.array.count > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }else{
                  
                    
                }
            }
        }else if (index == -3){
            if (_token.length > 10) {
                ifpinglun = 4;
                _user_id = user_id;
                _pid = pid;
                
                [self initSendView:@"回 复"];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还尚未登录，是否登录？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                [alert show];
                
                
            }
           
            
        }else if(indexPath_row < 0){
            GerenInfoViewController *GVC = [[GerenInfoViewController alloc]init];
            GVC.uid = user_id;
            GVC.token = _token;
            [self.navigationController pushViewController:GVC animated:YES];
        
        }else if (indexPath_row >= 0){
            if (_token.length > 10) {
                ifpinglun = 3;
                _user_id = user_id;
                [self initSendView:@"回 复"];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还尚未登录，是否登录？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                [alert show];
            }
        }
    
    
    }];
    _tableView.token = _token;
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    
    [self addBottonView];
    // Do any additional setup after loading the view.
    // 修改字体大小
    [self InitchangeFontView];
    
    _loadingView = [[LoadingViewXLJ alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 200)*0.5, self.view.bounds.size.height*0.5 - 120, 200,100)  title:@"正在加载，请稍后。。。"];
    [self.view addSubview:_loadingView];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    //监听，点击评论名称跳转
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PushFromToubiaoDetail:) name:@"PushFromToubiaoDetail" object:nil];
}
- (void)PushFromToubiaoDetail:(NSNotification *)notification{
    NSString *userID = notification.object;
    GerenInfoViewController *GVC = [[GerenInfoViewController alloc]init];
    GVC.uid = userID;
    GVC.token = _token;
    [self.navigationController pushViewController:GVC animated:YES];

}
#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        //_bottomView.hidden = NO;
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
        //_bottomView.hidden = YES;
    }];
}

- (void)title:(NSString *)title1 mail:(NSString *)mail1 time:(NSString *)time1 xiangmuDetail:(NSString *)xiangmuDetail1 tanpanDeatil:(NSString *)tanpanDetail1 zigeDetail:(NSString *)zigeDetail1{
    
    tableviewHeadView = [[UIView alloc]init];
    
    LableXLJ *titleLable = [[LableXLJ alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 10) text:title1 textColor:[UIColor blackColor] font:(int)_titleFont numberOfLines:0 lineSpace:(int)_titleSepFont];
    [tableviewHeadView addSubview:titleLable];
    
    /*UILabel *mailLable = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLable.frame.origin.y + titleLable.bounds.size.height + 10, 150, 10)];
     mailLable.textColor = [UIColor colorWithRed:0.9529 green:0.4745 blue:0.4824 alpha:1];
    mailLable.font = [UIFont systemFontOfSize:10];
    
    NSMutableAttributedString *str11 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"MAIL:%@",mail1]];
     [str11 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.6431 alpha:1] range:NSMakeRange(0,5)];
    mailLable.attributedText = str11;
    [tableviewHeadView addSubview:mailLable];*/
    
    
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 150, titleLable.frame.origin.y + titleLable.bounds.size.height + 10, 140, 10)];
     timeLable.textColor = [UIColor colorWithWhite:0.3 alpha:1];
     timeLable.textAlignment = NSTextAlignmentRight;
     timeLable.text = [NSString stringWithFormat:@"时间：%@",time1];
    timeLable.font = [UIFont systemFontOfSize:_lableFont];
    [tableviewHeadView addSubview:timeLable];
    
    
    h = timeLable.frame.origin.y + timeLable.bounds.size.height + 10;
    
    
    /*LableXLJ *xiangmuDetail = [[LableXLJ alloc]initWithFrame:CGRectMake(10, timeLable.frame.origin.y + timeLable.bounds.size.height + 15, self.view.bounds.size.width- 20, 10) text:xiangmuDetail1 textColor:[UIColor colorWithWhite:0.3 alpha:1] font:13 numberOfLines:0 lineSpace:3];
    [tableviewHeadView addSubview:xiangmuDetail];
    tableviewHeadView.frame = CGRectMake(0, 0, self.view.bounds.size.width, xiangmuDetail.frame.origin.y + xiangmuDetail.bounds.size.height + 25);
    
   */
    
    UIWebView *webViewSummay = [[UIWebView alloc]initWithFrame:CGRectMake(0, h, self.view.bounds.size.width, 10)];
    webViewSummay.delegate = self;
    webViewSummay.tag = 1;
    //将文本转成NSData数据
    NSString *text1  = xiangmuDetail1;
    //NSLog(@"text = %@",text);
    NSData *data1=[text1 dataUsingEncoding:NSUTF8StringEncoding];
    //将数据加载到UIWebView中
    [webViewSummay loadData:data1 MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
    webViewSummay.scrollView.scrollEnabled = NO;
    webViewSummay.backgroundColor = [UIColor whiteColor];
    [tableviewHeadView addSubview:webViewSummay];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView  //webView自适应高度
{
    //字体大小
    if (_detailFont == 14) {
         [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
    }else if (_detailFont == 16){
         [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'"];
    }else if (_detailFont == 18){
         [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '140%'"];
    }
     //高度自适应
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    int height = [height_str intValue];
        //字体颜色
      [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#4f4f4f'"];
        //页面背景色
       webView.backgroundColor = [UIColor clearColor];
      [webView setOpaque:NO];
       webView.frame = CGRectMake(0,h,self.view.bounds.size.width, height + 15);
       //NSLog(@"height: %@", [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]);
       tableviewHeadView.frame = CGRectMake(0, 0, self.view.bounds.size.width, webView.frame.origin.y + webView.bounds.size.height + 25);
    
       UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, tableviewHeadView.bounds.size.height - 16, 5, 16)];
       view1.backgroundColor = [UIColor colorWithRed:0.2902 green:0.6980 blue:0.8980 alpha:1];
      [tableviewHeadView addSubview:view1];
       UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10,tableviewHeadView.bounds.size.height - 16, 100, 16)];
      lable.font = [UIFont systemFontOfSize:15.0];
      lable.textColor = [UIColor grayColor];
      lable.text = @"评论";
      [tableviewHeadView addSubview:lable];
       _tableView.tableHeaderView = tableviewHeadView;
    
       if (_ifShowPinglun.length > 0) { //判断是否显示评论列表
        if (_tableView.array.count > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else{
            
            
        }
    }
}

- (void)addBottonView{
    UIView *bottonview = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40 - 64, self.view.bounds.size.width, 40)];
    bottonview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dibu1@2x"]];
    [self.view addSubview:bottonview];
    XiangmuPinglinButton *xmButton = [[XiangmuPinglinButton alloc]initWithFrame:CGRectMake(17, 10, 65, 20)];
    [xmButton setImage:[UIImage imageNamed:@"create-new_4@2x"] forState:UIControlStateNormal];
    [xmButton setTitle:@"写评论" forState:UIControlStateNormal];
    [xmButton setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    xmButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [bottonview addSubview:xmButton];
    [xmButton addTarget:self action:@selector(sendPinglun:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(90, 8, 0.5, 24)];
    sepLine.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
    [bottonview addSubview:sepLine];
    
      NSArray *imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"message-lines_3@2x"],
                             [UIImage imageNamed:@"heart_1@2x"],
                             [UIImage imageNamed:@"share_2@2x"],
                             [UIImage imageNamed:@"jinggao@2x"], nil];
    for (int i = 0; i < 4; i ++) {
        if (i == 1) {
            StoreButton = [[UIButton alloc]initWithFrame:CGRectMake(110 + 52 * i, 9, 22, 22)];
            StoreButton.tag = i;
            StoreButton.backgroundColor = [UIColor whiteColor];
            [StoreButton setImage:[imageArray objectAtIndex:i] forState:UIControlStateNormal];
            [StoreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [bottonview addSubview:StoreButton];
        }else{
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(110 + 52 * i, 9, 22, 22)];
            button.tag = i;
            button.backgroundColor = [UIColor whiteColor];
            [button setImage:[imageArray objectAtIndex:i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [bottonview addSubview:button];
        }
        
    }
}

- (void)initSendView:(NSString *)sendtype{
    _control = [[UIControl alloc]initWithFrame:self.view.bounds];
    _control.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [_control addTarget:self action:@selector(hideSendView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_control];
    
    _sendView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 130, self.view.bounds.size.width, 130)];
    _sendView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_sendView];
    
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, self.view.bounds.size.width - 20, 64)];
    [imageView setImage:[UIImage imageNamed:@"chaangtiao4@2x"]];
    [_sendView addSubview:imageView];
    
     _textView = [[UITextView alloc]initWithFrame:CGRectMake(12, 15,  self.view.bounds.size.width - 24, 60)];
    _textView.backgroundColor = [UIColor clearColor];
    [_textView becomeFirstResponder];
    [_sendView addSubview:_textView];
    
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, imageView.frame.origin.y + imageView.bounds.size.height + 15, 44, 10)];
    lable.font = [UIFont systemFontOfSize:14.0];
    lable.text = @"匿名：";
    lable.textColor = [UIColor colorWithWhite:0.15 alpha:1];
    [_sendView addSubview:lable];
    
    nimingButton = [[UIButton alloc]initWithFrame:CGRectMake(lable.frame.origin.x + lable.bounds.size.width, lable.frame.origin.y - 2.5, 16, 16)];
    [nimingButton setImage:[UIImage imageNamed:@"nimingfangkuang@2x"] forState:UIControlStateNormal];
    [nimingButton setImage:[UIImage imageNamed:@"nimingfangkuang1@2x"] forState:UIControlStateSelected];
    nimingButton.backgroundColor = [UIColor clearColor];
    [nimingButton addTarget:self action:@selector(nimingAction:) forControlEvents:UIControlEventTouchUpInside];
    [_sendView addSubview:nimingButton];
    
    UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 80, lable.frame.origin.y - 7, 70, 25)];
    [sendButton setTitle:sendtype forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"toubiaoDetail_fabu_img@2x"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendPinglunText1) forControlEvents:UIControlEventTouchUpInside];
    [_sendView addSubview:sendButton];
    
  
    
}
- (void)nimingAction:(UIButton *)button{ //匿名
    button.selected = !button.selected;
    
    
}
- (void)shareAction:(UIButton *)button{
    NSLog(@"i == %li",(long)button.tag);
    
    
    
}


- (void)replyText:(NSString *)userID{
   /* NSString *urlStr = [NSString string];
    if (nimingButton.selected == YES) {
        urlStr = [NSString stringWithFormat:@"%@comment/new?&access-token=%@&aid=%@&rid=%@&pid=%@&cont=%@&nm=1",ApiUrlHead,_token,_toubiaoID,_user_id,_user_id,[NSString stringWithFormat:@"%@",_textView.text]];
        
    }else{
        urlStr = [NSString stringWithFormat:@"%@comment/new?access-token=%@&aid=%@&&rid=%@&pid=%@&cont=%@&nm=0",ApiUrlHead,_token,_toubiaoID,_user_id,_user_id,[NSString stringWithFormat:@"%@",_textView.text]];
        
    }*/
    
    NSString *urlStr = [NSString string];
    NSDictionary *dictionary = [NSDictionary dictionary];
    if (nimingButton.selected == YES) {
       urlStr = [NSString stringWithFormat:@"%@comment/new?access-token=%@",ApiUrlHead,_token];
        NSString *textStr = [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:textStr,@"cont",
                      @"1",@"nm",
                      _toubiaoID,@"aid",
                      _user_id,@"rid",
                      _user_id,@"pid",nil];
    }else{
      
        urlStr = [NSString stringWithFormat:@"%@comment/new?access-token=%@",ApiUrlHead,_token];
        NSString *textStr = [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:textStr,@"cont",
                      @"0",@"nm",
                      _toubiaoID,@"aid",
                      _user_id,@"rid",
                      _user_id,@"pid",nil];
    }
//    NSLog(@"urlStr = %@",urlStr);
//    NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"encoded = %@",encoded);
    
    [manager POST:urlStr parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        
        [self hideSendView];  //移除发布窗口
        
        if ([code isEqualToString:@"0"]) {
            NSString *data = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]];
            if ([data isEqualToString:@"1"]) {
                commonedNum ++;
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"信息发布成功" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                [alert show];
            }
            
            
             [_tableView toubiaoID:_toubiaoID];  //刷新tableView
            
        }else if (![code isEqualToString:@"0"]){
            NSString *error = [responseObject objectForKey:@"err"];
            NSLog(@"error=%@",error);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];

}

- (void)sendPinglunText1{
    NSLog(@"发表评论");
    if (ifpinglun == 1) {
        if (replyNumCon == 0) {
            NSString *urlStr = [NSString string];
            NSDictionary *dictionary = [NSDictionary dictionary];
            if (nimingButton.selected == YES) {
                //urlStr = [NSString stringWithFormat:@"%@comment/new?access-token=%@&aid=%@&cont=%@&nm=1",ApiUrlHead,_token,_toubiaoID,[NSString stringWithFormat:@"%@",_textView.text]];
                urlStr = [NSString stringWithFormat:@"%@comment/new?access-token=%@",ApiUrlHead,_token];
                NSString *textStr = [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                dictionary = [NSDictionary dictionaryWithObjectsAndKeys:textStr,@"cont",
                              @"1",@"nm",
                              _toubiaoID,@"aid",nil];
            }else{
                //urlStr = [NSString stringWithFormat:@"%@comment/new?access-token=%@&aid=%@&cont=%@&nm=0",ApiUrlHead,_token,_toubiaoID,[NSString stringWithFormat:@"%@",_textView.text]];
                
                urlStr = [NSString stringWithFormat:@"%@comment/new?access-token=%@",ApiUrlHead,_token];
                NSString *textStr = [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                dictionary = [NSDictionary dictionaryWithObjectsAndKeys:textStr,@"cont",
                                            @"0",@"nm",
                                            _toubiaoID,@"aid",nil];
            }
            
            
            NSLog(@"urlStr = %@",urlStr);
            //NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"encoded = %@",encoded);
            [manager POST:urlStr parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                replyNumCon = 0;
                [self hideSendView];  //移除发布窗口
                
                if ([code isEqualToString:@"0"]) {
                    NSString *data = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]];
                    if ([data isEqualToString:@"1"]) {
                        commonedNum ++;
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"信息发布成功" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                        [alert show];
                    }
                    
                    
                    [_tableView toubiaoID:_toubiaoID];  //刷新tableView
                    
                }else if (![code isEqualToString:@"0"]){
                    NSString *error = [responseObject objectForKey:@"err"];
                    NSLog(@"error=%@",error);
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                    [alert show];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                replyNumCon = 0;
                
            }];
            replyNumCon ++;
        }
        
       
    }else if(ifpinglun == 2){   //意见反馈
        if (replyNumCon == 0) {
            NSString *urlStr = [NSString string];
            if (nimingButton.selected == YES) {
                urlStr = [NSString stringWithFormat:@"%@service/feedback?&article_id=%@&content=%@&type=3",ApiUrlHead,_toubiaoID,[NSString stringWithFormat:@"%@",_textView.text]];
                
            }else{
                urlStr = [NSString stringWithFormat:@"%@service/feedback?access-token=%@&article_id=%@&content=%@&type=3",ApiUrlHead,_token,_toubiaoID,[NSString stringWithFormat:@"%@",_textView.text]];
                
            }
            NSLog(@"urlStr = %@",urlStr);
            
            NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"encoded = %@",encoded);
            
            [manager GET:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                replyNumCon = 0;
                [self hideSendView];  //移除发布窗口
                
                if ([code isEqualToString:@"0"]) {
                    NSString *data = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]];
                    if ([data isEqualToString:@"1"]) {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"举报成功" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                        [alert show];
                    }
                    
                    
                    [_tableView toubiaoID:_toubiaoID];  //刷新tableView
                    
                }else if (![code isEqualToString:@"0"]){
                    NSString *error = [responseObject objectForKey:@"err"];
                    NSLog(@"error=%@",error);
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                    [alert show];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                replyNumCon = 0;
            }];
            
            replyNumCon ++;
        
        }
        
    }else if (ifpinglun == 3){
        [self  replyText:_user_id];
    }else{
        /*NSString *urlStr = [NSString string];
        if (nimingButton.selected == YES) {
            urlStr = [NSString stringWithFormat:@"%@comment/new?&access-token=%@&aid=%@&rid=%@&pid=%@&cont=%@&nm=1",ApiUrlHead,_token,_toubiaoID,_pid,_user_id,[NSString stringWithFormat:@"%@",_textView.text]];
            
        }else{
            urlStr = [NSString stringWithFormat:@"%@comment/new?access-token=%@&aid=%@&rid=%@&pid=%@&cont=%@&nm=0",ApiUrlHead,_token,_toubiaoID,_pid,_user_id,[NSString stringWithFormat:@"%@",_textView.text]];
            
        }*/
        
        NSString *urlStr = [NSString string];
        NSDictionary *dictionary = [NSDictionary dictionary];
        if (nimingButton.selected == YES) {
            //urlStr = [NSString stringWithFormat:@"%@comment/new?access-token=%@&aid=%@&cont=%@&nm=1",ApiUrlHead,_token,_toubiaoID,[NSString stringWithFormat:@"%@",_textView.text]];
            urlStr = [NSString stringWithFormat:@"%@comment/new?access-token=%@",ApiUrlHead,_token];
            NSString *textStr = [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            dictionary = [NSDictionary dictionaryWithObjectsAndKeys:textStr,@"cont",
                          @"1",@"nm",
                          _toubiaoID,@"aid",
                          _pid,@"rid",
                          _user_id,@"pid",nil];
        }else{
            //urlStr = [NSString stringWithFormat:@"%@comment/new?access-token=%@&aid=%@&cont=%@&nm=0",ApiUrlHead,_token,_toubiaoID,[NSString stringWithFormat:@"%@",_textView.text]];
            urlStr = [NSString stringWithFormat:@"%@comment/new?access-token=%@",ApiUrlHead,_token];
            NSString *textStr = [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            dictionary = [NSDictionary dictionaryWithObjectsAndKeys:textStr,@"cont",
                          @"0",@"nm",
                          _toubiaoID,@"aid",
                          _pid,@"rid",
                          _user_id,@"pid",nil];
        }
        
//        NSLog(@"urlStr = %@",urlStr);
//        NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSLog(@"encoded = %@",encoded);
        
        [manager POST:urlStr parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            
            [self hideSendView];  //移除发布窗口
            
            if ([code isEqualToString:@"0"]) {
                NSString *data = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]];
                if ([data isEqualToString:@"1"]) {
                    commonedNum ++;
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"恭喜" message:@"信息发布成功" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                    [alert show];
                }
                
                
                [_tableView toubiaoID:_toubiaoID];  //刷新tableView
                
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                NSLog(@"error=%@",error);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            
        }];
        

    
    }
    
}
- (void)sendPinglun:(XiangmuPinglinButton *)button{
    NSLog(@"xxx");
    if (_token.length > 10) {
        [self initSendView:@"发布评论"];
        ifpinglun = 1;
    }else{
        NSLog(@"登录");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还尚未登录，是否登录？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
    }
    
}
- (void)hideSendView{
    NSLog(@"yyy");
    rightItemButton.selected = NO;
    [_control removeFromSuperview];
    [_sendView removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        _changeFontView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width,172);
        
    } completion:nil];
    
}
- (void)buttonAction:(UIButton *)button{
    NSLog(@"i == %li",(long)button.tag);
    
    switch (button.tag) {
        case 0:
        {
            if (_tableView.array.count > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无评论" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                [alert show];
            }
        }
            break;
        case 1:  //收藏
        {
            if (_token.length > 10) {
                NSString *urlStr = [NSString stringWithFormat:@"%@favorite/new?access-token=%@&aid=%@",ApiUrlHead,_token,_toubiaoID];
                if ([faved isEqualToString:@"0"]) {
                    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"JSON: %@", responseObject);
                        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                        
                        if ([code isEqualToString:@"0"]) {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"收藏成功" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                            [button setImage:[UIImage imageNamed:@"faved_img_big@2x"] forState:UIControlStateNormal];
                            faved = @"1";
                            [alert show];
                            
                            
                        }else if (![code isEqualToString:@"0"]){
                            NSString *error = [responseObject objectForKey:@"err"];
                            NSLog(@"error=%@",error);
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                            [alert show];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        
                        
                    }];
                    
                }else{
                    NSString *urlStr = [NSString stringWithFormat:@"%@favorite/del?id=%@&access-token=%@",ApiUrlHead,_toubiaoID,_token];
                    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"JSON: %@", responseObject);
                        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                        if ([code isEqualToString:@"0"]) {
                            [button setImage:[UIImage imageNamed:@"heart_1@2x"] forState:UIControlStateNormal];
                            faved = @"0";
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已取消收藏" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                            [alert show];
                            
                        }else if (![code isEqualToString:@"0"]){
                            NSString *error = [responseObject objectForKey:@"err"];
                            NSLog(@"error=%@",error);
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                            [alert show];
                            [button setImage:[UIImage imageNamed:@"heart_1@2x"] forState:UIControlStateNormal];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        
                        
                    }];
                }
            }else{
                NSLog(@"登录");
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还尚未登录，是否登录？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                [alert show];
            }
          
                    }
            break;
        case 2:
        {
            
            NSString *title = [Data objectForKey:@"title"];
            //NSString *Title = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *content = [Data objectForKey:@"content"];
            NSString *Content = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
           
            if (title.length > 15) {
                title = [title substringToIndex:15];
            }
            
            if (Content.length > 30) {
                Content = [Content substringToIndex:30];
            }
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[Data objectForKey:@"share_url"],@"share_url",title,@"title",Content,@"content", nil];
          
           //通知分享
            [[NSNotificationCenter defaultCenter]postNotificationName:@"toShareViewController" object:dic userInfo:nil];
        }
            break;
        case 3:
        {
            if (_token.length > 10) {
                [self initSendView:@"提交投诉"];
                ifpinglun = 2;
            }else{
                NSLog(@"登录");
              
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还尚未登录，是否登录？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                [alert show];
            }
           
        }
            break;
        default:
            break;
    }
}
#pragma mark --- UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
          [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginView" object:nil userInfo:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([_ifFromToubiao isEqualToString:@"toubiao"]) {
       [[NSNotificationCenter defaultCenter]postNotificationName:@"NumHaveChanged" object:[NSString stringWithFormat:@"%li",(long)commonedNum] userInfo:nil];
    }else if([_ifFromToubiao isEqualToString:@"shoucang"]){
       [[NSNotificationCenter defaultCenter]postNotificationName:@"ShoucangNumHaveChanged" object:[NSString stringWithFormat:@"%li",(long)commonedNum] userInfo:nil];
    }else if ([_ifFromToubiao isEqualToString:@"dingyue"]){
         [[NSNotificationCenter defaultCenter]postNotificationName:@"DingyueNumHaveChanged" object:[NSString stringWithFormat:@"%li",(long)commonedNum] userInfo:nil];
    }
    
    [MobClick endLogPageView:@"toubiaoDetailViewController"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"toubiaoDetailViewController"];
    
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

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
@interface ToubiaoDetailViewController ()

@property (nonatomic ,strong)UIScrollView *scroll;
@property (nonatomic ,strong)UIView *sendView;
@property (nonatomic ,strong)UIControl *control;
@property (nonatomic ,strong)UITextView *textView;
@property (nonatomic ,strong)PinglunTableView *tableView;
@end

@implementation ToubiaoDetailViewController{
    NSDictionary *Data;
    AFHTTPRequestOperationManager *manager;
    NSInteger *pingControlNum; //控制tableview的弹出收起
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目信息";
    self.view.backgroundColor = [UIColor whiteColor];
    pingControlNum = 0;
    
    

    NSString *urlStr = [NSString stringWithFormat:@"%@article/show?id=%@",ApiUrlHead,_toubiaoID];
     manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            Data = [responseObject objectForKey:@"data"];
            NSLog(@"Data = %@",Data);
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
     
        
    }];
    
  
    _tableView = [[PinglunTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 40) toubiaoID:_toubiaoID  block:^(NSInteger index){
        if (index == -1) {  //隐藏tableview
            if (_ifShowPinglun.length > 0) { //判断是否显示评论列表
                if (_tableView.array.count > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }else{
                    
                    
                }
            }
        }else{
            GerenInfoViewController *GVC = [[GerenInfoViewController alloc]init];
            [self.navigationController pushViewController:GVC animated:YES];
        
        }
    }];
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    
    [self addBottonView];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    
    
    UIView *tableviewHeadView = [[UIView alloc]init];
    
    
    
    LableXLJ *titleLable = [[LableXLJ alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 10) text:title1 textColor:[UIColor blackColor] font:14 numberOfLines:0 lineSpace:3];
    [tableviewHeadView addSubview:titleLable];
    
    
    UILabel *mailLable = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLable.frame.origin.y + titleLable.bounds.size.height + 10, 150, 10)];
     mailLable.textColor = [UIColor colorWithRed:0.9529 green:0.4745 blue:0.4824 alpha:1] ;
    mailLable.font = [UIFont systemFontOfSize:10];
    
    NSMutableAttributedString *str11 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"MAIL:%@",mail1]];
     [str11 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.6431 alpha:1] range:NSMakeRange(0,5)];
    mailLable.attributedText = str11;
    [tableviewHeadView addSubview:mailLable];
    
    
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 150, mailLable.frame.origin.y, 140, 10)];
     timeLable.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    timeLable.textAlignment = NSTextAlignmentRight;
     timeLable.text = [NSString stringWithFormat:@"时间：%@",time1];
    timeLable.font = [UIFont systemFontOfSize:10];
    [tableviewHeadView addSubview:timeLable];
    
    LableXLJ *xiangmuDetail = [[LableXLJ alloc]initWithFrame:CGRectMake(10, timeLable.frame.origin.y + timeLable.bounds.size.height + 15, self.view.bounds.size.width- 20, 10) text:xiangmuDetail1 textColor:[UIColor colorWithWhite:0.3 alpha:1] font:13 numberOfLines:0 lineSpace:3];
    [tableviewHeadView addSubview:xiangmuDetail];
    tableviewHeadView.frame = CGRectMake(0, 0, self.view.bounds.size.width, xiangmuDetail.frame.origin.y + xiangmuDetail.bounds.size.height + 25);
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, tableviewHeadView.bounds.size.height - 16, 5, 16)];
    view1.backgroundColor = [UIColor redColor];
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
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(110 + 52 * i, 9, 22, 22)];
        button.tag = i;
        button.backgroundColor = [UIColor whiteColor];
        [button setImage:[imageArray objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottonview addSubview:button];
    }
}

- (void)initSendView{
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
    
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, imageView.frame.origin.y + imageView.bounds.size.height + 20, 44, 10)];
    lable.font = [UIFont systemFontOfSize:14.0];
    lable.text = @"匿名：";
    lable.textColor = [UIColor colorWithWhite:0.15 alpha:1];
    [_sendView addSubview:lable];
    
    UIButton *nimingButton = [[UIButton alloc]initWithFrame:CGRectMake(lable.frame.origin.x + lable.bounds.size.width, lable.frame.origin.y - 3, 16, 16)];
    [nimingButton setImage:[UIImage imageNamed:@"nimingfangkuang@2x"] forState:UIControlStateNormal];
    [nimingButton setImage:[UIImage imageNamed:@"nimingfangkuang1@2x"] forState:UIControlStateSelected];
    nimingButton.backgroundColor = [UIColor clearColor];
    [nimingButton addTarget:self action:@selector(nimingAction:) forControlEvents:UIControlEventTouchUpInside];
    [_sendView addSubview:nimingButton];
    
    UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 60, lable.frame.origin.y - 7, 50, 25)];
    [sendButton setTitle:@"发 布" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithWhite:0.15 alpha:1] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"chaangtiao4@2x"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendPinglunText1) forControlEvents:UIControlEventTouchUpInside];
    [_sendView addSubview:sendButton];
    
  
    
}
- (void)nimingAction:(UIButton *)button{
    button.selected = !button.selected;
}
- (void)shareAction:(UIButton *)button{
    NSLog(@"i == %li",(long)button.tag);
}
- (void)sendPinglunText1{
    NSLog(@"发表评论");
    NSString *urlStr = [NSString stringWithFormat:@"%@comment/new?access-token=%@&aid=%@&cont=%@",ApiUrlHead,_token,_toubiaoID,[NSString stringWithFormat:@"%@",_textView.text]];
   
    NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSLog(@"encoded = %@",encoded);
    
    [manager GET:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        
        [self hideSendView];  //移除发布窗口
        
        if ([code isEqualToString:@"0"]) {
           
            NSString *data = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"data"]];
            if ([data isEqualToString:@"1"]) {
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
- (void)sendPinglun:(XiangmuPinglinButton *)button{
    NSLog(@"xxx");
    [self initSendView];

}
- (void)hideSendView{
    NSLog(@"yyy");
    [_control removeFromSuperview];
    [_sendView removeFromSuperview];

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
            NSString *urlStr = [NSString stringWithFormat:@"%@favorite/new?access-token=%@&aid=%@",ApiUrlHead,_token,_toubiaoID];
            
            [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                
                if ([code isEqualToString:@"0"]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"收藏成功" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
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
        }
            break;
        case 2:
        {
        
        
            //通知分享
            [[NSNotificationCenter defaultCenter]postNotificationName:@"toShareViewController" object:nil userInfo:nil];
        
        }
            break;
        case 3:
        {}
            break;
        default:
            break;
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

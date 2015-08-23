//
//  ChatViewController.m
//  时时投
//
//  Created by 熊良军 on 15/8/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageFrame.h"
#import "Message.h"
#import "MessageCell.h"
@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSMutableArray  *_allMessagesFrame;
}
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UITextField *textField;
@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   self.title = @"林珊珊";
    
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"]];
    NSLog(@"array = %@",array);
    _allMessagesFrame = [NSMutableArray array];
    NSString *previousTime = nil;
    for (NSDictionary *dict in array) {
        
        MessageFrame *messageFrame = [[MessageFrame alloc] init];
        Message *message = [[Message alloc] init];
        message.dict = dict;
        
        messageFrame.showTime = ![previousTime isEqualToString:message.time];
        
        messageFrame.message = message;
        
        previousTime = message.time;
        
        [_allMessagesFrame addObject:messageFrame];
    }
    
    NSLog(@"%f",self.view.bounds.size.height);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 44)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beijing@2x"]];
    
    
    [self bottomViewInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //设置textField输入起始位置
    /*_messageField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    _messageField.leftViewMode = UITextFieldViewModeAlways;
    
    _messageField.delegate = self;*/
}

- (void)bottomViewInit{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44 - 64, self.view.bounds.size.width, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    
    UIButton *videoButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
    [videoButton setImage:[UIImage imageNamed:@"videachat@2x"] forState:UIControlStateNormal];
    [bottomView addSubview:videoButton];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(44, 5, 200, 34)];
    imageview.image = [UIImage imageNamed:@"sengbackground@2x"];
    [bottomView addSubview:imageview];
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(46, 7, 196, 30)];
    _textField.placeholder = @"评论";
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeySend;
    _textField.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:_textField];
    // 3、滚动至当前行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    UIButton *smailButton = [[UIButton alloc]initWithFrame:CGRectMake(250, 10, 24, 24)];
    [smailButton setImage:[UIImage imageNamed:@"smailchat@2x"] forState:UIControlStateNormal];
    [bottomView addSubview:smailButton];
    
    
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(285, 10, 24, 24)];
    [addButton setImage:[UIImage imageNamed:@"addchat@2x"] forState:UIControlStateNormal];
    [bottomView addSubview:addButton];
}
#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - 文本框代理方法
#pragma mark 点击textField键盘的回车按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // 1、增加数据源
    NSString *content = _textField.text;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    fmt.dateFormat = @"MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
  
    NSString *time = [fmt stringFromDate:date];
      NSLog(@"time = %@",time);
    [self addMessageWithContent:content time:time];
    // 2、刷新表格
    [self.tableView reloadData];
    // 3、滚动至当前行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    // 4、清空文本框内容
    //_messageField.text = nil;
    textField.text = @"";
    return YES;
}

#pragma mark 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time{
    
    MessageFrame *mf = [[MessageFrame alloc] init];
    Message *msg = [[Message alloc] init];
    msg.content = content;
    msg.time = time;
    msg.icon = @"icon01.png";
    msg.type = MessageTypeMe;
    mf.message = msg;
    
    [_allMessagesFrame addObject:mf];
}

#pragma mark - tableView数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allMessagesFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // 设置数据
    cell.messageFrame = _allMessagesFrame[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_allMessagesFrame[indexPath.row] cellHeight];
}

#pragma mark - 代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - 语音按钮点击
- (IBAction)voiceBtnClick:(UIButton *)sender {
    /*if (_messageField.hidden) { //输入框隐藏，按住说话按钮显示
        _messageField.hidden = NO;
        _speakBtn.hidden = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_nor.png"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_voice_press.png"] forState:UIControlStateHighlighted];
        [_messageField becomeFirstResponder];
    }else{ //输入框处于显示状态，按住说话按钮处于隐藏状态
        _messageField.hidden = YES;
        _speakBtn.hidden = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor.png"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"chat_bottom_keyboard_press.png"] forState:UIControlStateHighlighted];
        [_messageField resignFirstResponder];
    }*/
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

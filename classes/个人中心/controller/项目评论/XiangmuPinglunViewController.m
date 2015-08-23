//
//  XiangmuPinglunViewController.m
//  时时投
//
//  Created by 熊良军 on 15/8/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "XiangmuPinglunViewController.h"
#import "XiangmuPinglunHeadView.h"
#import "XiangmupinglunTableViewCellLeft.h"

#import "XiangmuPinglunTableViewCell2.h"
@interface XiangmuPinglunViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic ,strong)__block  XiangmuPinglunHeadView *tableHeadView;
@property (nonatomic ,strong)UITextField *textField;
@property (nonatomic ,strong)UIView *bottomView;
@end

@implementation XiangmuPinglunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目评论";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing@2x"]];
    
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableview];
    
    NSString *title = @"结局看撒风刀霜剑扩大进口点点滴滴的颠三倒四舒服放松放松放松时是非法的搜索结";
    NSString *detail = @"结局看撒风刀霜剑扩大进口点点滴滴的颠三倒四舒服放松放松放松时是非法的搜索结果还是如诶个护肤科技时代古日俄把 v 健康巨额经费和捷克东部 viu 人v 公司 u 日本 看撒风刀霜剑扩大进口点点滴滴的颠三倒四舒服放松放松放松时是非法的搜索结果还是如诶个看撒风刀霜剑扩大进口点点滴滴的颠三倒四舒服放松放松放松时是非法的搜索结果还是如诶个看撒风刀霜剑扩大进口点点滴滴的颠三倒四舒服放松放松放松时是非法的搜索结果还是如诶个v 开始就恢复撒个翻译阿富汗地方官员热u 风光一时个仿佛看到几个舒服撒的奶粉价格";
    _tableHeadView = [[XiangmuPinglunHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 220) title:title detail:detail   block:^(NSInteger index,CGRect rect){
        if (index == 0) {
            NSLog(@"赞");
        }else if (index == 1){
            NSLog(@"分享");
        
        }else if (index == 2){
            NSLog(@"评论");
            [_textField becomeFirstResponder];
        }else{
            _tableHeadView.frame = rect;
            _tableview.tableHeaderView = _tableHeadView;
            [_tableview reloadData];
        
        }
    }];
    _tableHeadView.backgroundColor = [UIColor whiteColor];
    _tableview.tableHeaderView = _tableHeadView;
    
    UIView *footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    footView.backgroundColor = [UIColor whiteColor];
    _tableview.tableFooterView = footView;
    
    
    [self bottomViewInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
         _bottomView.hidden = NO;
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
         _bottomView.hidden = YES;
    }];
}

- (void)bottomViewInit{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44 - 64, self.view.bounds.size.width, 44)];
    _bottomView.hidden = YES;
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    
    UIButton *videoButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
    [videoButton setImage:[UIImage imageNamed:@"videachat@2x"] forState:UIControlStateNormal];
    [_bottomView addSubview:videoButton];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(44, 5, 200, 34)];
    imageview.image = [UIImage imageNamed:@"sengbackground@2x"];
    [_bottomView addSubview:imageview];
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(46, 7, 196, 30)];
    _textField.placeholder = @"评论";
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeySend;
    _textField.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:_textField];
   
    
    UIButton *smailButton = [[UIButton alloc]initWithFrame:CGRectMake(250, 10, 24, 24)];
    [smailButton setImage:[UIImage imageNamed:@"smailchat@2x"] forState:UIControlStateNormal];
    [_bottomView addSubview:smailButton];
    
    
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(285, 10, 24, 24)];
    [addButton setImage:[UIImage imageNamed:@"addchat@2x"] forState:UIControlStateNormal];
    [_bottomView addSubview:addButton];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *text = [NSString stringWithFormat:@"%@：%@",[NSString stringWithFormat:@"小明%li",(long)indexPath.row],@"计算机房看 iu 热不过恢复进口大量果然很感慨如今如果听噶绿化饿计算机房看 iu 热不过恢复进口大量果然很感慨如今如果听噶绿化饿计算机房看 iu 热不过恢复进口"];
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(self.view.bounds.size.width - 45, MAXFLOAT)];
    
    return  size.height + 20;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier1 = @"statusCell";
    static NSString *cellIdentifier2 = @"statusCell2";
    XiangmupinglunTableViewCellLeft *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    XiangmuPinglunTableViewCell2 *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    if (indexPath.row%2 == 0) {
        if (cell == nil) {
            cell = [[XiangmupinglunTableViewCellLeft alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1 fromName:[NSString stringWithFormat:@"小明%li",(long)indexPath.row] content:@"计算机房看 iu 热不过恢复进口大量果然很感慨如今如果听噶绿化饿计算机房看 iu 热不过恢复进口大量果然很感慨如今如果听噶绿化饿计算机房看 iu 热不过恢复进口"];
            
        }else{
            [cell fromName:[NSString stringWithFormat:@"小明%li",(long)indexPath.row] content:@"计算机房看 iu 热不过恢复进口大量果然很感慨如今如果听噶绿化饿计算机房看 iu 热不过恢复进口大量果然很感慨如今如果听噶绿化饿计算机房看 iu 热不过恢复进口"];
            
        }
        if (indexPath.row == 0) {
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(19, 5, 15, 15)];
            imageview.image = [UIImage imageNamed:@"zhaobiaopinglun@2x"];
            [cell addSubview:imageview];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.textLabel.text = [NSString stringWithFormat:@"===%li",(long)indexPath.row];
        //cell.textLabel.textColor = [UIColor redColor];
        return cell;
    }else{
        if (cell1 == nil) {
            cell1 = [[XiangmuPinglunTableViewCell2 alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier2 fromName:[NSString stringWithFormat:@"小明%li",(long)indexPath.row]    toName:[NSString stringWithFormat:@"小狗%li",(long)indexPath.row]  content:@"计算机房看 iu 热不过恢复进口大量果然很感慨如今如果听噶绿化饿计算机房看 iu 热不过恢复进口大量果然很感慨如今如果听噶绿化饿计算机房看 iu 热不过恢复进口"];
            
        }else{
            [cell1 fromName:[NSString stringWithFormat:@"小明%li",(long)indexPath.row] toName:[NSString stringWithFormat:@"小狗%li",(long)indexPath.row] content:@"计算机房看 iu 热不过恢复进口大量果然很感慨如今如果听噶绿化饿计算机房看 iu 热不过恢复进口大量果然很感慨如今如果听噶绿化饿计算机房看 iu 热不过恢复进口"];
            
        }
        if (indexPath.row == 0) {
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(19, 5, 15, 15)];
            imageview.image = [UIImage imageNamed:@"zhaobiaopinglun@2x"];
            [cell addSubview:imageview];
        }
        
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.textLabel.text = [NSString stringWithFormat:@"===%li",(long)indexPath.row];
        //cell.textLabel.textColor = [UIColor redColor];
        return cell1;
    
    
    
    }
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       [_textField becomeFirstResponder];


}
#pragma mark - 代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
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

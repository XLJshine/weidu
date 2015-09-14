//
//  MimaChangeViewController.m
//  时时投
//
//  Created by 熊良军 on 15/8/17.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "MimaChangeViewController.h"
#import "MimaChangeTableViewCell.h"
@interface MimaChangeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic ,strong)NSArray *titleArray;
@property (nonatomic ,strong)NSMutableArray *detailArray;
@property (nonatomic ,strong)NSArray *backgroundImageArray;
@end

@implementation MimaChangeViewController{
    NSString *oldMima;
    NSString *newMima;
    NSString *newMimaAgain;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MimaChangeViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MimaChangeViewController"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backgrondview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beijing@2x"]];
    [self.view addSubview:backgrondview];
    
    [self data];//初始化数据
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.scrollEnabled = NO;
    [self.view addSubview:_tableview];
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    headview.backgroundColor = [UIColor clearColor];
    _tableview.tableHeaderView = headview;
    // Do any additional setup after loading the view.
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 190, self.view.bounds.size.width - 40, 40)];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    [button setTitle:@"修改密码" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:0.2667 green:0.6902 blue:0.9020 alpha:1]];
    [button addTarget:self action:@selector(changeMima) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)data{
    _titleArray = [NSArray arrayWithObjects:@"旧密码",
                   @"新密码",
                   @"重复新密码",
                   nil];
    /*_detailArray = [NSMutableArray arrayWithObjects:@"",
                    @"",
                    @"",
                    @"",
                    nil];*/
    _backgroundImageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"chaangtiao1@2x"],[UIImage imageNamed:@"chaangtiao2@2x"],[UIImage imageNamed:@"chaangtiao3@2x"], nil];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier1 = @"statusCell3";
    MimaChangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (cell == nil) {
        cell = [[MimaChangeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell title:[_titleArray objectAtIndex:indexPath.row] backgroundimage:[_backgroundImageArray objectAtIndex:indexPath.row]];
    cell.textField.tag = indexPath.row;
    [cell.textField addTarget:self action:@selector(changed:) forControlEvents:UIControlEventEditingChanged];
    cell.textField.delegate = self;
    
    return cell;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)changed:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
        {
            oldMima = textField.text;
        }
            break;
        case 1:
        {
            newMima = textField.text;
        }
            break;
        case 2:
        {
            newMimaAgain = textField.text;
        }
            break;
        default:
            break;
    }
}
- (void)changeMima{
    if ([newMima isEqualToString:newMimaAgain]) {
        NSLog(@"修改密码");
        NSString *urlStr = [NSString stringWithFormat:@"%@account/change-password?old=%@&new=%@&access-token=%@",ApiUrlHead,oldMima,newMima,_token];
        NSLog(@"urlStr = %@",urlStr);
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSDictionary * Data = [responseObject objectForKey:@"data"];
                NSLog(@"Data = %@",Data);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码修改成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"重复密码不一致" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];

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

//
//  YiJianViewController.m
//  时时投
//
//  Created by h on 15/8/26.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "YiJianViewController.h"
#import "DQBanBengViewController.h"
static YiJianViewController *instance;
@interface YiJianViewController ()<UITextViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (strong, nonatomic)__block NSMutableArray *DataArray;
@property(strong,nonatomic)UIAlertView*alter;
@end

@implementation YiJianViewController{
   AFHTTPRequestOperationManager *manager;
}
+ (id)shareInstanceWithToken:(NSString *)token uid:(NSString *)uid
{
    if (instance == nil)
    {
        instance = [[[self class]alloc]init];
    }
    instance.token = token;
    instance.uid = uid;
    
    return instance;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"YiJianViewController"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"YiJianViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"意见与反馈";
    _myTextView.delegate=self;
    _alter.delegate=self;
    manager = [AFHTTPRequestOperationManager manager];
   
    
    
    
}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }else{
//        return YES;
//    }
//}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
    return YES;
}
//点空白处收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)queDingBtn:(id)sender {
    if ([_myTextView.text isEqualToString:@""]) {
        _alter=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"意见不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        _alter.tag = 0;
        [_alter show];
        
        
    }else{
        
        NSString*textURl=[NSString stringWithFormat:@"%@service/feedback?access-token=%@",ApiUrlHead,_token];
         //NSString *encoded = [textURl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *_textDIC = @{@"content":_myTextView.text};
       
        NSLog(@"content=========%@",_textDIC);
       
        [manager POST:textURl parameters:_textDIC success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSLog(@"消息发送成功");
                
                _alter=[[UIAlertView alloc]initWithTitle:@"" message:@"意见发表成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                _alter.tag=1;
                [_alter show];
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                NSLog(@"error=%@",error);
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            
        }];
        
        
    
    
        }
    
 }
         
//alertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
    
    
}
         
@end

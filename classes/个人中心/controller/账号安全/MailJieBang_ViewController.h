//
//  MailJieBang_ViewController.h
//  时时投
//
//  Created by 熊良军 on 15/8/18.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailJieBang_ViewController : UIViewController
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;

@property (weak, nonatomic) IBOutlet UIButton *yanzhengmaButton;

@property (weak, nonatomic) IBOutlet UITextField *youxiangTextFeild;
- (IBAction)bangdingAction:(id)sender;

- (IBAction)HuoquYanzhengma:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengmaTextFeild;
@end

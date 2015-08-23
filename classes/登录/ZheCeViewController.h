//
//  ZheCeViewController.h
//  时时投
//
//  Created by h on 15/8/5.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZheCeViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *mima;
@property (weak, nonatomic) IBOutlet UITextField *mimaAgain;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengma;
@property (weak, nonatomic) IBOutlet UIButton *huoqueButton;
- (IBAction)huoquButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *tijiaoButton;
- (IBAction)tijiaobutton:(id)sender;
@end

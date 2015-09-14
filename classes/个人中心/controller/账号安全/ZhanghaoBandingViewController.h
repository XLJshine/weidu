//
//  ZhanghaoBandingViewController.h
//  时时投
//
//  Created by h on 15/8/12.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhanghaoBandingViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet UITextField *MimaAgaintextFeild;
@property (weak, nonatomic) IBOutlet UIImageView *MimaAgainImageView;

@property (weak, nonatomic) IBOutlet UITextField *MimaTextFeild;
@property (weak, nonatomic) IBOutlet UIImageView *MimaImageview;
@property (weak, nonatomic) IBOutlet UITextField *zhangHaoTextField;
@property (weak, nonatomic) IBOutlet UIButton *zhangHaoBangDingButton;
- (IBAction)zhangHaoBanDingButton:(id)sender;

@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;
@end

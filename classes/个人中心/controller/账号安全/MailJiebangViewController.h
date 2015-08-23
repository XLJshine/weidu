//
//  PhoneBangdingViewController.h
//  时时投
//
//  Created by h on 15/8/8.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailJiebangViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *PhoneNumTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *PhoneYanZhengMa;
@property (weak, nonatomic) IBOutlet UIButton *PhoneHuoquButton;
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;
- (IBAction)PhoneHuoquButton:(id)sender;
- (IBAction)PhoneBandingButton:(id)sender;
@end

//
//  PhoneViewController.h
//  时时投
//
//  Created by h on 15/7/23.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneViewController : UIViewController
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLable;
- (IBAction)exchangNum:(id)sender;
@property (nonatomic ,strong)NSString *phoneNum;
@property (weak, nonatomic) IBOutlet UIButton *jieBangPhoneBtn;
- (IBAction)jieBangPhoneBtn:(id)sender;
- (IBAction)jjieChuBangDingShouJIHao:(id)sender;

@end

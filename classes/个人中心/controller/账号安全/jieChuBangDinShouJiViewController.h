//
//  jieChuBangDinShouJiViewController.h
//  时时投
//
//  Created by h on 15/9/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h><UITextFieldDelegate>

@interface jieChuBangDinShouJiViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;
@property (nonatomic ,strong)NSString *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
- (IBAction)huoQueYZMBTn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *yanZhengMaText;
- (IBAction)jieBangShoJIBtn:(id)sender;
//获取验证码Btn
@property (weak, nonatomic) IBOutlet UIButton *PhoneJieChuBangDingBtn;
@end

//
//  JieChuBangDingYXViewController.h
//  时时投
//
//  Created by h on 15/9/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JieChuBangDingYXViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;

@property (nonatomic ,strong)NSString *youxiangNum;

@property (weak, nonatomic) IBOutlet UIButton *huoQuYZM;

- (IBAction)huoQuYZM:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *jieChuBD;
- (IBAction)jieChuBD:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *yanzhengMaText;
@property (weak, nonatomic) IBOutlet UILabel *youxiangJBLable;
@end

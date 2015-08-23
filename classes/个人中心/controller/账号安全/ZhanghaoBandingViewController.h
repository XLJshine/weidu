//
//  ZhanghaoBandingViewController.h
//  时时投
//
//  Created by h on 15/8/12.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhanghaoBandingViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *zhangHaoTextField;
@property (weak, nonatomic) IBOutlet UIButton *zhangHaoBangDingButton;
- (IBAction)zhangHaoBanDingButton:(id)sender;
@end

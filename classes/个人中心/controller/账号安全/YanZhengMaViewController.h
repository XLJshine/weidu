//
//  YanZhengMaViewController.h
//  时时投
//
//  Created by h on 15/7/27.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YanZhengMaViewController : UIViewController
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;
- (IBAction)shouBuDaoYanZhengMaButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textview;

@property (weak, nonatomic) IBOutlet UITextField *yanzhenmaText;
@property (weak, nonatomic) IBOutlet UILabel *theNewPhoneNum;
@property (nonatomic ,strong)NSString *phoneNum;

- (IBAction)tijiaoAction:(id)sender;

@end

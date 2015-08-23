//
//  ExchangePhoneNumViewController.h
//  时时投
//
//  Created by h on 15/7/23.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangePhoneNumViewController : UIViewController
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;
@property (nonatomic ,strong)NSString *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLable;
@property (weak, nonatomic) IBOutlet UITextField *theNewPhoneNum;

@end

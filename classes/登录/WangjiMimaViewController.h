//
//  WangjiMimaViewController.h
//  时时投
//
//  Created by h on 15/8/11.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WangjiMimaViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@property (weak, nonatomic) IBOutlet UITextField *NewMima;
@property (weak, nonatomic) IBOutlet UITextField *NewMimaAgain;
@property (weak, nonatomic) IBOutlet UITextField *YanZhengMa;
@property (weak, nonatomic) IBOutlet UIButton *HuoQuYanZhengMa;
- (IBAction)HuoQuYanZhengMa:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *TiJiao;

- (IBAction)TiJiao:(id)sender;
@end

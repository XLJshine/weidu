//
//  YouxiangBangdingViewController.h
//  时时投
//
//  Created by h on 15/8/8.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouxiangBangdingViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *shuruBeijIngTu;
@property (weak, nonatomic) IBOutlet UIImageView *zaiCiShuruBeijingTu;
@property (weak, nonatomic) IBOutlet UITextField *shezhiMimaText;
@property (weak, nonatomic) IBOutlet UITextField *zaiCiShuruText;
@property (weak, nonatomic) IBOutlet UILabel *rugouYouXiangLable;
@property (weak, nonatomic) IBOutlet UIButton *quedingBDbtn;
@property (weak, nonatomic) IBOutlet UITextField *YouXiangNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *youXiangHuoQuButton;
@property (weak, nonatomic) IBOutlet UITextField *yanzhenmaTextFeild;
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;
- (IBAction)youXiangHuoQuButton:(id)sender;
- (IBAction)youxiangBangDingButton:(id)sender;
@end

//
//  geRenViewController.h
//  时时投
//
//  Created by h on 15/8/6.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface geRenViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *zhangHaoLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
@property (weak, nonatomic) IBOutlet UILabel *QQlable;
- (IBAction)dongTaiButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
//@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *fangKeButton;
@property (weak, nonatomic) IBOutlet UIButton *xiaoXiButton;
@property (weak, nonatomic) IBOutlet UIButton *pingLunButton;
@property (weak, nonatomic) IBOutlet UIButton *sheZhiButton;
- (IBAction)LoginOut:(id)sender;

- (IBAction)fangKeButton:(id)sender;
- (IBAction)xiaoXiButton:(id)sender;
- (IBAction)pingLunButton:(id)sender;
- (IBAction)sheZhiButton:(id)sender;

@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;

+ (id)shareInstanceWithToken:(NSString *)token uid:(NSString *)uid;
@end

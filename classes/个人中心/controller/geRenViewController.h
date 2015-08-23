//
//  geRenViewController.h
//  时时投
//
//  Created by h on 15/8/6.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface geRenViewController : UIViewController
- (IBAction)dongTaiButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *fangKeButton;
@property (weak, nonatomic) IBOutlet UIButton *xiaoXiButton;
@property (weak, nonatomic) IBOutlet UIButton *pingLunButton;
@property (weak, nonatomic) IBOutlet UIButton *sheZhiButton;
- (IBAction)LoginOut:(id)sender;

- (IBAction)fangKeButton:(id)sender;
- (IBAction)xiaoXiButton:(id)sender;
- (IBAction)pingLunButton:(id)sender;
- (IBAction)sheZhiButton:(id)sender;
@end

//
//  YouXiangViewController.h
//  时时投
//
//  Created by h on 15/8/8.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouXiangViewController : UIViewController
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;
@property (nonatomic ,strong)NSString *youxiangNum;
@property (weak, nonatomic) IBOutlet UILabel *youxiangLable;

@property (weak, nonatomic) IBOutlet UIButton *jiechuBangding;
- (IBAction)jiechuBangding:(id)sender;
- (IBAction)xiuGaiBangdIng:(id)sender;
@end

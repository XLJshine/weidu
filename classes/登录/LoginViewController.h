//
//  LoginViewController.h
//  dayang
//
//  Created by h on 15/7/20.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"
@interface LoginViewController : UIViewController<EAIntroDelegate>
@property (nonatomic ,strong)NSString *ifLoginOut;
@end

//
//  HuoDongViewController.h
//  时时投
//
//  Created by h on 15/7/27.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HuoDongViewController : UIViewController
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;
+ (id)shareInstanceWithToken:(NSString *)token uid:(NSString *)uid;
@end

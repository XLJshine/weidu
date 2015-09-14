//
//  FangkeViewController.h
//  时时投
//
//  Created by h on 15/7/24.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FangkeViewController : UIViewController
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;

+ (id)shareInstanceWithToken:(NSString *)token uid:(NSString *)uid;
@end

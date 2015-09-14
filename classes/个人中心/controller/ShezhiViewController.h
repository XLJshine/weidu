//
//  ShezhiViewController.h
//  时时投
//
//  Created by 熊良军 on 15/7/23.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShezhiViewController : UIViewController
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;
+ (id)shareInstanceWithToken:(NSString *)token uid:(NSString *)uid;
@end

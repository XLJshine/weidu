//
//  DongTaiViewController.h
//  时时投
//
//  Created by h on 15/8/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DongTaiViewController : UIViewController

@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;

+ (id)shareInstanceWithToken:(NSString *)token uid:(NSString *)uid;
@end

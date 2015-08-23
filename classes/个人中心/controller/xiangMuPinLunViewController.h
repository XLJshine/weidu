//
//  xiangMuPinLunViewController.h
//  时时投
//
//  Created by h on 15/8/13.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xiangMuPinLunViewController : UIViewController
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;

+ (id)shareInstanceWithToken:(NSString *)token uid:(NSString *)uid;
@end

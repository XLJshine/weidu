//
//  ChatViewController.h
//  时时投
//
//  Created by 熊良军 on 15/8/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
@property (nonatomic ,strong)NSString  *token;
@property (nonatomic ,strong)NSString *uid;      //我的ID
@property (nonatomic ,strong)NSString *user_id;  //他的ID
@property (nonatomic ,strong)NSString *realname; //他的姓名
@end

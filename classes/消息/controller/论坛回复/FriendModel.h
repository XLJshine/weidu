//
//  FriendModel.h
//  时时投
//
//  Created by h on 15/7/29.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FriendModel : NSObject

@property (nonatomic,copy)NSString * messageText;
@property (nonatomic,copy)NSString * discussesText;

@property (nonatomic,assign)CGFloat messageHeight;
@property (nonatomic,assign)CGFloat discussesHeight;

@end

//
//  ShareView.h
//  乐邦美食
//
//  Created by jimmy on 15/6/16.
//  Copyright (c) 2015年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BlockButton)(NSInteger);
@interface ShareView : UIView
@property (nonatomic ,strong)BlockButton  block;
- (id)initWithFrame:(CGRect)frame  buttonBlock:(BlockButton)block;
@end

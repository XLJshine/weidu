//
//  PinglunReplyView.h
//  时时投
//
//  Created by 熊良军 on 15/9/8.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PinglunReplyView;
@protocol PinglunReplyViewDelegate <NSObject>
@optional
- (void)pinglunReplyView:(PinglunReplyView *)pinglunReplyView  buttonAtIndex:(NSInteger)index;
@end
@interface PinglunReplyView : UIView
- (instancetype)initWithFrame:(CGRect)frame firstName:(NSString *)firstName secondName:(NSString *)secondName content:(NSString *)content;
@property (nonatomic, strong) id<PinglunReplyViewDelegate>delegate;
@end

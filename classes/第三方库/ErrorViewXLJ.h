//
//  ErrorViewXLJ.h
//  时时投
//
//  Created by 熊良军 on 15/9/5.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef void(^ErrorViewBlock)(NSInteger);
@class ErrorViewXLJ;
@protocol ErrorViewXLJDelegate <NSObject>
@optional
- (void)errorView:(ErrorViewXLJ *)errorView  buttonAtIndex:(NSInteger)index;
@end
@interface ErrorViewXLJ : UIView
//@property (nonatomic ,strong)ErrorViewBlock block;
@property (nonatomic, strong) id<ErrorViewXLJDelegate>delegate;

@end

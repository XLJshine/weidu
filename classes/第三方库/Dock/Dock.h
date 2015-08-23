//
//  Dock.h
//  Created by xionglj on 14-10-10.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DockItem.h"
@class Dock;
@protocol DockDelegate <NSObject>
@optional
- (void)dock:(Dock *)dock itemSelectedFrom:(int)from to:(int)to;
@end


@interface Dock : UIView

//添加一个选项卡
- (void)addItemWithIcon:(NSString *)icon1  selectIcon:(NSString *)sIcon  title:(NSString *)title;
- (void)change:(DockItem *)item;
@property (nonatomic, strong) id<DockDelegate>delegate;

@end

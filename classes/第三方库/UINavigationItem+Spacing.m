//
//  UINavigationItem+Spacing.m
//  时时投
//
//  Created by 熊良军 on 15/8/6.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "UINavigationItem+Spacing.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UINavigationItem (Spacing)

// load 在初始化类时调用，每个类都有一个load 方法，
// 类的初始化先于对象
+(void)load
{
    //以下方法告诉系统用后面的方法替换前面的
    method_exchangeImplementations(
                                   class_getClassMethod(self, @selector(setLeftBarButtonItem:)),
                                   class_getClassMethod(self, @selector(mySetLeftBarButtonItem:)));
}


- (UIBarButtonItem *)spacer
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil action:nil];
    space.width = -10.0f;
    return space ;
}

-(void)mySetLeftBarButtonItem:(UIBarButtonItem*)barButton
{
    NSArray* barButtons = nil;
    barButtons = [NSArray arrayWithObjects: [self spacer], barButton,nil ];
    
    [self setLeftBarButtonItems: barButtons];
}


@end

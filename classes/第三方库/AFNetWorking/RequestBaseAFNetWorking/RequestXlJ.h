//
//  RequestXlJ.h
//  时时投
//
//  Created by 熊良军 on 15/8/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
typedef void(^Block)(NSInteger,NSString *,NSDictionary *,NSArray *);
@interface RequestXlJ : NSObject
//@property (nonatomic ,strong)NSDictionary *dic;
//@property (nonatomic ,strong)NSArray *array;
@property (nonatomic ,strong)__block Block  block;
- (void)requestWithUrlHead:(NSMutableString *)urlHead parameter:(NSArray *)paraArray  methed:(NSString *)get_or_Post  block:(Block)block;
- (void)requestWithUrl:(NSString *)urlStr methed:(NSString *)get_or_Post  block:(Block)block;

@end

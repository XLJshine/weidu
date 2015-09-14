//
//  NSArray+NSArrary_Safe.m
//  乐邦美食
//
//  Created by jimmy on 15/5/9.
//  Copyright (c) 2015年 jimmy. All rights reserved.
//

#import "NSArray+Safe.h"

@implementation NSArray (Safe)

- (id)objectAtSafeIndex:(NSInteger)index
{
    if ([self count] >= index+1) {
        return [self objectAtIndex:index];
    }
    return nil;
}

@end

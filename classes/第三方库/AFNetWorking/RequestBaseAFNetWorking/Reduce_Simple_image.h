//
//  Reduce_Simple_image.h
//  Lebang
//
//  Created by 熊良军 on 15/1/6.
//  Copyright (c) 2015年 熊良军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Reduce_Simple_image : NSObject
//压缩图片质量
+(UIImage *)reduceImage:(UIImage *)image percent:(float)percent;
//压缩图片尺寸
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
@end

//
//  DongTaiModel.m
//  时时投
//
//  Created by h on 15/8/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "DongTaiModel.h"

@implementation DongTaiModel

-(void)setXinxiStr:(NSString *)xinxiStr{
    _xinxiStr = xinxiStr;
    _xinxiLabelHeight = [_xinxiStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(210, 1000)].height;
    _xinxiImageViewHeight = _xinxiLabelHeight+10;
    //NSLog(@"_xinxiLabelHeight==%f,_xinxiImageViewHeight==%f",_xinxiLabelHeight,_xinxiImageViewHeight);
}

@end

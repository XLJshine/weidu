//
//  FriendModel.m
//  时时投
//
//  Created by h on 15/7/29.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "FriendModel.h"

@implementation FriendModel

-(void)setMessageText:(NSString *)messageText{
    _messageText = messageText;
    _messageHeight = [_messageText sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(244, CGFLOAT_MAX)].height;
}
-(void)setDiscussesText:(NSString *)discussesText{
    _discussesText = discussesText;
    _discussesHeight = [_discussesText sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(304, CGFLOAT_MAX)].height;
}
@end

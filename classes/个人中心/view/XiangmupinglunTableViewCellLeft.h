//
//  XiangmupinglunTableViewCell.h
//  时时投
//
//  Created by 熊良军 on 15/8/8.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LableXLJ.h"
@interface XiangmupinglunTableViewCellLeft : UITableViewCell
@property (nonatomic ,strong)LableXLJ *textLable;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  fromName:(NSString *)name1 content:(NSString *)content;
- (void)fromName:(NSString *)name1 content:(NSString *)content;
@end

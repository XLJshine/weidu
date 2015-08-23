//
//  XiaoXiCustomTableViewCell.h
//  dayang
//
//  Created by chendong on 15/7/20.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XiaoXiCustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *headMessageName;
@property (weak, nonatomic) IBOutlet UILabel *messageInfo;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

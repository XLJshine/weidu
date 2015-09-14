//
//  HuoDongTableViewCell.h
//  时时投
//
//  Created by h on 15/7/27.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HuoDongTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *endTime;

@property (weak, nonatomic) IBOutlet UILabel *beginTime;
@end

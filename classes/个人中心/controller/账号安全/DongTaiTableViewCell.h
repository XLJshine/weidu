//
//  DongTaiTableViewCell.h
//  时时投
//
//  Created by h on 15/8/7.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DongTaiModel.h"

@interface DongTaiTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *xinxiLabel;


@property (nonatomic,strong)DongTaiModel * model;

@end

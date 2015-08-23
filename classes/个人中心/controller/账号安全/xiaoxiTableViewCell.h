//
//  xiaoxiTableViewCell.h
//  时时投
//
//  Created by h on 15/8/6.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xiaoxiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Image;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *jieshao;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end

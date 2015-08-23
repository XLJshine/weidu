//
//  JiFenTableViewCell.h
//  时时投
//
//  Created by h on 15/7/25.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiFenTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shangPinImage;
@property (weak, nonatomic) IBOutlet UILabel *shangPinNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiFen;

@property (weak, nonatomic) IBOutlet UIButton *huanGouButton;
@end

//
//  LuntanTableViewCell.h
//  时时投
//
//  Created by h on 15/7/29.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"

@interface LuntanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companayLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *dropButton;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UIButton *fenxiangButton;
@property (weak, nonatomic) IBOutlet UIButton *pinglunButton;
@property (weak, nonatomic) IBOutlet UILabel *pinglunLabel;

@property (nonatomic,strong)FriendModel * model;

@end

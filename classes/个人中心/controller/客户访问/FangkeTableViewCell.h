//
//  FangkeTableViewCell.h
//  时时投
//
//  Created by h on 15/7/24.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FangkeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TimeLable;
@property (weak, nonatomic) IBOutlet UIImageView *touXiangImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *zhiWeiLable;
@property (weak, nonatomic) IBOutlet UILabel *gongSiLable;
@property (weak, nonatomic) IBOutlet UILabel *gongTongFriendLable;
@property (weak, nonatomic) IBOutlet UIImageView *renMaiImage;

@end

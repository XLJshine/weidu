//
//  RenmaiTuijianTableViewCell.h
//  时时投
//
//  Created by 熊良军 on 15/7/29.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RenmaiTuijianTableViewCell;
@protocol RenmaiTuijianTableViewCellDelegate <NSObject>
@optional
- (void)TuijiantableViewCell:(RenmaiTuijianTableViewCell *)cell  index:(NSInteger)index;
@end
@interface RenmaiTuijianTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gongsi;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *zhiwu;
@property (weak, nonatomic) IBOutlet UILabel *haoyouNum;
@property (weak, nonatomic) IBOutlet UILabel *jifenNum;
@property (weak, nonatomic) IBOutlet UILabel *meiliNum;
@property (weak, nonatomic) IBOutlet UILabel *shoucangNum;
@property (weak, nonatomic) IBOutlet UILabel *userDetail;
@property (strong, nonatomic)UIButton *tianjiaButton;
@property (weak, nonatomic) IBOutlet UIView *backgroundview;
@property (nonatomic, strong) id<RenmaiTuijianTableViewCellDelegate>delegate;
- (void)addButton:(NSInteger)tag;
@end

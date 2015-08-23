//
//  RenmaiTongxunTableViewCell.h
//  时时投
//
//  Created by 熊良军 on 15/7/29.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RenmaiTongxunTableViewCell;
@protocol RenmaiTongxunTableViewCellDelegate <NSObject>
@optional
- (void)TongxuntableViewCell:(RenmaiTongxunTableViewCell *)cell  index:(NSInteger)index;
@end
@interface RenmaiTongxunTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *resource;
@property (strong, nonatomic)UIButton *tianjiaButton;
@property (nonatomic, strong) id<RenmaiTongxunTableViewCellDelegate>delegate;
- (void)addButton:(NSInteger)tag;
@end

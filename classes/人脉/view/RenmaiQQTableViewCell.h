//
//  RenmaiQQTableViewCell.h
//  时时投
//
//  Created by 熊良军 on 15/7/29.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RenmaiQQTableViewCell;
@protocol RenmaiQQTableViewCellDelegate <NSObject>
@optional
- (void)QQtableViewCell:(RenmaiQQTableViewCell *)cell  index:(NSInteger)index;
@end
@interface RenmaiQQTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *resource;

@property (strong, nonatomic)UIButton *tianjiaButton;
@property (nonatomic, strong) id<RenmaiQQTableViewCellDelegate>delegate;
- (void)addButton:(NSInteger)tag;
@end

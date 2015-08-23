//
//  ChooseViewTableViewCell.h
//  时时投
//
//  Created by 熊良军 on 15/8/19.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseViewCellButton.h"
typedef void(^blockCellSelect)(NSInteger,NSInteger);
@interface ChooseViewTableViewCell : UITableViewCell
@property (nonatomic ,strong)ChooseViewCellButton *cellButton;
@property (nonatomic ,strong)blockCellSelect  block;
- (void)colorBool:(NSString *)colorBool indexPath:(NSInteger)indexpath block:(blockCellSelect)block;
@end

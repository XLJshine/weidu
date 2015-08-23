//
//  ShezhiTableViewCell.h
//  时时投
//
//  Created by 熊良军 on 15/7/23.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShezhiTableViewCell : UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  image:(UIImage *)image title:(NSString *)title1  backgroundimage:(UIImage *)backgroundimage1;
- (void)image:(UIImage *)image title:(NSString *)title1   backgroundimage:(UIImage *)backgroundimage1;
@end

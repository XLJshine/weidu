//
//  ZhanghaoSafeTableViewCell.h
//  时时投
//
//  Created by 熊良军 on 15/7/23.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhanghaoSafeTableViewCell : UITableViewCell
@property (nonatomic ,strong)UILabel *title;
@property (nonatomic ,strong)UILabel *detailtitle;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title1  detail:(NSString *)detail backgroundimage:(UIImage *)backgroundimage1;
- (void)title:(NSString *)title1 detail:(NSString *)detail backgroundimage:(UIImage *)backgroundimage1;
@end

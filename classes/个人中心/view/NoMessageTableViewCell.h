//
//  NoMessageTableViewCell.h
//  时时投
//
//  Created by 熊良军 on 15/7/24.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoMessageTableViewCell : UITableViewCell
@property (nonatomic ,strong)UILabel *title;
@property (nonatomic ,strong)UILabel *detailtitle;
@property (nonatomic,strong)UIImageView *chooseImage;
@property (nonatomic,strong)UIImageView *chooseImage1;
@property (nonatomic,assign)int indexNum;
@property (nonatomic,assign)int messageNum;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title1  detail:(NSString *)detail backgroundimage:(UIImage *)backgroundimage1 indexRow:(int)indexNum  messageNum:(NSString *)messageNum;
- (void)title:(NSString *)title1 detail:(NSString *)detail backgroundimage:(UIImage *)backgroundimage1 indexRow:(int)indexNum  messageNum:(NSString *)messageNum;
@end

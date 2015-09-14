//
//  PinglunTableViewCell.h
//  时时投
//
//  Created by 熊良军 on 15/8/13.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZanButton.h"
@interface PinglunTableViewCell : UITableViewCell
typedef void(^BlockButtonAction)(NSInteger);
@property(nonatomic ,strong)UIImageView *userImageView;
@property(nonatomic ,strong)UILabel *userNameLable;
@property(nonatomic ,strong)UILabel *detailLable;
@property(nonatomic ,strong)UILabel *timeLable;
@property (nonatomic ,strong)ZanButton *zanbtn;
@property (nonatomic ,strong)NSMutableArray *childArray;
@property (nonatomic ,strong)__block UILabel *addOneLable;
@property (nonatomic ,strong)__block  BlockButtonAction  block;
- (void)hideAddOneLable;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier userImage:(NSString *)imgUrl username:(NSString *)userName content:(NSString *)content time:(NSString *)time buttonBlock:(BlockButtonAction)block;
- (void)userImage:(NSString *)imgUrl username:(NSString *)userName content:(NSString *)content time:(NSString *)time buttonBlock:(BlockButtonAction)block;
@end

//
//  ChoosePicView.h
//  时时投
//
//  Created by 熊良军 on 15/7/23.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+MJWebCache.h"
typedef void(^BlockImage)(NSInteger);
typedef void(^BlockButton)(NSInteger);
@interface ChoosePicView : UIView
@property (nonatomic ,strong)UIImageView *imageview;
@property (nonatomic ,strong)UIButton *downloadButton;
@property (nonatomic ,strong)BlockButton  block;
@property (nonatomic ,strong)BlockImage  block1;
- (id)initWithFrame:(CGRect)frame  imageview:(NSString *)imagename viewtag:(NSInteger)tag  buttonBlock:(BlockButton)block BlockImage:(BlockImage)block1;
@end

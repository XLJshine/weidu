//
//  PinglunTableView.h
//  时时投
//
//  Created by 熊良军 on 15/8/13.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BlockCellSelect)(NSInteger);
@interface PinglunTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)__block BlockCellSelect  block;
@property (nonatomic ,strong)NSMutableArray * array;
@property (nonatomic ,strong)NSString *toubiaoID;
- (id)initWithFrame:(CGRect)frame toubiaoID:(NSString *)ID block:(BlockCellSelect)block;
- (void)toubiaoID:(NSString *)ID;

@end

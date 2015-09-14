//
//  PinglunTableView.h
//  时时投
//
//  Created by 熊良军 on 15/8/13.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinglunReplyView.h"
typedef void(^BlockCellSelect)(NSInteger,NSString *,NSString *,NSInteger);
@interface PinglunTableView : UITableView<UITableViewDataSource,UITableViewDelegate,PinglunReplyViewDelegate>
@property (nonatomic ,strong)__block BlockCellSelect  block;
@property (nonatomic ,strong)NSMutableArray * array;
@property (nonatomic ,strong)NSString *toubiaoID;
@property (nonatomic ,strong)NSString *token;
@property (strong, nonatomic)NSMutableArray *zanedNumArray;    //是否已经赞过
@property (strong, nonatomic)NSMutableArray *zanNumArray;    //赞的个数数组
- (id)initWithFrame:(CGRect)frame toubiaoID:(NSString *)ID token:(NSString *)token block:(BlockCellSelect)block;
- (void)toubiaoID:(NSString *)ID;

@end

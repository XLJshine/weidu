//
//  ChooseViewfirstTableView.h
//  时时投
//
//  Created by 熊良军 on 15/8/19.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BlockCellSelect)(NSInteger);

@interface ChooseViewfirstTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)BlockCellSelect  block;
@property (nonatomic ,strong)NSMutableArray * array;
- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)array  block:(BlockCellSelect)block;
- (void)tableReloadData:(NSArray *)titleArray  frame:(CGRect)rect block:(BlockCellSelect)block;  //刷新tableview的位置，数据
@end

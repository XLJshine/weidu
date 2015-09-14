//
//  TradetableView.h
//  时时投
//
//  Created by 熊良军 on 15/8/24.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BlockTradeCellSelect)(NSInteger);
@interface TradetableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)BlockTradeCellSelect  block;
@property (nonatomic ,strong)NSMutableArray * array;
- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)array  block:(BlockTradeCellSelect)block;
- (void)tableReloadData:(NSArray *)titleArray  frame:(CGRect)rect block:(BlockTradeCellSelect)block;  //刷新tableview的位置，数据
@end

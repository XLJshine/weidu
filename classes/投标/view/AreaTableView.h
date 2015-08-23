//
//  AreaTableView.h
//  时时投
//
//  Created by 熊良军 on 15/8/21.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AreaBlockCellSelect)(NSInteger);
@interface AreaTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)AreaBlockCellSelect  block;
@property (nonatomic ,strong)NSMutableArray * array;
@property (nonatomic ,strong)NSMutableArray * colorArray;
- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)array  colorArray:(NSArray *)colorArray block:(AreaBlockCellSelect)block;
- (void)tableReloadData:(NSArray *)titleArray    colorArray:(NSArray *)colorArray;  //刷新tableview的位置，数据
@end

//
//  ChooseViewsecondTableView.h
//  时时投
//
//  Created by 熊良军 on 15/8/19.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^blockCellSelect)(NSInteger,NSInteger);

@interface ChooseViewsecondTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)blockCellSelect  block;
@property (nonatomic ,strong)NSMutableArray * array;
@property (nonatomic ,strong)NSMutableArray * selectArray;
- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)array  selectArray:(NSArray *)selectArray  block:(blockCellSelect)block;
- (void)tableReloadData:(NSArray *)titleArray selectArray:(NSArray *)selectArray  block:(blockCellSelect)block;  //刷新tableview的位置，数据
- (void)tableReloadData:(NSArray *)titleArray selectArray:(NSArray *)selectArray;
@end

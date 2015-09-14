//
//  MyChooseTableView.h
//  时时投
//
//  Created by 熊良军 on 15/8/25.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BlockChooseCellSelect)(NSInteger);
@interface MyChooseTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)BlockChooseCellSelect  block;
@property (nonatomic ,strong)NSMutableArray * array;
@property (nonatomic ,strong)NSString * token;
- (id)initWithFrame:(CGRect)frame token:(NSString *)token  block:(BlockChooseCellSelect)block;
- (void)tableReloadData:(NSArray *)titleArray  frame:(CGRect)rect block:(BlockChooseCellSelect)block;  //刷新tableview的位置，数据

@end

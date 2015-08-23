//
//  ChooseViewsecondTableView.m
//  时时投
//
//  Created by 熊良军 on 15/8/19.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "ChooseViewsecondTableView.h"
#import "ChooseViewTableViewCell.h"
@implementation ChooseViewsecondTableView
- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)array  selectArray:(NSArray *)selectArray  block:(blockCellSelect)block{
    if (self) {
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor whiteColor];
        _block = block;
        _array = [NSMutableArray arrayWithArray:array];
        _selectArray =  [NSMutableArray arrayWithArray:selectArray];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
    }
    
    return self;
}
- (void)tableReloadData:(NSArray *)titleArray selectArray:(NSArray *)selectArray  block:(blockCellSelect)block{
    //self.frame = rect;
    [_array removeAllObjects];
    [_array addObjectsFromArray:titleArray];
    [_selectArray removeAllObjects];
    [_selectArray addObjectsFromArray:selectArray];
    self.dataSource = self;
    self.delegate = self;
    _block = block;
    [self reloadData];
}
- (void)tableReloadData:(NSArray *)titleArray selectArray:(NSArray *)selectArray{
    [_array removeAllObjects];
    [_array addObjectsFromArray:titleArray];
    [_selectArray removeAllObjects];
    [_selectArray addObjectsFromArray:selectArray];
    self.dataSource = self;
    self.delegate = self;
  
    [self reloadData];

}
#pragma mark ----- tableview分割线从顶点开始
//******tableview分割线从顶点开始********************
-(void)viewDidLayoutSubviews
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
//******tableview分割线********************
#pragma mark -tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 33;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier1 = @"statusCell1";
    ChooseViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (cell == nil) {
        cell = [[ChooseViewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
    }
    cell.cellButton.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell colorBool:[_selectArray objectAtIndex:indexPath.row]  indexPath:indexPath.row block:^(NSInteger num,NSInteger index){
        NSLog(@"index = %li",(long)index);
        //如果index等于1，按钮选中；否则，非选中
         _block(index,num);
    
    }];
    [cell.cellButton setTitle:[_array objectAtIndex:indexPath.row] forState:UIControlStateNormal];
     [cell.cellButton setTitle:[_array objectAtIndex:indexPath.row] forState:UIControlStateSelected];
     cell.cellButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

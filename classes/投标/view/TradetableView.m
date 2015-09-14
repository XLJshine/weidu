//
//  TradetableView.m
//  时时投
//
//  Created by 熊良军 on 15/8/24.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "TradetableView.h"

@implementation TradetableView

- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)array  block:(BlockTradeCellSelect)block{
    if (self) {
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor whiteColor];
        _block = block;
        _array = [NSMutableArray arrayWithArray:array];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
        
    }
    return self;
}
- (void)tableReloadData:(NSArray *)titleArray  frame:(CGRect)rect   block:(BlockTradeCellSelect)block{
    //self.frame = rect;
    [_array removeAllObjects];
    [_array addObjectsFromArray:titleArray];
    self.dataSource = self;
    self.delegate = self;
    _block = block;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,320 - 135, 33)];
    view.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = view;
    cell.textLabel.text = [_array objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    _block(indexPath.row);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  PinglunTableView.m
//  时时投
//
//  Created by 熊良军 on 15/8/13.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "PinglunTableView.h"
#import "PinglunTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "TimeXLJ.h"
#import "MJRefresh.h"
#import "MJChiBaoZiFooter.h"
@implementation PinglunTableView{
     AFHTTPRequestOperationManager *manager;
    NSInteger pageNum;
    
}

- (id)initWithFrame:(CGRect)frame toubiaoID:(NSString *)ID  block:(BlockCellSelect)block{
    if (self) {
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc]init];
        self.tableFooterView = view;
        pageNum = 1;
        _block = block;
        _toubiaoID = ID;
        self.dataSource = self;
        self.delegate = self;
        _array = [NSMutableArray array];
        //self.separatorStyle = UITableViewCellSeparatorStyleNone;
        NSString *urlStr = [NSString stringWithFormat:@"%@article/comments?aid=%@&page=1&psize=10",ApiUrlHead,_toubiaoID];
        manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSArray *arr = [responseObject objectForKey:@"data"];
                [_array addObjectsFromArray:arr];
                 [self reloadData];
                _block(-1);   //回调block显示评论列表
               
            }else if (![code isEqualToString:@"0"]){
               
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            
        }];
        
        
       
        
        //上拉刷新
        /*_tableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
         // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         // 结束刷新
         [_tableview.footer endRefreshing];
         });
         }];*/
         MJChiBaoZiFooter *footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.refreshingTitleHidden = YES;
        //设置footer
        self.footer = footer;

        
    }
    return self;
}

- (void)loadMoreData{
    // 1.添加假数据
    
    pageNum ++;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@article/comments?aid=%@&page=%li&psize=10",ApiUrlHead,_toubiaoID,(long)pageNum];
    //manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            if (arr.count == 0) {
                NSLog(@"没有更多数据了");
                
            }else if (0<arr.count&&arr.count < 10){
               
            }
            [_array addObjectsFromArray:arr];
            [self reloadData];
        
        }else if (![code isEqualToString:@"0"]){
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //[self reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.footer endRefreshing];
    });
}

- (void)titleArray:(NSArray *)array  block:(BlockCellSelect)block{
    _block = block;
    _array = [NSMutableArray arrayWithArray:array];
    [self reloadData];
}

- (void)toubiaoID:(NSString *)ID{
    self.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc]init];
    self.tableFooterView = view;

    _toubiaoID = ID;
    self.dataSource = self;
    self.delegate = self;
    [_array removeAllObjects];
    //self.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString *urlStr = [NSString stringWithFormat:@"%@article/comments?aid=%@&page=1&psize=10",ApiUrlHead,_toubiaoID];
    //manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            [_array addObjectsFromArray:arr];
            [self reloadData];
        }else if (![code isEqualToString:@"0"]){
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];
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
    NSString *content = [[_array objectAtIndex:indexPath.row] objectForKey:@"cont"];
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake( self.bounds.size.width - 57 - 10, MAXFLOAT)];
    
    return size.height + 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier1 = @"statusCell1";
    PinglunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (cell == nil) {
        cell = [[PinglunTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
    }
    
    [cell userImage:[[[_array objectAtIndex:indexPath.row] objectForKey:@"uinfo"] objectForKey:@"headpic"]
               username:[[[_array objectAtIndex:indexPath.row] objectForKey:@"uinfo"] objectForKey:@"realname"]
                content:[[_array objectAtIndex:indexPath.row] objectForKey:@"cont"]
                   time:[TimeXLJ returnUploadTime:[NSString stringWithFormat:@"%@",[[_array objectAtIndex:indexPath.row] objectForKey:@"ptime"]]]
        buttonBlock:^(NSInteger index){
                       
                       
                       
                   }];
    
    cell.userImageView.userInteractionEnabled = YES;
    cell.userImageView.tag = indexPath.row;
    [cell.userImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImageSelect:)]];
    
    return cell;
}
- (void)ImageSelect:(UITapGestureRecognizer *)tap{
    NSLog(@"tap.view.tag--%li",(long)tap.view.tag);
    _block(tap.view.tag);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //_block(indexPath.row);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

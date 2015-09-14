//
//  MyChooseTableView.m
//  时时投
//
//  Created by 熊良军 on 15/8/25.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "MyChooseTableView.h"
#import "MyChooseTableViewCell.h"
@implementation MyChooseTableView{
    AFHTTPRequestOperationManager *manager;
    NSInteger num;
}
- (id)initWithFrame:(CGRect)frame token:(NSString *)token  block:(BlockChooseCellSelect)block{
    if (self) {
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor whiteColor];
        _block = block;
        _array = [NSMutableArray array];
        _token = token;
        manager = [AFHTTPRequestOperationManager manager];
        NSString *myChoose = [NSString stringWithFormat:@"%@filter/list?access-token=%@",ApiUrlHead,_token];
        [manager GET:myChoose parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSArray *data = [responseObject objectForKey:@"data"];
                [_array removeAllObjects];
                [_array addObjectsFromArray:data];
                [self reloadData];
                
            }else if (![code isEqualToString:@"0"]){
                NSString *error = [responseObject objectForKey:@"err"];
                NSLog(@"error=%@",error);
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            
        }];

        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
       
    }
    return self;
}
- (void)tableReloadData:(NSArray *)titleArray  frame:(CGRect)rect   block:(BlockChooseCellSelect)block{
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
    MyChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (cell == nil) {
        cell = [[MyChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
    }
   
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[_array objectAtIndex:indexPath.row] objectForKey:@"title"]];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    
    
    
    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    cell.deleteButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [cell.deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cell.deleteButton addTarget:self action:@selector(deleteStore:) forControlEvents:UIControlEventTouchUpInside];
   
    
    return cell;
}
- (void)deleteStore:(UIButton *)button{
    NSLog(@"tag = %li",(long)button.tag);
     NSString *urlStr =[NSString stringWithFormat:@"%@filter/del?id=%@&access-token=%@",ApiUrlHead,[[_array objectAtIndex:button.tag] objectForKey:@"id"],_token];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSString *myChoose = [NSString stringWithFormat:@"%@filter/list?access-token=%@",ApiUrlHead,_token];
            [manager GET:myChoose parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                if ([code isEqualToString:@"0"]) {
                    NSArray *data = [responseObject objectForKey:@"data"];
                    [_array removeAllObjects];
                    [_array addObjectsFromArray:data];
                    [self reloadData];
                }else if (![code isEqualToString:@"0"]){
                    NSString *error = [responseObject objectForKey:@"err"];
                    NSLog(@"error=%@",error);
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                
            }];
        
        }else if (![code isEqualToString:@"0"]){
            NSString *error = [responseObject objectForKey:@"err"];
            NSLog(@"error=%@",error);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];

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

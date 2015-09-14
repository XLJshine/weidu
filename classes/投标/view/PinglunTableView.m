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
    MJChiBaoZiFooter *footer;
}

- (id)initWithFrame:(CGRect)frame toubiaoID:(NSString *)ID token:(NSString *)token block:(BlockCellSelect)block{
    if (self) {
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc]init];
        self.tableFooterView = view;
        pageNum = 1;
        _block = block;
        _toubiaoID = ID;
        _token = token;
        self.dataSource = self;
        self.delegate = self;
        _array = [NSMutableArray array];
        //赞的数量
        _zanNumArray = [NSMutableArray array];
        //是否赞过
       _zanedNumArray = [NSMutableArray array];
        
       
        //self.separatorStyle = UITableViewCellSeparatorStyleNone;
        NSString *urlStr = [NSString stringWithFormat:@"%@article/comments?aid=%@&page=1&psize=10&access-token=%@",ApiUrlHead,_toubiaoID,_token];
        NSLog(@"urlStr = %@",urlStr);
        manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
            if ([code isEqualToString:@"0"]) {
                NSArray *arr = [responseObject objectForKey:@"data"];
                [_array addObjectsFromArray:arr];
                for (int i  = 0; i < arr.count; i ++) {
                    [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zans"]]];
                    NSString *zaned11  = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zaned"]];
                    if ([zaned11 isEqualToString:@"1"]) {
                        [_zanedNumArray addObject:@"1"];
                    }else{
                        [_zanedNumArray addObject:@"0"];
                    }
                }
                NSLog(@"_array = %@",_array);
             
                 [self reloadData];
                _block(-1,nil,nil,nil);   //回调block显示评论列表
               
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
        footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.refreshingTitleHidden = YES;
        //设置footer
        //self.footer = footer;

        
    }
    return self;
}

- (void)loadMoreData{
    // 1.添加假数据
    
    pageNum ++;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@article/comments?aid=%@&page=%li&psize=10&access-token=%@",ApiUrlHead,_toubiaoID,(long)pageNum,_token];
    NSLog(@"urlStr = %@",urlStr);
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
            
            for (int i  = 0; i < arr.count; i ++) {
                [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zans"]]];
                NSString *zaned11  = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zaned"]];
                if ([zaned11 isEqualToString:@"1"]) {
                    [_zanedNumArray addObject:@"1"];
                }else{
                    [_zanedNumArray addObject:@"0"];
                }
            }
            NSLog(@"_array = %@",_array);
            [self reloadData];
        
        }else if (![code isEqualToString:@"0"]){
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        //网络不佳视图
        InterNetError *errorView = [[InterNetError alloc]initWithFrame:CGRectMake(90, self.bounds.size.height * 0.75, self.bounds.size.width - 180, 25)];
        [self addSubview:errorView];
        
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
    [_zanedNumArray removeAllObjects];
    [_zanNumArray removeAllObjects];
    //self.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString *urlStr = [NSString stringWithFormat:@"%@article/comments?aid=%@&page=1&psize=10&access-token=%@",ApiUrlHead,_toubiaoID,_token];
    NSLog(@"urlStr = %@",urlStr);
    //manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            [_array addObjectsFromArray:arr];
            for (int i  = 0; i < arr.count; i ++) {
                [_zanNumArray addObject:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zans"]]];
                NSString *zaned11  = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"zaned"]];
                if ([zaned11 isEqualToString:@"1"]) {
                    [_zanedNumArray addObject:@"1"];
                }else{
                    [_zanedNumArray addObject:@"0"];
                }
            }
            //NSLog(@"_zanedNumArray = %@",_zanedNumArray);
            [self reloadData];
            
            
            
            if (arr.count > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
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
    NSArray *array = [[_array objectAtIndex:indexPath.row] objectForKey:@"childs"];
    int H = 0;
    CGSize size;
    NSString *content2 = [[_array objectAtIndex:indexPath.row] objectForKey:@"cont"];
    size = [content2 sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake( self.bounds.size.width - 57 - 50, MAXFLOAT)];
    if (array.count > 0) {
        
        for (int i = 0; i < array.count; i++) {
            //评论的回复
            NSString *cont = [[array objectAtIndex:i] objectForKey:@"cont"];
            NSString *ch_content4 = [cont stringByRemovingPercentEncoding];
            CGSize size3 = [ch_content4 sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(250, MAXFLOAT)];
          
            NSLog(@"H = %i",H);
           
            H = H + size3.height + 21;
        }
    }
    
    return H + size.height + 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier1 = @"statusCell1";
    PinglunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (cell == nil) {
        cell = [[PinglunTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //移除view重新加载
    NSArray *subViewArr = cell.contentView.subviews;
    for (UIView *view in subViewArr) {
        if (![view isEqual:cell.addOneLable]) {
            [view removeFromSuperview];
        }
    }
    
    
    NSString *userImageUrl = [NSString string];
    NSString *userName = [NSString string];
    NSString *nm = [NSString stringWithFormat:@"%@",[[_array objectAtIndex:indexPath.row] objectForKey:@"nm"]];
    if ([nm isEqualToString:@"0"]) {
        userImageUrl = [NSString stringWithFormat:@"%@",[[[_array objectAtIndex:indexPath.row] objectForKey:@"uinfo"] objectForKey:@"headpic"]];
        userName = [[[_array objectAtIndex:indexPath.row] objectForKey:@"uinfo"] objectForKey:@"realname"];
    }else{
       userImageUrl = nil;
       userName = @"匿名";
    }
   
    NSString *reply_uname = [[_array objectAtIndex:indexPath.row] objectForKey:@"reply_uname"];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]init];
    NSString *conten = [[_array objectAtIndex:indexPath.row] objectForKey:@"cont"];
    NSString *content1 = [conten stringByRemovingPercentEncoding];
    if (reply_uname.length > 0) {
        NSString *str1 = [NSString stringWithFormat:@"回复%@：%@",reply_uname,content1];
        content = [[NSMutableAttributedString alloc] initWithString:str1];
        [content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.5 alpha:1] range:NSMakeRange(0,reply_uname.length + 3)];
      
    }else{
        content = [[NSMutableAttributedString alloc] initWithString:content1];
    }
    
    userName = [userName stringByRemovingPercentEncoding];
    
    [cell userImage:userImageUrl
               username:userName
                content:content
                   time:[TimeXLJ returnUploadTime_no1970:[NSString stringWithFormat:@"%@",[[_array objectAtIndex:indexPath.row] objectForKey:@"ptime"]]]
        buttonBlock:^(NSInteger index){
            NSLog(@"index = %li",(long)index);
            NSString *str = [_zanedNumArray objectAtIndex:index];
            if ([str isEqualToString:@"1"]) {
                NSLog(@"取消点赞");
                NSString *zanNum1 = [_zanNumArray objectAtIndex:indexPath.row];
                int zannum = [zanNum1 intValue];
                zannum --;
                [cell.zanbtn setImage:[UIImage imageNamed:@"zhaobiaozan@2x"] forState:UIControlStateNormal];
                [cell.zanbtn setTitle:[NSString stringWithFormat:@"%i",zannum] forState:UIControlStateNormal];
                //取消点赞
                NSString *urlStr = [NSString stringWithFormat:@"%@zan/comment-cancel?id=%@&access-token=%@",ApiUrlHead,[NSString stringWithFormat:@"%@",[[_array objectAtIndex:indexPath.row] objectForKey:@"id"]],_token];
                NSLog(@"urlStr = %@",urlStr);
                NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [manager GET:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                    NSString *err = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"err"]];
                    if ([code isEqualToString:@"0"]) {
                        NSLog(@"取消点赞成功！");
                        [_zanedNumArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
                        [_zanNumArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%i",zannum]]];
                      
                        
                    }else if (![code isEqualToString:@"0"]){
                        NSLog(@"err = %@",err);
                        
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    
                    
                }];
                
                
            }else{
                [cell.zanbtn setImage:[UIImage imageNamed:@"zaned_Img@2x"] forState:UIControlStateNormal];
                NSString *zanednum = [_zanedNumArray objectAtIndex:indexPath.row];
                if (![zanednum isEqualToString:@"1"]) {
                    cell.addOneLable.alpha = 1;
                    [cell hideAddOneLable];
                }
                
                NSString *zannumStr = [_zanNumArray objectAtIndex:indexPath.row];
                __block int zannum = [zannumStr intValue];
                zannum ++;
                NSLog(@"zannum = %i",zannum);
                [_zanedNumArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
                [_zanNumArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%i",zannum]];
                [cell.zanbtn setTitle:[NSString stringWithFormat:@"%i",zannum] forState:UIControlStateNormal];
                //点赞
                NSString *urlStr = [NSString stringWithFormat:@"%@zan/comment?id=%@&access-token=%@",ApiUrlHead,[NSString stringWithFormat:@"%@",[[_array objectAtIndex:index] objectForKey:@"id"]],_token];
                NSLog(@"urlStr = %@",urlStr);
                NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [manager GET:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                    NSString *err = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"err"]];
                    if ([code isEqualToString:@"0"]) {
                        NSLog(@"点赞成功！");
                        
                    }else if (![code isEqualToString:@"0"]){
                        NSLog(@"err = %@",err);
                        
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    
                    
                }];
                
            }
                       
                   }];
    
    
    
    
    cell.userImageView.userInteractionEnabled = YES;
    cell.userImageView.tag = indexPath.row;
    [cell.userImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImageSelect:)]];
    
    cell.detailLable.userInteractionEnabled = YES;
    cell.detailLable.tag = indexPath.row;
    [cell.detailLable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyTheMain:)]];
    
    cell.zanbtn.tag = indexPath.row;
   [cell.zanbtn setTitle:[_zanNumArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    NSString *zaned = [_zanedNumArray objectAtIndex:indexPath.row];
    if ([zaned isEqualToString:@"1"]) {
       [cell.zanbtn setImage:[UIImage imageNamed:@"zaned_Img@2x"] forState:UIControlStateNormal];
    }else{
       [cell.zanbtn setImage:[UIImage imageNamed:@"zhaobiaozan@2x"] forState:UIControlStateNormal];
    }
    
    [cell.childArray removeAllObjects];
    [cell.childArray addObjectsFromArray:[[_array objectAtIndex:indexPath.row] objectForKey:@"childs"]];
    NSLog(@"cell.childArray = %@",cell.childArray);
    
    if (cell.childArray.count > 0) {
        int H = 0;
        for (int i = 0; i < cell.childArray.count; i++) {
            //评论的回复
            NSString *content2 = [[_array objectAtIndex:indexPath.row] objectForKey:@"cont"];
            CGSize size = [content2 sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake( self.bounds.size.width - 57 - 50, MAXFLOAT)];
            
            
            
            NSString *cont = [[cell.childArray objectAtIndex:i] objectForKey:@"cont"];
            NSString *ch_content4 = [cont stringByRemovingPercentEncoding];
            CGSize size3 = [ch_content4 sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(250, MAXFLOAT)];
            NSString *nameFrom = [[[cell.childArray objectAtIndex:i] objectForKey:@"uinfo"] objectForKey:@"realname"];
            NSString *nameTo = [[cell.childArray objectAtIndex:i] objectForKey:@"reply_uname"];
            //NSLog(@"H = %i",H);
            PinglunReplyView *pingView = [[PinglunReplyView alloc]initWithFrame:CGRectMake(50, H + size.height + 60 + 5, 250, size3.height + 12) firstName:nameFrom secondName:nameTo content:ch_content4];
            pingView.tag = i;
            pingView.delegate = self;
            [cell.contentView addSubview:pingView];
            H = H + size3.height + 21;
        }
    }
    cell.contentView.tag = indexPath.row;
    
    
    return cell;
}
//回复楼主
- (void)replyTheMain:(UITapGestureRecognizer *)tap{
    // －2 表示回复楼主信息
    _block(-2,[NSString stringWithFormat:@"%@",[[_array objectAtIndex:tap.view.tag] objectForKey:@"id"]],[NSString stringWithFormat:@"%@",[[_array objectAtIndex:tap.view.tag] objectForKey:@"id"]],tap.view.tag);

}
#pragma mark --- 评论的回复delegate
- (void)pinglunReplyView:(PinglunReplyView *)pinglunReplyView  buttonAtIndex:(NSInteger)index{
    NSLog(@"pinglunReplyView.tag = %li",(long)pinglunReplyView.tag);
    NSLog(@"row = %li",(long)pinglunReplyView.superview.tag);
    NSLog(@"index = %li",(long)index);
    NSString *userID = [NSString string];
    if (index == 0) {
        userID = [NSString stringWithFormat:@"%@",[[[[[_array objectAtIndex:(long)pinglunReplyView.superview.tag] objectForKey:@"childs"] objectAtIndex:(long)pinglunReplyView.tag] objectForKey:@"uinfo"] objectForKey:@"user_id"]];
        //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userID,@"userID",nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"PushFromToubiaoDetail" object:userID userInfo:nil];
    
    }else if(index == 1){
        userID = [NSString stringWithFormat:@"%@",[[[[_array objectAtIndex:(long)pinglunReplyView.superview.tag] objectForKey:@"childs"] objectAtIndex:(long)pinglunReplyView.tag] objectForKey:@"reply_uid"]];
        //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userID,@"userID",nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"PushFromToubiaoDetail" object:userID userInfo:nil];
    
    }else{
        NSLog(@"回复他");
        _block(-3,[NSString stringWithFormat:@"%@",[[_array objectAtIndex:pinglunReplyView.superview.tag] objectForKey:@"id"]],[NSString stringWithFormat:@"%@",[[[[_array objectAtIndex:pinglunReplyView.superview.tag] objectForKey:@"childs"] objectAtIndex:pinglunReplyView.tag] objectForKey:@"id"]],nil);
    }
   

    
}
- (void)ImageSelect:(UITapGestureRecognizer *)tap{
    NSLog(@"tap.view.tag--%li",(long)tap.view.tag);
    _block(tap.view.tag,[NSString stringWithFormat:@"%@",[[[_array objectAtIndex:tap.view.tag] objectForKey:@"uinfo"] objectForKey:@"user_id"]],nil,-1);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

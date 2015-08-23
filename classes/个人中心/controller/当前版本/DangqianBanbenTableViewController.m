//
//  DangqianBanbenTableViewController.m
//  时时投
//
//  Created by 熊良军 on 15/8/11.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "DangqianBanbenTableViewController.h"

@interface DangqianBanbenTableViewController ()

@end

@implementation DangqianBanbenTableViewController{
    NSArray *titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"当前版本";
    
     self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 45 * 5);
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 115)];
    headview.backgroundColor = [UIColor colorWithWhite:0.9373 alpha:1];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.9373 alpha:1];
    self.tableView.tableHeaderView = headview;
   
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    footView.backgroundColor = [UIColor colorWithWhite:0.9373 alpha:1];
    self.tableView.tableFooterView = footView;
    
    
    titleArray = [NSArray arrayWithObjects:@"去评分",
                  @"欢迎页",
                  @"功能介绍",
                  @"举报与投诉",
                  @"帮助与反馈",nil];
    
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(125, 20, (self.view.bounds.size.width - 250), 50)];
    imageView.image = [UIImage imageNamed:@"weixin@2x"];
    [headview addSubview:imageView];
    
    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(50, 85, (self.view.bounds.size.width - 100), 20)];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.text = @"维度WD1.1.0";
    lable1.font = [UIFont systemFontOfSize:17.0];
    lable1.textColor = [UIColor colorWithWhite:0.5490 alpha:1];
    [headview addSubview:lable1];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//******tableview分割线从顶点开始********************
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *cellIdentifier1 = @"statusCell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
     if (cell == nil) {
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
         cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
         cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.textLabel.font = [UIFont systemFontOfSize:14.0];
      }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

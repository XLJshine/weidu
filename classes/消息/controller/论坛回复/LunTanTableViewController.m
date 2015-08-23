//
//  LunTanTableViewController.m
//  时时投
//
//  Created by h on 15/7/29.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "LunTanTableViewController.h"
#import "LuntanTableViewCell.h"
#import "FriendModel.h"
@interface LunTanTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * _dataArr;
}

@end

@implementation LunTanTableViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"论坛回复";
        
       }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc]init];
    
    [self createData];
//    self.tableView.delegate =self;
//    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"LuntanTableViewCell" bundle:nil] forCellReuseIdentifier:@"dayangcell"];
    


    
}
-(void)createData{
    for (int i = 0; i<10; i++) {
        FriendModel * model = [[FriendModel alloc]init];
        model.messageText = @"各位专家，在国家发改委的设计施工一体化招标范本里面，规定为项目提供前期服务的不能参与投标，我们这里有一个项目，概念性方案设计是比选了的，现在进行设计施工一体化招标，那么，这些提供概念性设计的单位能参加设计施工一体化投标不？";
        model.discussesText = @"====================================================================================================================================================================================================d====================================================================";
        [_dataArr addObject:model];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 308;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     LuntanTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"dayangcell"];
    FriendModel * model = _dataArr[indexPath.row];
    cell.messageLabel.text = model.messageText;
    cell.pinglunLabel.text = model.discussesText;
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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

//
//  TongxunluViewController.m
//  时时投
//
//  Created by 熊良军 on 15/7/28.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "TongxunluViewController.h"
#import "BATableViewKit/BATableView.h"
#import "UIImageView+MJWebCache.h"
#import "TongxunTableViewCell.h"
#import "RenmaiViewController2.h"
#import "TongXunTableViewCell2.h"
#import "AppDelegate.h"

static TongxunluViewController *instance;
@interface TongxunluViewController ()<BATableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) BATableView *contactTableView;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong)UISearchBar *mySearchBar;

@end

@implementation TongxunluViewController{
   UISearchDisplayController *searchDisplayController;
}

+ (id)shareInstance
{
    if (instance == nil)
    {
        instance = [[[self class]alloc]init];
    }
    return instance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //自定义tabbar
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"人脉" image:[UIImage imageNamed:@"renmai@2x"] selectedImage:[UIImage imageNamed:@"renmai1@2x"]];
        
        self.navigationItem.title = @"人脉";
        UIButton *lestButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lestButton setImage:[UIImage imageNamed:@"caidan@2x"] forState:UIControlStateNormal];
        [lestButton addTarget:self action:@selector(push1) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:lestButton];
        self.navigationItem.leftBarButtonItem = leftItem;
        
        //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"caidan@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(push1)];
        UIButton *Button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [Button setImage:[UIImage imageNamed:@"tianjia@2x"] forState:UIControlStateNormal];
        [Button addTarget:self action:@selector(push2) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:Button];
        rightItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    return self;
}
-(void)push1{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController = [delegate siderViewController];
    [sideViewController showLeftViewController:YES];
    
    //显示主界面半透明视图
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideviewAppear" object:nil userInfo:nil];
}

-(void)push2{
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing@2x"]];
    // Do any additional setup after loading the view.
    self.dataSource = @[@{@"indexTitle": @"A",@"data":@[@"adam", @"alfred", @"ain", @"abdul", @"anastazja", @"angelica"]},@{@"indexTitle": @"D",@"data":@[@"dennis" , @"deamon", @"destiny", @"dragon", @"dry", @"debug", @"drums"]},@{@"indexTitle": @"F",@"data":@[@"Fredric", @"France", @"friends", @"family", @"fatish", @"funeral"]},@{@"indexTitle": @"M",@"data":@[@"Mark", @"Madeline"]},@{@"indexTitle": @"N",@"data":@[@"Nemesis", @"nemo", @"name"]},@{@"indexTitle": @"O",@"data":@[@"Obama", @"Oprah", @"Omen", @"OMG OMG OMG", @"O-Zone", @"Ontario"]},@{@"indexTitle": @"Z",@"data":@[@"Zeus", @"Zebra", @"zed"]}];
    [self createTableView];
    
    
    _mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    _mySearchBar.backgroundColor = [UIColor clearColor];
    _mySearchBar.delegate = self;
    [_mySearchBar setPlaceholder:@"搜索"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_mySearchBar contentsController:self];
    //searchDisplayController.searchBar.barTintColor = [UIColor clearColor];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
     self.contactTableView.tableView.tableHeaderView = _mySearchBar;
    //[self.view addSubview:_mySearchBar];
}
// 创建tableView
- (void) createTableView {
    self.contactTableView = [[BATableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 49)];
    self.contactTableView.delegate = self;
    self.contactTableView.backgroundColor = [UIColor clearColor];
    self.contactTableView.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contactTableView];
    //[self.contactTableView.tableView registerNib:[UINib nibWithNibName:@"TongxunTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//******tableview分割线从顶点开始********************
-(void)viewDidLayoutSubviews
{
    if ([self.contactTableView.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.contactTableView.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.contactTableView.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.contactTableView.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
#pragma mark - UITableViewDataSource
- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView {
    NSMutableArray * indexTitles = [NSMutableArray array];
    for (NSDictionary * sectionDictionary in self.dataSource) {
        [indexTitles addObject:sectionDictionary[@"indexTitle"]];
    }
    return indexTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (section == 0) {
            return @"";
        }else{
             return self.dataSource[section - 1][@"indexTitle"];
        }
       
    }
    else {
        if (section == 0) {
            return @"";
        }else{
            return self.dataSource[section - 1][@"indexTitle"];
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   if (section != 0) {
            UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 100, 14)];
            lable.text = self.dataSource[section - 1][@"indexTitle"];
            lable.font = [UIFont systemFontOfSize:11];
            lable.textColor = [UIColor colorWithWhite:0.4 alpha:1];
            [headview addSubview:lable];
            headview.backgroundColor = [UIColor clearColor];
            return headview;
    }else{
            return nil;
    }
    
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 20;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
          return self.dataSource.count + 1;
    }
    else {
          return self.dataSource.count + 1;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else{
        return [self.dataSource[section - 1][@"data"] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *CellIdentifier = @"Cell";
     TongXunTableViewCell2 * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TongXunTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
    
        if (indexPath.section == 0) {
          
            cell.textLabel.text = @"寻找人脉";
            [cell.imageView setImageURLStr:@"http://i3.tietuku.com/926b01c17441d559s.jpg" placeholder:[UIImage imageNamed:@"touxiang11@2x"]];
        }else{
            
            cell.textLabel.text = self.dataSource[indexPath.section - 1][@"data"][indexPath.row];
            [cell.imageView setImageURLStr:@"http://i3.tietuku.com/926b01c17441d559s.jpg" placeholder:[UIImage imageNamed:@"touxiang11@2x"]];
        }
        return cell;
     
    }else{
      
           if (indexPath.section == 0) {
                cell.textLabel.text = @"寻找人脉";
                [cell.imageView setImageURLStr:@"http://i3.tietuku.com/926b01c17441d559s.jpg" placeholder:[UIImage imageNamed:@"touxiang11@2x"]];
            }else{
                cell.textLabel.text = self.dataSource[indexPath.section - 1][@"data"][indexPath.row];
                [cell.imageView setImageURLStr:@"http://i3.tietuku.com/926b01c17441d559s.jpg" placeholder:[UIImage imageNamed:@"touxiang11@2x"]];
            }
            return cell;
        }
}
#pragma UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //[self.contactTableView.tableView reloadData];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0&&indexPath.row == 0) {
        RenmaiViewController2 *RVC = [[RenmaiViewController2 alloc]init];
        [self.navigationController pushViewController:RVC animated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

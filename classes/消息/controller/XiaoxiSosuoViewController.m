//
//  XiaoxiSosuoViewController.m
//  dayang
//
//  Created by h on 15/7/20.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "XiaoxiSosuoViewController.h"

@interface XiaoxiSosuoViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>
{
    UISearchDisplayController * _displayCtr;
}
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;


@end

@implementation XiaoxiSosuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)createSearchController{
    _displayCtr = [[UISearchDisplayController alloc]initWithSearchBar:_mySearchBar contentsController:self];
    _displayCtr.delegate = self;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

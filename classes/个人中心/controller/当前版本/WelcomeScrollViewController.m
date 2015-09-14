//
//  WelcomeScrollViewController.m
//  时时投
//
//  Created by h on 15/8/27.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "WelcomeScrollViewController.h"

@interface WelcomeScrollViewController ()
@property(strong,nonatomic)UIPageControl*pageCtl;
@end

@implementation WelcomeScrollViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"WelcomeScrollViewController"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"WelcomeScrollViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.adScollView.contentSize = CGSizeMake(self.view.bounds.size.width*4, 0);
    self.adScollView.pagingEnabled = YES;
    self.adScollView.bounces = NO;
    for (int i = 0; i<4; i++) {
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*i, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        if (self.view.bounds.size.height > 500) {
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"intro_page%d",i+1]];
        }else{
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"intro_page%d4",i+1]];
            
        }
        
        if (i == 3) {
            img.userInteractionEnabled = YES;
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10,408, 300, 40);
            button.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/6*5);
            [button setImage:[UIImage imageNamed:@"getInView@2x"] forState:UIControlStateNormal];
            //[button setTitle:@"开启新时代" forState:UIControlStateNormal];
            //[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            //button.titleLabel.font = [UIFont systemFontOfSize:30];
            // button.backgroundColor = [UIColor yellowColor];
            [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            [img addSubview:button];
            
            
            _pageCtl=[[UIPageControl alloc]initWithFrame:CGRectMake(120, 398, 80, 30)];
            _pageCtl.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/15*14);
            
            _pageCtl.numberOfPages=4;
            _pageCtl.currentPageIndicatorTintColor=[UIColor whiteColor];
            //_pageCtl.center = CGPointMake(self.adScollView.frame.size.width/2, self.adScollView.frame.origin.y+98);
            [_pageCtl addTarget:self action:@selector(changScrollView:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        [self.view addSubview:_pageCtl];
        [self.adScollView addSubview:img];
        
    }
    
}
-(void)changScrollView:(UIPageControl*)page{
    
    [self.adScollView setContentOffset:CGPointMake(320*page.currentPage, 0) animated:YES];
}

#pragma mark- UIScrollView
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pageCtl.currentPage = _adScollView.contentOffset.x/320;
}
-(void)btnAction{
    [self dismissViewControllerAnimated:YES completion:nil];
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

//
//  ChoosePicViewController.m
//  时时投
//
//  Created by 熊良军 on 15/7/23.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "ChoosePicViewController.h"
#import "ChoosePicView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
@interface ChoosePicViewController ()

@end

@implementation ChoosePicViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.title = @"选择背景图片";
        
        /*UIButton *lestButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lestButton setImage:[UIImage imageNamed:@"fanhuix@2x"] forState:UIControlStateNormal];
        [lestButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:lestButton];
        self.navigationItem.leftBarButtonItem = leftItem;*/
        
    }
    return self;
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backgrondview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beijing@2x"]];
    [self.view addSubview:backgrondview];
    NSArray *imageUrlArray = [NSArray arrayWithObjects:@"http://www.dianchuifeng.net/img/aHR0cDovL2ltYWdlLnpjb29sLmNvbS5jbi81Mi80Ni9tXzEzMDQwOTEzMTU4MjEuanBn.jpg",
                              @"http://img2.3lian.com/2014/c8/41/42.jpg",
                              @"http://bizhi.33lc.com/uploadfile/2013/1016/20131016021248981.jpg",
                              @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1303/15/c2/18932247_1363327262891_320x480.png",
                              @"http://bizhi.33lc.com/uploadfile/2014/0825/20140825012040901.jpg",
                              @"http://img5.duitang.com/uploads/item/201307/14/20130714060420_kyRnF.jpeg",
                              @"http://bizhi.33lc.com/uploadfile/2013/0907/20130907104735796.jpg",nil];
    for (int i = 0; i < imageUrlArray.count; i ++) {
        int x = i%3;   //0,1,2,0,1,2
        int y = i/3;   //0,0,0,1,1,1
        NSString *imageStr = [imageUrlArray objectAtIndex:i];
        __block ChoosePicView *CPV = [[ChoosePicView alloc]initWithFrame:CGRectMake(10 + ((self.view.bounds.size.width - 40)*0.333 + 10)*x, 10 + ((self.view.bounds.size.width - 40)*0.333 + 10)*y, (self.view.bounds.size.width - 40)*0.333, (self.view.bounds.size.width - 40)*0.333) imageview:imageStr viewtag:i  buttonBlock:^(NSInteger index){
            NSLog(@"按钮index = %li",(long)index);
            
        
        } BlockImage:^(NSInteger index){
            NSLog(@"图片index = %li",(long)index);
            NSMutableArray *imageUrlArray = [NSMutableArray arrayWithObjects:imageStr, nil];
            int count = (int)imageUrlArray.count;
            // 1.封装图片数据
            NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
           for (int i = 0; i<count; i++) {
                // 替换为中等尺寸图片
                NSString *url = [imageUrlArray objectAtIndex:i];
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:url]; // 图片路径
                photo.srcImageView = [CPV.imageview.superview.subviews objectAtIndex:i]; // 来源于哪个UIImageView
                [photos addObject:photo];
            }
            
            // 2.显示相册
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc]init];
            browser.currentPhotoIndex = 0; //弹出相册时显示的第一张图片是？
            browser.photos = photos; // 设置所有的图片
            [browser show];
            
        }];
        CPV.layer.masksToBounds = YES;
        CPV.layer.cornerRadius = 4;
        [self.view addSubview:CPV];
        
    }
    // Do any additional setup after loading the view.
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

//
//  TiaotianBeijingViewController.m
//  时时投
//
//  Created by 熊良军 on 15/7/23.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "TiaotianBeijingViewController.h"
#import "ZhanghaoSafeTableViewCell.h"
#import "ChoosePicViewController.h"
#import "ZYQAssetPickerController.h"
@interface TiaotianBeijingViewController ()<UITableViewDataSource,UITableViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic ,strong)NSArray *titleArray;
@property (nonatomic ,strong)NSArray *backgroundImageArray;



@end

@implementation TiaotianBeijingViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"聊天背景";
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
    
    [self data];
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableview setBackgroundColor:[UIColor clearColor]];
    _tableview.scrollEnabled = NO;
    [self.view addSubview:_tableview];
    
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    headview.backgroundColor = [UIColor clearColor];
    _tableview.tableHeaderView = headview;
    
    
    UIButton *chatchangeButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 185, self.view.bounds.size.width - 20, 40)];
    [chatchangeButton setTitle:@"将背景应用到所有聊天场景" forState:UIControlStateNormal];
    chatchangeButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [chatchangeButton setBackgroundColor:[UIColor clearColor]];
    [chatchangeButton setBackgroundImage:[UIImage imageNamed:@"chaangtiao4@2x"] forState:UIControlStateNormal];
    [chatchangeButton setTitleColor:[UIColor colorWithWhite:0.15 alpha:1] forState:UIControlStateNormal];
    [chatchangeButton setBackgroundColor:[UIColor whiteColor]];
    [chatchangeButton addTarget:self action:@selector(chatBeijingchangeAction) forControlEvents:UIControlEventTouchUpInside];
    [_tableview addSubview:chatchangeButton];
    
    // Do any additional setup after loading the view.
}
- (void)data{
    _titleArray = [NSArray arrayWithObjects:@"选择背景图片",
                   @"从手机相册选择",
                   @"拍一张",
                   nil];
    
    _backgroundImageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"chaangtiao1@2x"],[UIImage imageNamed:@"chaangtiao2@2x"],[UIImage imageNamed:@"chaangtiao3@2x"], nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier1 = @"statusCell3";
    ZhanghaoSafeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (cell == nil) {
        cell = [[ZhanghaoSafeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1 title:[_titleArray objectAtIndex:indexPath.row] detail:nil backgroundimage:[_backgroundImageArray objectAtIndex:indexPath.row]];
    }else{
        [cell title:[_titleArray objectAtIndex:indexPath.row] detail:nil backgroundimage:[_backgroundImageArray objectAtIndex:indexPath.row]];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0||indexPath.row == 1||indexPath.row == 2) {
        UIImageView *arrawImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 42, 19, 12, 12)];
        [arrawImage setImage:[UIImage imageNamed:@"fangRight@2x"]];
        [cell.contentView addSubview:arrawImage];
        
    }else{
        
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ChoosePicViewController *CVC = [[ChoosePicViewController alloc]init];
        [self.navigationController pushViewController:CVC animated:YES];
    
    }else if (indexPath.row == 1){  //启用相册
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
       [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"dingbu@2x"] forBarMetrics:UIBarMetricsDefault];
        picker.maximumNumberOfSelection = 1;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups = NO;
        picker.delegate = self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }else{   //调用摄像头
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            NSLog(@"没有摄像头");
            return ;
        }
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        //编辑模式
        //imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }
}
- (void)chatBeijingchangeAction{
    NSLog(@"将背景应用到所有聊天场景");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"聊天背景" message:@"确定将背景应用到所有聊天场景" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
#pragma mark --- UIImagePickerControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    NSLog(@"图片保存成功,得到image");
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    //[self.imgMuArray removeAllObjects];
    //[self.imgScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //self.imgScroll.contentSize=CGSizeMake((assets.count + 1)* (self.view.bounds.size.width - 25)/4 + (assets.count + 2)*5, self.imgScroll.frame.size.height);
        dispatch_async(dispatch_get_main_queue(), ^{
            //pageControl.numberOfPages=assets.count;
        });
        
        for (int i=0; i<assets.count; i++) {
            /*ALAsset *asset=assets[i];
            UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(i*((self.view.bounds.size.width - 25)/4) + 5*(i + 1), 0, self.imgScroll.frame.size.height, self.imgScroll.frame.size.height)];
            imgview.contentMode=UIViewContentModeScaleAspectFill;
            imgview.clipsToBounds=YES;
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];*/
            dispatch_async(dispatch_get_main_queue(), ^{
                /*[imgview setImage:tempImg];
                [self.imgScroll addSubview:imgview];
                
                [self.theGrayImageView removeFromSuperview];
                self.theGrayImageView = [[UIImageView alloc]initWithFrame:CGRectMake(assets.count*((self.view.bounds.size.width - 25)/4) + 5*(assets.count + 1), 0, self.imgScroll.frame.size.height, self.imgScroll.frame.size.height)];
                self.theGrayImageView.image = [UIImage imageNamed:@"tianjiazhaopiankong"];
                self.theGrayImageView.userInteractionEnabled = YES;
                [self.theGrayImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)]];
                [self.imgScroll addSubview:self.theGrayImageView];
                
                NSData *bigImageData = UIImageJPEGRepresentation(tempImg, 1);
                NSString *sizeStr = [NSByteCountFormatter stringFromByteCount:bigImageData.length countStyle:NSByteCountFormatterCountStyleBinary];
                NSLog(@"%@", sizeStr);
                float f = (float)bigImageData.length/1024.0f;
                NSLog(@"f = %f",f);
                while (f > 300) {
                    UIImage *cutImageSmall = [UIImage imageWithData:bigImageData];
                    bigImageData = UIImageJPEGRepresentation(cutImageSmall, 0.95);
                    f = (float)bigImageData.length/1024.0f;
                    NSLog(@"f = %f",f);
                }
                [self.imgMuArray addObject:bigImageData];*/
                
            });
        }
    });
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

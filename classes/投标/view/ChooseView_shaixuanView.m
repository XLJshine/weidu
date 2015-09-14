//
//  ChooseView_shaixuanView.m
//  时时投
//
//  Created by 熊良军 on 15/8/19.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import "ChooseView_shaixuanView.h"
#import "STAlertView.h"
#import "WBBooksManager.h"
#import "RequestXlJ.h"
@implementation ChooseView_shaixuanView{
    NSMutableArray *catesMuSeclectArray;  //分类选中判断数组
    NSMutableArray *typesMuSeclectArray;  //类别选中判断数组
    NSMutableArray *tradesMuSeclectArray; //行业选中判断数组
    NSMutableArray *areaMuSeclectArray;   //地区选中判断数组
    __block NSInteger tradeSelectNum;   //地区选中判断数组
    
    
    NSMutableArray *catesIdArray;    //分类ID数据
    NSMutableArray *typesIdArray;    //类别ID数据
    NSMutableArray *tradesIdArray;   //行业ID数据
    NSMutableArray *areaIdArray;     //省份ID数据
    
    __block NSInteger areaIndex;
    
    AFHTTPRequestOperationManager *manager;
    RequestXlJ *_request;
}
- (instancetype)initWithFrame:(CGRect)frame   block:(shaixuanBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _block = block;
        
        _request = [[RequestXlJ alloc]init];
        _parameters = [NSDictionary dictionary];
        [self initData];
        
        [self addView];  //加载视图
        
        
         _loadingView = [[LoadingViewXLJ alloc]initWithFrame:CGRectMake((self.bounds.size.width - 200)*0.5, self.bounds.size.height*0.5 - 50, 200,100) title:@"正在加载，请稍后。。。"];
        //重置按钮
        UIButton *reButton = [[UIButton alloc]initWithFrame:CGRectMake(10, self.bounds.size.height - 45, 90, 35)];
        [reButton setTitle:@"重置" forState:UIControlStateNormal];
        [reButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [reButton setBackgroundImage:[UIImage imageNamed:@"dingyueButton@2x"] forState:UIControlStateNormal];
        reButton.tag = 0;
        [reButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        reButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:reButton];
        
        //确定按钮
        UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(reButton.frame.origin.x + reButton.bounds.size.width + 15, self.bounds.size.height - 45, 90, 35)];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sureButton setBackgroundImage:[UIImage imageNamed:@"dingyueButton@2x"] forState:UIControlStateNormal];
        sureButton.tag = 1;
        [sureButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        sureButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:sureButton];
        
        
        //保存按钮
        UIButton *baocunButton = [[UIButton alloc]initWithFrame:CGRectMake(sureButton.frame.origin.x + sureButton.bounds.size.width + 15, self.bounds.size.height - 45, 90, 35)];
        [baocunButton setTitle:@"保存设置" forState:UIControlStateNormal];
        [baocunButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [baocunButton setBackgroundImage:[UIImage imageNamed:@"dingyueButton@2x"] forState:UIControlStateNormal];
        baocunButton.tag = 2;
        [baocunButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        baocunButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:baocunButton];

        manager = [AFHTTPRequestOperationManager manager];//实例化请求
    }
    return self;
}
- (void)initParameter{
    if (catesIdArray.count != 0&&typesIdArray.count !=0&&tradesIdArray.count !=0&&areaIdArray.count !=0) {   //全部
        _parameters = @{@"cate":catesIdArray,
                        @"type":typesIdArray,
                        @"trade":tradesIdArray,
                        @"area":areaIdArray,
                     
                        };
    }else if (catesIdArray.count != 0&&typesIdArray.count ==0&&tradesIdArray.count !=0&&areaIdArray.count !=0){  //无类别
        _parameters = @{@"cate":catesIdArray,
                        @"trade":tradesIdArray,
                        @"area":areaIdArray,
                      
                        };
        
        
    }else if (catesIdArray.count != 0&&typesIdArray.count !=0&&tradesIdArray.count ==0&&areaIdArray.count !=0){   //无行业
        _parameters = @{@"cate":catesIdArray,
                        @"type":typesIdArray,
                        @"area":areaIdArray,
                      
                        };
        
        
    }else if (catesIdArray.count != 0&&typesIdArray.count !=0&&tradesIdArray.count !=0&&areaIdArray.count ==0){   //无地区
        _parameters = @{@"cate":catesIdArray,
                        @"type":typesIdArray,
                        @"trade":tradesIdArray,
                       
                        };
        
        
    }else if (catesIdArray.count == 0&&typesIdArray.count !=0&&tradesIdArray.count !=0&&areaIdArray.count !=0){    //无分类
        _parameters = @{@"type":typesIdArray,
                        @"trade":tradesIdArray,
                        @"area":areaIdArray,
                    
                        };
        
        
    }else if (catesIdArray.count == 0&&typesIdArray.count ==0&&tradesIdArray.count !=0&&areaIdArray.count !=0){   //无分类，类型
        _parameters = @{@"trade":tradesIdArray,
                        @"area":areaIdArray,
                   
                        };
        
        
    }else if (catesIdArray.count == 0&&typesIdArray.count !=0&&tradesIdArray.count ==0&&areaIdArray.count !=0){
        
        _parameters = @{@"type":typesIdArray,
                        @"area":areaIdArray,
                      
                        };
        
    }else if (catesIdArray.count == 0&&typesIdArray.count !=0&&tradesIdArray.count !=0&&areaIdArray.count ==0){
        
        _parameters = @{@"type":typesIdArray,
                        @"trade":tradesIdArray,
                       
                        };
        
    }else if (catesIdArray.count != 0&&typesIdArray.count ==0&&tradesIdArray.count ==0&&areaIdArray.count !=0){
        _parameters = @{@"cate":catesIdArray,
                        @"area":areaIdArray,
                     
                        };
        
        
    }else if (catesIdArray.count != 0&&typesIdArray.count ==0&&tradesIdArray.count !=0&&areaIdArray.count ==0){
        _parameters = @{@"cate":catesIdArray,
                        @"trade":tradesIdArray,
                    
                        };
        
        
    }else if (catesIdArray.count != 0&&typesIdArray.count !=0&&tradesIdArray.count ==0&&areaIdArray.count ==0){
        _parameters = @{@"cate":catesIdArray,
                        @"type":typesIdArray,
                    
                        };
        
        
    }else if (catesIdArray.count != 0&&typesIdArray.count ==0&&tradesIdArray.count ==0&&areaIdArray.count ==0){
        _parameters = @{@"cate":catesIdArray,
                        
                        };
        
        
    }else if (catesIdArray.count == 0&&typesIdArray.count !=0&&tradesIdArray.count ==0&&areaIdArray.count ==0){
        _parameters = @{@"type":typesIdArray,
                      
                        };
        
        
    }else if (catesIdArray.count == 0&&typesIdArray.count ==0&&tradesIdArray.count !=0&&areaIdArray.count ==0){
        _parameters = @{@"trade":tradesIdArray,
                       
                        };
        
        
    }else if (catesIdArray.count == 0&&typesIdArray.count ==0&&tradesIdArray.count ==0&&areaIdArray.count !=0){
        _parameters = @{@"area":areaIdArray,
                       
                        };
        
        
    }else{
        _parameters = nil;
    }
    
    NSLog(@"_parameters = %@",_parameters);

}
- (void)buttonAction:(UIButton *)button{
    switch (button.tag) {
        case 0:
        {
            [self initData];  //初始化数据
            [self addView];  //重置视图
        }
            break;
        case 1:
        {
            NSLog(@"确定");
            [self initParameter];
           
//            manager.responseSerializer = [AFJSONResponseSerializer serializer];
//            //申明请求的数据是json类型
//            manager.requestSerializer=[AFJSONRequestSerializer serializer];
//            //如果报接受类型不一致请替换一致text/html或别的
//            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//            //传入的参数
           
            [self addSubview:_loadingView];
            
            
            NSString *urlStr =[NSString stringWithFormat:@"%@article/list?access-token=%@&page=1&psize=10",ApiUrlHead,_token];
            [manager POST:urlStr parameters:_parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                [_loadingView removeFromSuperview];
                
                NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                if ([code isEqualToString:@"0"]) {
                    NSArray *data = [responseObject objectForKey:@"data"];
                    _block(_parameters,data,nil,1);
               
                }else if (![code isEqualToString:@"0"]){
                    NSString *error = [responseObject objectForKey:@"err"];
                    NSLog(@"error=%@",error);
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                    [alert show];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [_loadingView removeFromSuperview];
                
            }];
        }
            break;
        case 2:
        {
            //保存设置
            [self initParameter];
            if (_token.length > 10) {
                _stAlertView = [[STAlertView alloc]initWithTitle:@"给保存信息取个名" message:nil textFieldHint:@"请输入名称" textFieldValue:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定" cancelButtonBlock:^{
                
                
                } otherButtonBlock:^(NSString *result) {
                    NSString *encoded = [result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSLog(@"encoded = %@",encoded);
                    [self addSubview:_loadingView];
                    
                    [manager POST:[NSString stringWithFormat:@"%@filter/add?access-token=%@&title=%@",ApiUrlHead,_token,encoded] parameters:_parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [_loadingView removeFromSuperview];
                        NSLog(@"JSON: %@", responseObject);
                        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                        if ([code isEqualToString:@"0"]) {
                            //NSArray *data = [responseObject objectForKey:@"data"];
                            _block(_parameters,nil,nil,2);
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"保存成功" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                            [alert show];
                            
                        }else if (![code isEqualToString:@"0"]){
                            NSString *error = [responseObject objectForKey:@"err"];
                            NSLog(@"error=%@",error);
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                            [alert show];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        [_loadingView removeFromSuperview];
                        
                    }];
                    
                    
                }];
                
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                [alert show];
            
            }
            
        }
            break;
        default:
            break;
    }
    
}
- (void)initData{
    
    if (![[WBBooksManager sharedInstance] isBookExistsForKey:@"Article"]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@article/fitems",ApiUrlHead];
        [_request requestWithUrl:urlStr methed:@"get" block:^(NSInteger code,NSString *error,NSDictionary * responseObject,NSArray *array){
            NSLog(@"code = %li",(long)code);
            //NSLog(@"responseObject = %@",responseObject);
            if (code == 0) {
                NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                _ArticleDic = userDic;
                _areaDic = [_ArticleDic objectForKey:@"areas"];      //地区字典
                _hangyeDic = [_ArticleDic objectForKey:@"trades"];   //行业字典
                _leibieDic = [_ArticleDic objectForKey:@"types"];    //类别字典
                _fenleiDic = [_ArticleDic objectForKey:@"cates"];    //分类字典
            }else{
                NSLog(@"加载失败");
                
            }
            
        }];
    }else{
        NSMutableDictionary * resultDictionary = [[NSMutableDictionary alloc] init];
        [[WBBooksManager sharedInstance] readPlist:&resultDictionary];
        _ArticleDic = [resultDictionary objectForKey:@"Article"];
        NSLog(@"ArticleDic = %@",_ArticleDic);
        _areaDic = [_ArticleDic objectForKey:@"areas"];      //地区字典
        _hangyeDic = [_ArticleDic objectForKey:@"trades"];   //行业字典
        _leibieDic = [_ArticleDic objectForKey:@"types"];    //类别字典
        _fenleiDic = [_ArticleDic objectForKey:@"cates"];    //分类字典
    }
    
    catesIdArray = [NSMutableArray array];
    typesIdArray = [NSMutableArray array];
    tradesIdArray = [NSMutableArray array];
    areaIdArray = [NSMutableArray array];
    
    catesMuSeclectArray = [NSMutableArray arrayWithObjects:@"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",nil];
    
    
    typesMuSeclectArray = [NSMutableArray arrayWithObjects:@"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",
                           @"0",nil];
    tradesMuSeclectArray = [NSMutableArray arrayWithObjects:@"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",
                            @"0",nil];
    
    NSMutableArray *array1 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
    NSMutableArray *array2 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
    NSMutableArray *array3 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
    NSMutableArray *array4 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
    NSMutableArray *array5 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
    NSMutableArray *array6 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
    NSMutableArray *array7 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
    NSMutableArray *array8 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
    NSMutableArray *array9 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
    areaMuSeclectArray = [NSMutableArray arrayWithObjects:array1,array2,array3,array4,array5,array6,array7,array8,array9, nil];
    
    
    
    tradeSelectNum = 0;
}

- (void)addView{
    [_firstTableView removeFromSuperview];
    [_secondTableView removeFromSuperview];
    [_areaTableView removeFromSuperview];
    [_mychooseTableView removeFromSuperview];
    
    _firstTableView = [[ChooseViewfirstTableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width * 0.333, self.bounds.size.height - 55) titleArray:[NSArray arrayWithObjects:@"分类",@"地区",@"行业",@"类别",@"我的筛选", nil] block:^(NSInteger index){
        NSLog(@"index = %ld",(long)index);
        [_secondTableView removeFromSuperview];
        [_areaTableView removeFromSuperview];
        [_mychooseTableView removeFromSuperview];
        if (index == 0) { //分类
            [_secondTableView removeFromSuperview];
            NSArray *arr = [_fenleiDic allValues];
            NSMutableArray *muArr = [NSMutableArray arrayWithObjects:@"全部", nil];
            [muArr addObjectsFromArray:arr];
            
            
            _secondTableView = [[ChooseViewsecondTableView alloc]initWithFrame:CGRectMake(self.bounds.size.width * 0.333, 0, self.bounds.size.width * 0.667, self.bounds.size.height - 55) titleArray:muArr selectArray:catesMuSeclectArray  block:^(NSInteger index,NSInteger ifSelectNum){
                //NSLog(@"index = %li",(long)index);
                NSArray *IDarr = [_fenleiDic allKeys];
                //NSLog(@"IDarr = %@",IDarr);
                if (index == 0) {
                   
                    catesMuSeclectArray = [NSMutableArray arrayWithObjects:@"1",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",nil];
                    [catesIdArray removeAllObjects];
                    //[catesIdArray addObjectsFromArray:IDarr];
                    //NSLog(@"catesIdArray = %@",catesIdArray);
                    
                    [_secondTableView tableReloadData:muArr selectArray:catesMuSeclectArray ];
                }else{
                   
                    [catesMuSeclectArray replaceObjectAtIndex:0  withObject:@"0"];
                     NSString *IDstr = [NSString stringWithFormat:@"%@",[IDarr objectAtIndex:index - 1]];
                    
                   if (ifSelectNum == 1) {
                        [catesIdArray addObject:IDstr];
                        [catesMuSeclectArray replaceObjectAtIndex:index  withObject:@"1"];
                    }else{
                        [catesIdArray removeObject:IDstr];
                         [catesMuSeclectArray replaceObjectAtIndex:index  withObject:@"0"];
                    }
                    
                    [_secondTableView tableReloadData:muArr selectArray:catesMuSeclectArray];
               }
                NSLog(@"catesIdArray1 = %@",catesIdArray);
            }];
            [self addSubview:_secondTableView];
        }else if (index == 1){   //地区选择
            [_secondTableView removeFromSuperview];
            __block NSArray *arr = [_areaDic allKeys];
            __block NSMutableArray *muArr = [NSMutableArray arrayWithObjects:@"全部", nil];
            [muArr addObjectsFromArray:arr]; //地区数组
            
            
            //地区选项颜色
            __block  NSMutableArray *colorArray  = [NSMutableArray arrayWithObject:@"2"];
            for (NSMutableArray *array in areaMuSeclectArray) {
                if ([array containsObject:@"1"]) {
                    [colorArray addObject:@"1"];
                }else{
                    [colorArray addObject:@"0"];
                }
            }
              
            
            _areaTableView = [[AreaTableView alloc]initWithFrame:CGRectMake(self.bounds.size.width * 0.333, 0, self.bounds.size.width * 0.333,  self.bounds.size.height - 55) titleArray:muArr   colorArray:colorArray block:^(NSInteger index){ //地区一级
                NSLog(@"index = %li",(long)index);
                areaIndex = index;
                [_secondTableView removeFromSuperview];
                NSArray *arr1 = [_areaDic allValues];
                
                if (index !=0) {  //为0是全部，故不能在选择全部
                    NSDictionary *dic1 = [arr1 objectAtIndex:index - 1];
                    NSLog(@"dic1 = %@",dic1);
                    NSArray *arr2 = [dic1 allValues];
                    __block  NSArray *areaIdArray1 = [dic1 allKeys];  //省份ID
                    
                    NSMutableArray *muArr1 = [NSMutableArray arrayWithObjects:@"全部", nil];
                    [muArr1 addObjectsFromArray:arr2];    //省份数组
                    
                    NSMutableArray *shengArray =  [areaMuSeclectArray objectAtIndex:index - 1];
                    _secondTableView = [[ChooseViewsecondTableView alloc]initWithFrame:CGRectMake(self.bounds.size.width * 0.666, 0,self.bounds.size.width * 0.334, self.bounds.size.height - 55) titleArray:muArr1 selectArray:shengArray  block:^(NSInteger index,NSInteger ifSelectNum){  //地区二级
                        NSLog(@"index2 = %li",(long)index);
                        if (index == 0) {
                            NSMutableArray *shengArray = [NSMutableArray arrayWithObjects:@"1",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",
                                                   @"0",nil];
                            
                            
                            if (ifSelectNum == 1) {
                                [areaIdArray addObjectsFromArray:areaIdArray1];
                                [shengArray replaceObjectAtIndex:index  withObject:@"1"];
                            }else{
                                for (NSString *idStr in areaIdArray1) {
                                    [areaIdArray removeObject:idStr];
                                }
                               
                                [shengArray replaceObjectAtIndex:index  withObject:@"0"];
                            }
                            
                            
                            [areaMuSeclectArray replaceObjectAtIndex:areaIndex - 1  withObject:shengArray];
                            [_secondTableView tableReloadData:muArr1 selectArray:shengArray];
                            
                        }else{
                            NSMutableArray * shengArray = [areaMuSeclectArray objectAtIndex:areaIndex - 1];
                            [shengArray replaceObjectAtIndex:0  withObject:@"0"];
                            NSString *idStr = [areaIdArray1 objectAtIndex:index - 1];
                            if (ifSelectNum == 1) {
                                [areaIdArray addObject:idStr];
                                [shengArray replaceObjectAtIndex:index  withObject:@"1"];
                            }else{
                                [areaIdArray removeObject:idStr];
                                [shengArray replaceObjectAtIndex:index  withObject:@"0"];
                            }
                            [areaMuSeclectArray replaceObjectAtIndex:areaIndex - 1 withObject:shengArray];
                            [_secondTableView tableReloadData:muArr1 selectArray:shengArray];
                        }
                    }];
                    [self addSubview:_secondTableView];
                    
                    //地区选项颜色
                    [colorArray removeAllObjects];
                    [colorArray addObject:@"0"];
                    for (NSMutableArray *array in areaMuSeclectArray) {
                        if ([array containsObject:@"1"]) {
                            [colorArray addObject:@"1"];
                        }else{
                            [colorArray addObject:@"0"];
                        }
                    }
                    [colorArray replaceObjectAtIndex:areaIndex withObject:@"2"];
                    
                    
                    [_areaTableView tableReloadData:muArr colorArray:colorArray];
                }else{
                    //地区选项颜色
                    [colorArray removeAllObjects];
                    [colorArray addObject:@"2"];
                    [colorArray addObject:@"0"];
                    [colorArray addObject:@"0"];
                    [colorArray addObject:@"0"];
                    [colorArray addObject:@"0"];
                    [colorArray addObject:@"0"];
                    [colorArray addObject:@"0"];
                    [colorArray addObject:@"0"];
                    [colorArray addObject:@"0"];
                    [colorArray addObject:@"0"];
                    [colorArray addObject:@"0"];
                    [colorArray addObject:@"0"];
                    [colorArray addObject:@"0"];
                    [colorArray addObject:@"0"];
                    [colorArray addObject:@"0"];
                    [colorArray addObject:@"0"];
                    [colorArray addObject:@"0"];
                   
                    
                    [areaIdArray removeAllObjects];  //移除所有省份ID
                    [areaMuSeclectArray removeAllObjects];
                    NSMutableArray *array1 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
                    NSMutableArray *array2 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
                    NSMutableArray *array3 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
                    NSMutableArray *array4 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
                    NSMutableArray *array5 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
                    NSMutableArray *array6 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
                    NSMutableArray *array7 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
                    NSMutableArray *array8 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
                    NSMutableArray *array9 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
                    [areaMuSeclectArray addObject:array1];
                    [areaMuSeclectArray addObject:array2];
                    [areaMuSeclectArray addObject:array3];
                    [areaMuSeclectArray addObject:array4];
                    [areaMuSeclectArray addObject:array5];
                    [areaMuSeclectArray addObject:array6];
                    [areaMuSeclectArray addObject:array7];
                    [areaMuSeclectArray addObject:array8];
                    [areaMuSeclectArray addObject:array9];
                    
                    [_areaTableView tableReloadData:muArr colorArray:colorArray];
                
                }
                NSLog(@"areaIdArray = %@",areaIdArray);
            }];
            [self addSubview:_areaTableView];
            
        }else if (index == 2){ //行业,只能单选
            [_tradeTableView removeFromSuperview];
            NSArray *arr = [_hangyeDic allValues];
            NSMutableArray *muArr = [NSMutableArray arrayWithObjects:@"全部", nil];
            [muArr addObjectsFromArray:arr];
           
           _tradeTableView = [[TradetableView alloc]initWithFrame:CGRectMake(self.bounds.size.width * 0.333, 0, self.bounds.size.width * 0.667, self.bounds.size.height - 55) titleArray:muArr block:^(NSInteger index){
                NSLog(@"tradeindex = %li",(long)index);
               tradeSelectNum = index;
                if (index == 0) {
                    [tradesIdArray removeAllObjects];
                }else{
                    NSArray *idArray = [_hangyeDic allKeys];
                    [tradesIdArray removeAllObjects];
                    [tradesIdArray addObject:[idArray objectAtIndex:index - 1]];
                }
            }];
            NSIndexPath *ip2=[NSIndexPath indexPathForRow:tradeSelectNum inSection:0];
            [_tradeTableView selectRowAtIndexPath:ip2 animated:YES scrollPosition:UITableViewScrollPositionBottom];
            
            [self addSubview:_tradeTableView];
            
            
        }else if(index == 3){      //类别
            [_secondTableView removeFromSuperview];
            NSArray *arr = [_leibieDic allValues];
            NSMutableArray *muArr = [NSMutableArray arrayWithObjects:@"全部", nil];
            
            [muArr addObjectsFromArray:arr];
            _secondTableView = [[ChooseViewsecondTableView alloc]initWithFrame:CGRectMake(self.bounds.size.width * 0.333, 0, self.bounds.size.width * 0.667, self.bounds.size.height - 55) titleArray:muArr selectArray:typesMuSeclectArray  block:^(NSInteger index,NSInteger ifSelectNum){
                NSLog(@"index = %li",(long)index);
                NSArray *IDarr = [_leibieDic allKeys];
                if (index == 0) {
                    typesMuSeclectArray = [NSMutableArray arrayWithObjects:@"1",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",
                                           @"0",nil];
                    [typesIdArray removeAllObjects];
                    
                    [_secondTableView tableReloadData:muArr selectArray:typesMuSeclectArray];
                }else{
                   
                    NSString *IDstr = [NSString stringWithFormat:@"%@",[IDarr objectAtIndex:index - 1]];
                       [typesMuSeclectArray replaceObjectAtIndex:0  withObject:@"0"];
                    if (ifSelectNum == 1) {
                        [typesIdArray addObject:IDstr];
                        [typesMuSeclectArray replaceObjectAtIndex:index  withObject:@"1"];
                    }else{
                        [typesIdArray removeObject:IDstr];
                        [typesMuSeclectArray replaceObjectAtIndex:index  withObject:@"0"];
                    }
                    
                    [_secondTableView tableReloadData:muArr selectArray:typesMuSeclectArray];
                }
                 NSLog(@"typesIdArray = %@",typesIdArray);
            }];
            [self addSubview:_secondTableView];
            
            
        }else{   //我的筛选
            NSLog(@"我的筛选 = %@",_myChooseArray);
            [_mychooseTableView removeFromSuperview];
            
            _mychooseTableView = [[MyChooseTableView alloc]initWithFrame:CGRectMake(self.bounds.size.width * 0.333, 0, self.bounds.size.width * 0.667, self.bounds.size.height - 55) token:_token block:^(NSInteger index){
                NSString *urlStr =[NSString stringWithFormat:@"%@article/list?page=1&psize=10&fid=%@&access-token=%@",ApiUrlHead,[[_myChooseArray objectAtIndex:index] objectForKey:@"id"],_token];
                [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                    if ([code isEqualToString:@"0"]) {
                        NSArray *data = [responseObject objectForKey:@"data"];
                        _block(_parameters,data,[[_myChooseArray objectAtIndex:index] objectForKey:@"id"],3);
                        
                    }else if (![code isEqualToString:@"0"]){
                        NSString *error = [responseObject objectForKey:@"err"];
                        NSLog(@"error=%@",error);
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                        [alert show];
                        
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    
                    
                }];
            
            
            }];
            [self addSubview:_mychooseTableView];
         }
    }];
    
    [self addSubview:_firstTableView];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

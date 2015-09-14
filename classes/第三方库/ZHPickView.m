//
//  ZHPickView.m
//  ZHpickView
//
//  Created by liudianling on 14-11-18.
//  Copyright (c) 2014年 赵恒志. All rights reserved.
//
#define ZHToobarHeight 40
#import "ZHPickView.h"
#import "NSArray+Safe.h"
@interface ZHPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)NSArray * dataArrr;
@property(nonatomic,copy)NSString *plistName;
@property(nonatomic,strong)NSArray *plistArray;
@property(nonatomic,assign)BOOL isLevelArray;
@property(nonatomic,assign)BOOL isLevelString;
@property(nonatomic,assign)BOOL isLevelDic;
@property(nonatomic,strong)NSDictionary *levelTwoDic;
@property(nonatomic,strong)UIToolbar *toolbar;
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,assign)NSDate *defaulDate;
@property(nonatomic,assign)BOOL isHaveNavControler;
@property(nonatomic,assign)NSInteger pickeviewHeight;
@property(nonatomic,copy)NSString *resultString;
@property(nonatomic,copy)NSString *resultID;
@property(nonatomic,assign)NSInteger commen;
@property(nonatomic,assign)NSInteger rowww;

@property(nonatomic,strong)NSMutableArray *componentArray;
@property(nonatomic,strong)NSMutableArray *dicKeyArray;
@property(nonatomic,copy)NSMutableArray *state;
@property(nonatomic,copy)NSMutableArray *city;
@property(nonatomic,strong)NSMutableArray *childsArray;
@end

@implementation ZHPickView

-(NSArray *)plistArray{
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    return _plistArray;
}

-(NSArray *)componentArray{

    if (_componentArray==nil) {
        _componentArray=[[NSMutableArray alloc] init];
    }
    return _componentArray;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpToolBar];
        
    }
    return self;
}


-(instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        _plistName=plistName;
        self.plistArray=[self getPlistArrayByplistName:plistName];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
        
    }
    return self;
}
-(instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler{
    self=[super init];
    if (self) {
        _dataArrr = [NSArray array];
        _dataArrr = array;
        _firstCom = [NSMutableArray array];
        _secondCom = [NSMutableArray array];
        _secondComID = [NSMutableArray array];
        _secondDic = [NSMutableDictionary dictionary];
        _childsArray = [NSMutableArray array];
        
        NSMutableArray *array1 = [NSMutableArray array];
        NSLog(@"array = %@",array);
        for (NSDictionary *dic in array) {
            NSString *name = [dic objectForKey:@"name"];
            [array1 addObject:name];
        }
        [_firstCom addObjectsFromArray:array1];
        
        _secondDic = [array objectAtIndex:0];
        [_childsArray addObjectsFromArray:[[array objectAtIndex:_commen]objectForKey:@"childs"]];
        _shengString = [_secondDic objectForKey:@"name"];
        
        _shiString = [[_childsArray objectAtSafeIndex:_rowww]objectForKey:@"name"];
        
        _resultString = [NSString stringWithFormat:@"%@%@",_shengString,_shiString];
        
        
        _resultID = [NSString stringWithFormat:@"%@",[[_childsArray objectAtSafeIndex:_rowww]objectForKey:@"id"]];
        
        NSArray *array11 = [_secondDic objectForKey:@"childs"];
        for (NSDictionary *dic in array11) {
            NSString * name = [dic objectForKey:@"name"];
            [_secondCom addObject:name];
        }
        self.plistArray= array;
        [self setArrayClass:array1];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}

-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        _defaulDate=defaulDate;
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}


-(NSArray *)getPlistArrayByplistName:(NSString *)plistName{
    
    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray * array=[[NSArray alloc] initWithContentsOfFile:path];
    [self setArrayClass:array];
    return array;
}

-(void)setArrayClass:(NSArray *)array{
    _dicKeyArray=[[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray=YES;
            _isLevelString=NO;
            _isLevelDic=NO;
        }else if ([levelTwo isKindOfClass:[NSString class]]){
            _isLevelString=YES;
            _isLevelArray=NO;
            _isLevelDic=NO;
            
        }else if ([levelTwo isKindOfClass:[NSDictionary class]])
        {
            _isLevelDic=YES;
            _isLevelString=NO;
            _isLevelArray=NO;
            _levelTwoDic=levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
    }
}

-(void)setFrameWith:(BOOL)isHaveNavControler{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = _pickeviewHeight+ZHToobarHeight;
    CGFloat toolViewY ;
    if (isHaveNavControler) {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH-50;
    }else {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH;
    }
    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(toolViewX, toolViewY, toolViewW, toolViewH);
}
-(void)setUpPickView{
    
    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.backgroundColor=[UIColor lightGrayColor];
    _pickerView=pickView;
    pickView.delegate=self;
    pickView.dataSource=self;
    pickView.frame=CGRectMake(0, ZHToobarHeight, pickView.frame.size.width, pickView.frame.size.height);
    _pickeviewHeight=pickView.frame.size.height;
    [self addSubview:pickView];
}

-(void)setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode{
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = datePickerMode;
    datePicker.backgroundColor=[UIColor lightGrayColor];
    if (_defaulDate) {
        [datePicker setDate:_defaulDate];
    }
    _datePicker=datePicker;
    datePicker.frame=CGRectMake(0, ZHToobarHeight, datePicker.frame.size.width, datePicker.frame.size.height);
    _pickeviewHeight=datePicker.frame.size.height;
    [self addSubview:datePicker];
}

-(void)setUpToolBar{
    _toolbar=[self setToolbarStyle];
    [self setToolbarWithPickViewFrame];
    [self addSubview:_toolbar];
}
-(UIToolbar *)setToolbarStyle{
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    
    //在这该button
//    UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
//    [leftBtn setImage:[UIImage imageNamed:@"quxiao@2x.png"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *lefttem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    
    
    UIBarButtonItem*lefttem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(remove)];
    lefttem.tintColor=[UIColor blackColor];
    
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    right.tintColor=[UIColor blackColor];
    toolbar.items=@[lefttem,centerSpace,right];
    return toolbar;
}
-(void)setToolbarWithPickViewFrame{
    _toolbar.frame=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, ZHToobarHeight);
}

#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    NSInteger component;
    if (_isLevelArray) {
        component= 2;
    } else if (_isLevelString){
        component= 2 ;
    }else if(_isLevelDic){
        component=[_levelTwoDic allKeys].count*2;
    }
    return component;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
       return   _firstCom.count;
    }else{
       return  _secondCom.count;
    }
}

#pragma mark UIPickerViewdelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *rowTitle = [NSString string];
    if (component == 0) {
        rowTitle = [_firstCom objectAtIndex:row];
        
    }else if (component == 1){
       rowTitle = [_secondCom objectAtIndex:row];
    }
    
    return rowTitle;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if (component == 0) {
        _secondDic = [_plistArray objectAtIndex:row];
        NSLog(@" _plistArray = %@",_plistArray);
        [_secondCom removeAllObjects];
        [_secondComID removeAllObjects];
        [_childsArray removeAllObjects];
        [_childsArray  addObjectsFromArray:[_secondDic objectForKey:@"childs"]];
        NSLog(@"array = %@",_childsArray);
        for (NSDictionary *dic in _childsArray) {
            NSString * name = [dic objectForKey:@"name"];
            [_secondCom addObject:name];
            NSString * ID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            [_secondComID addObject:ID];
            NSLog(@"_secondCom = %@",_secondCom);
        }
        
        NSLog(@"_secondCom = %@",_secondCom);
         NSLog(@"_secondComID = %@",_secondComID);
        [pickerView reloadComponent:1];
        _resultString = [[_childsArray objectAtSafeIndex:0]objectForKey:@"name"];
        _resultID = [NSString stringWithFormat:@"%@",[[_childsArray objectAtSafeIndex:0]objectForKey:@"id"]];
        
         [pickerView selectRow:0 inComponent:1 animated:YES];
        
        _shengString = [_firstCom objectAtIndex:row];
        
        _shiString = [[_childsArray objectAtSafeIndex:0]objectForKey:@"name"];
       
    }else if (component == 1){
        _resultString = [[_childsArray objectAtSafeIndex:row]objectForKey:@"name"];
        _resultID = [NSString stringWithFormat:@"%@",[[_childsArray objectAtSafeIndex:row]objectForKey:@"id"]];
        _shiString = [_secondCom objectAtIndex:row];
        NSLog(@"_resultString = %@  && _resultID = %@",_resultString,_resultID);
    
    }
    
}

-(void)remove{
    
    [self removeFromSuperview];
}
-(void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}
-(void)doneClick
{
    _resultString = [NSString stringWithFormat:@"%@%@",_shengString,_shiString];
    if ([self.delegate respondsToSelector:@selector(toobarDonBtnHaveClick:resultID:resultString:)]) {
        [self.delegate toobarDonBtnHaveClick:self resultID:_resultID resultString:_resultString];
    }
    [self removeFromSuperview];
}
//设置pickerView的字体大小
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumFontSize = 14;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        // [pickerLabel setTextAlignment:UITextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;

}

/**
 *  设置PickView的颜色
 */
-(void)setPickViewColer:(UIColor *)color{
    _pickerView.backgroundColor=color;
}


/**
 *  设置toobar的文字颜色
 */
-(void)setTintColor:(UIColor *)color{
    
    _toolbar.tintColor=color;
}


/**
 *  设置toobar的背景颜色
 */
-(void)setToolbarTintColor:(UIColor *)color{
    
    _toolbar.barTintColor=color;
}
-(void)dealloc{
    
    //NSLog(@"销毁了");
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 

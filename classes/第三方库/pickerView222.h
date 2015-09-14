//
//  pickerView222.h
//  时时投
//
//  Created by h on 15/9/6.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHPickView;

@protocol ZHPickViewDelegate <NSObject>

@optional
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultID22:(NSString *)resultID22 resultString22:(NSString *)resultString22;

@end
@interface pickerView222 : UIView

@property(nonatomic,weak) id<ZHPickViewDelegate> delegate;
@property(nonatomic,strong)NSMutableArray *firstCom;
@property(nonatomic,strong)NSMutableArray *secondCom;
@property(nonatomic,strong)NSMutableArray *secondComID;
@property(nonatomic,strong)NSMutableDictionary *secondDic;
/**
 *  通过plistName添加一个pickView
 *
 *  @param plistName          plist文件的名字
 
 *  @param isHaveNavControler 是否在NavControler之内
 *
 *  @return 带有toolbar的pickview
 */
-(instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler;
/**
 *  通过plistName添加一个pickView
 *
 *  @param array              需要显示的数组
 *  @param isHaveNavControler 是否在NavControler之内
 *
 *  @return 带有toolbar的pickview
 */
-(instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler;

/**
 *  通过时间创建一个DatePicker
 *
 *  @param date               默认选中时间
 *  @param isHaveNavControler是否在NavControler之内
 *
 *  @return 带有toolbar的datePicker
 */
-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler;

/**
 *   移除本控件
 */
-(void)remove;
/**
 *  显示本控件
 */
-(void)show;
/**
 *  设置PickView的颜色
 */
-(void)setPickViewColer:(UIColor *)color;
/**
 *  设置toobar的文字颜色
 */
-(void)setTintColor:(UIColor *)color;
/**
 *  设置toobar的背景颜色
 */
-(void)setToolbarTintColor:(UIColor *)color;


@end

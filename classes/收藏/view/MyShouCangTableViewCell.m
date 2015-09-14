//
//  MyShouCangTableViewCell.m
//  时时投
//
//  Created by 熊良军 on 15/7/28.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "MyShouCangTableViewCell.h"

@implementation MyShouCangTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  title:(NSString *)title hangye:(NSString *)hangye location:(NSString *)location time:(NSString *)time detail:(NSString *)detail  titleFont:(NSInteger)font1 lableFont:(NSInteger)font2 titleSepFont:(NSInteger)font4{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self title:title hangye:hangye location:location time:time detail:detail titleFont:font1 lableFont:font2 titleSepFont:font4];
    }
    return self;
}

- (void)title:(NSString *)title hangye:(NSString *)hangye location:(NSString *)location time:(NSString *)time detail:(NSString *)detail   titleFont:(NSInteger)font1 lableFont:(NSInteger)font2 titleSepFont:(NSInteger)font4{
    NSArray *subViewArr = self.moveContentView.subviews;
    for (UIView *view in subViewArr) {
        [view removeFromSuperview];
    }
    _title = [[LableXLJ alloc]initWithFrame:CGRectMake(10, 10, self.bounds.size.width - 20, 45) text:title textColor:[UIColor colorWithWhite:0 alpha:1] font:(int)font1 numberOfLines:2 lineSpace:(int)font4];
    [self.contentView addSubview:_title];
    [self.moveContentView addSubview:_title];
    
    UILabel *hangye1 = [[UILabel alloc]initWithFrame:CGRectMake(10, _title.bounds.size.height + 17, 30, 10)];
    hangye1.text = @"行业:";
    hangye1.font = [UIFont systemFontOfSize:(int)font2];
    hangye1.textColor = [UIColor colorWithWhite:0.558 alpha:1];
    [self.moveContentView addSubview:hangye1];
    
    _hangye = [[UILabel alloc]initWithFrame:CGRectMake(hangye1.bounds.size.width + 10, hangye1.frame.origin.y, 110, hangye1.bounds.size.height)];
    _hangye.text = [NSString stringWithFormat:@" %@",hangye];
    _hangye.font = [UIFont systemFontOfSize:(int)font2];
    _hangye.textColor = [UIColor colorWithRed:0.9412 green:0.3255 blue:0.3373 alpha:1];
    [self.moveContentView addSubview:_hangye];
    
    UILabel *arealable = [[UILabel alloc]initWithFrame:CGRectMake(_hangye.frame.origin.x + _hangye.bounds.size.width + 10, _hangye.frame.origin.y, 30, 10)];
    arealable.text = @"地区:";
    arealable.font = [UIFont systemFontOfSize:(int)font2];
    arealable.textColor = [UIColor colorWithWhite:0.558 alpha:1];
    [self.moveContentView addSubview:arealable];
    
    _location = [[UILabel alloc]initWithFrame:CGRectMake(arealable.frame.origin.x + arealable.bounds.size.width , arealable.frame.origin.y, 85, 10)];
    if ([location isEqualToString:@"<null>"]) {
        location = @"跨省";
    }
    _location.text = [NSString stringWithFormat:@" %@",location];
    _location.font = [UIFont systemFontOfSize:(int)font2];
    _location.textColor = [UIColor colorWithRed:0.9412 green:0.3255 blue:0.3373 alpha:1];
    [self.moveContentView addSubview:_location];
    
    _time = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width - 100, _location.frame.origin.y, 90, 10)];
    _time.text = time;
    _time.font = [UIFont systemFontOfSize:10.0];
    _time.textColor = [UIColor colorWithWhite:0.558 alpha:1];
    _time.textAlignment = NSTextAlignmentRight;
    [self.moveContentView addSubview:_time];
    
    /* _detail = [[LableXLJ alloc]initWithFrame:CGRectMake(10, _location.frame.origin.y + _location.bounds.size.height + 12, self.bounds.size.width - 20, 55) text:[NSString stringWithFormat:@"%@",detail] textColor:[UIColor colorWithWhite:0.4006 alpha:1] font:11 numberOfLines:3 lineSpace:0];
    [self.moveContentView addSubview:_detail];*/
    
    _zanbtn = [[ZanButton alloc]initWithFrame:CGRectMake(135 , _time.frame.origin.y + _time.bounds.size.height + 7, 50, 25)];
    _zanbtn.tag = 0;
    [_zanbtn setImage:[UIImage imageNamed:@"zhaobiaozan@2x"] forState:UIControlStateNormal];
    [_zanbtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.moveContentView addSubview:_zanbtn];
    
    _liulanbtn = [[ZanButton alloc]initWithFrame:CGRectMake(135 + 50,_time.frame.origin.y + _time.bounds.size.height + 7, 50, 25)];
    _liulanbtn.tag = 1;
    [_liulanbtn setImage:[UIImage imageNamed:@"zhaobiaoliulan@2x"] forState:UIControlStateNormal];
    [_liulanbtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.moveContentView addSubview:_liulanbtn];
    
    _pinglunbtn = [[ZanButton alloc]initWithFrame:CGRectMake(135 + 100, _time.frame.origin.y + _time.bounds.size.height + 7, 50, 25)];
    _pinglunbtn.tag = 2;
    [_pinglunbtn setImage:[UIImage imageNamed:@"zhaobiaopinglun@2x"] forState:UIControlStateNormal];
    [_pinglunbtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.moveContentView addSubview:_pinglunbtn];
    
    
    
    _addOneLable = [[UILabel alloc]initWithFrame:CGRectMake(_zanbtn.frame.origin.x + 25, _zanbtn.frame.origin.y, 30, 15)];
    _addOneLable.text = @"+1";
    _addOneLable.textColor = [UIColor colorWithRed:0.2667 green:0.6941 blue:0.9059 alpha:1];
    _addOneLable.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_addOneLable];
    _addOneLable.alpha = 0;
    
    
    
    _morebtn = [[ZanButton alloc]initWithFrame:CGRectMake(135 + 150, _time.frame.origin.y + _time.bounds.size.height + 7, 50, 25)];
    _morebtn.tag = 3;
    [_morebtn setImage:[UIImage imageNamed:@"zhaobiaoMore@2x"] forState:UIControlStateNormal];
    [_morebtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.moveContentView addSubview:_morebtn];
    //文字中不同颜色设置
    /*NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:detail];
     [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
     [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
     [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
     [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:13.0] range:NSMakeRange(0, 5)];
     [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0] range:NSMakeRange(6, 12)];
     [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:13.0] range:NSMakeRange(19, 6)];
     _detail.attributedText = str;*/
}

- (void)hideAddOneLable{
    [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(hideAddOneLable1) userInfo:nil repeats:NO];
}
- (void)hideAddOneLable1{
    [UIView animateWithDuration:1.5 animations:^{_addOneLable.alpha = 0;} completion:nil];
}

- (void)blockButtonAction:(BlockButtonAction)block{
    _block = block;
}
- (void)action:(ZanButton *)btn{
    _block(btn.tag,1);
}
-(void)addControl{
    [super addControl];
    /*UIButton *vTestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vTestButton setFrame:CGRectMake(100, 20, 64, 44)];
    [vTestButton setTitle:@"点我吧" forState:UIControlStateNormal];
    [vTestButton addTarget:self action:@selector(testButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [vTestButton setBackgroundColor:[UIColor lightGrayColor]];
    //    vTestButton.center = self.moveContentView.center;
    
    UIImageView *vImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"haha"]];
    vImageView.frame = CGRectMake(200, 0, 320-200, 88);
    [self.moveContentView addSubview:vImageView];
    [self.moveContentView addSubview:vTestButton];*/
   
}
//
//-(void)testButtonClicked:(id)sender{
//    NSLog(@"点我了");
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

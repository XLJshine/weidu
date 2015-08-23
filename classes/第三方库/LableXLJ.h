//
//  LableXLJ.h
//  时时投
//
//  Created by 熊良军 on 15/7/24.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LableXLJ : UILabel
- (id)initWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color font:(int)fontNum numberOfLines:(int)lineNum  lineSpace:(int)spaceNum;
- (void)text:(NSString *)text textColor:(UIColor *)color font:(int)fontNum numberOfLines:(int)lineNum  lineSpace:(int)spaceNum;
@end

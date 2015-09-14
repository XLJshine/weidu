//
//  LableXLJ.m
//  时时投
//
//  Created by 熊良军 on 15/7/24.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "LableXLJ.h"

@implementation LableXLJ
- (id)initWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color font:(int)fontNum numberOfLines:(int)lineNum  lineSpace:(int)spaceNum{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfLines = lineNum;
        self.textColor = color;
        self.font = [UIFont systemFontOfSize:fontNum];
        NSString *testString = [NSString stringWithFormat:@"%@",text];
        // NSString *encoded = [testString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:testString];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:spaceNum];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [testString length])];
        [self setAttributedText:attributedString1];
        [self sizeToFit];
    }
    return self;
}
- (void)text:(NSString *)text textColor:(UIColor *)color font:(int)fontNum numberOfLines:(int)lineNum  lineSpace:(int)spaceNum{
    self.numberOfLines = lineNum;
    self.textColor = color;
    self.font = [UIFont systemFontOfSize:fontNum];
    NSString *testString = text;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:testString];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:spaceNum];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [testString length])];
    [self setAttributedText:attributedString1];
    [self sizeToFit];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

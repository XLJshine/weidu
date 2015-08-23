//
//  HeadTableView.m
//  时时投
//
//  Created by h on 15/7/22.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "HeadTableView.h"

@implementation HeadTableView
{
    BOOL _isChange;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)changeFrameHeight:(UIButton *)sender {
    if (_isChange) {
        _isChange = NO;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+100, self.frame.size.width, self.frame.size.height);
    }else{
        _isChange = YES;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-100, self.frame.size.width, self.frame.size.height);
    }
}

@end

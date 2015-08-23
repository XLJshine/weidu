//
//  ChoosePicView.m
//  时时投
//
//  Created by 熊良军 on 15/7/23.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import "ChoosePicView.h"

@implementation ChoosePicView
- (id)initWithFrame:(CGRect)frame  imageview:(NSString *)imagename viewtag:(NSInteger)tag   buttonBlock:(BlockButton)block  BlockImage:(BlockImage)block1{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *view = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:view];
        _imageview = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageview.tag = tag;
        [_imageview setImageURLStr:imagename placeholder:[UIImage imageNamed:@"chaangtiao4@2x"]];
        _imageview.clipsToBounds = YES;
        _imageview.contentMode = UIViewContentModeScaleAspectFill;
        _imageview.userInteractionEnabled = YES;
        [_imageview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        [view addSubview:_imageview];
        
        _downloadButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 18, self.bounds.size.width, 18)];
        _downloadButton.tag = tag;
        [_downloadButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.1]];
        if (tag == 0) {
             [_downloadButton setImage:[UIImage imageNamed:@"xuanze@2x"] forState:UIControlStateNormal];
        }else{
             [_downloadButton setImage:[UIImage imageNamed:@"xiazai@2x"] forState:UIControlStateNormal];
        }
        [_downloadButton addTarget:self action:@selector(downAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_downloadButton];
        
        _block = block;
        _block1 = block1;
        
    }
    return self;
}
- (void)tapImage:(UITapGestureRecognizer *)tap{
    _block1(tap.view.tag);
}
- (void)downAction:(UIButton *)btn{
    _block(btn.tag);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

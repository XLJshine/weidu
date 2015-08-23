//
//  MimaChangeTableViewCell.h
//  时时投
//
//  Created by 熊良军 on 15/8/17.
//  Copyright (c) 2015年 yunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MimaChangeTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic ,strong)UITextField *textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title1   backgroundimage:(UIImage *)backgroundimage1;
- (void)title:(NSString *)title1  backgroundimage:(UIImage *)backgroundimage1;
@end

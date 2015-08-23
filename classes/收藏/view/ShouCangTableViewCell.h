//
//  ShouCangTableViewCell.h
//  时时投
//
//  Created by 熊良军 on 15/7/28.
//  Copyright (c) 2015年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShouCangTableViewCellDelegate <NSObject>

-(void)didCellWillHide:(id)aSender;
-(void)didCellHided:(id)aSender;
-(void)didCellWillShow:(id)aSender;
-(void)didCellShowed:(id)aSender;
-(void)didCellClickedDeleteButton:(id)aSender index:(NSInteger)index;
-(void)didCellClickedMoreButton:(id)aSender;
@end
@interface ShouCangTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>
{
    CGFloat startLocation;
    BOOL    hideMenuView;
}

@property (strong, nonatomic) IBOutlet UIView *moveContentView;
@property (nonatomic,assign) id<ShouCangTableViewCellDelegate> delegate;

-(void)hideMenuView:(BOOL)aHide Animated:(BOOL)aAnimate;
-(void)addControl;
@end

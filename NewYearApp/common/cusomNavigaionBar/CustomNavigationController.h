//
//  CustomNavigationController.h
//  WldhClient
//
//  Created by dyn on 13-8-22.
//  Copyright (c) 2013年 guoling. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomNavigaionBarDelegate <NSObject>


//左侧按钮的点击回调
- (void)backButtonAction;
@end

@interface CustomNavigationController : UINavigationController
<UINavigationControllerDelegate>
{
    CGPoint startTouch;
    
    UIImageView *_lastScreenShotView;
    UIView *_blackMask;
}
@property(nonatomic,assign) id<CustomNavigaionBarDelegate> customDelegate;
@property(nonatomic,retain) UIButton    *backButton;
@property (nonatomic, copy, setter=setTitle:, getter=title) NSString* title;
@property(nonatomic,assign)BOOL isNeedPopActive;
@property(nonatomic,assign)BOOL isNeedBackButton;

@property(nonatomic,assign) BOOL canDragBack;  //是否允许返回手势
@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;
@property (nonatomic,assign) BOOL isMoving;
@property(nonatomic,assign) BOOL isNotBack;
@property(nonatomic,assign) CGRect ingroRect;//忽略滑动手势的区域

// get the current view screen shot
- (UIImage *)capture;

- (UIView *)createTitleView:(NSString *)titleStr;
- (void)popself;
@end

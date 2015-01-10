//
//  PersonalCenterViewController.h
//  NewYearApp
//
//  Created by chenliqian on 14-12-21.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCenterViewController : BaseViewController<UITextViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *PersonalImg;
@property (strong, nonatomic) IBOutlet UILabel *PersonalName;
@property (strong, nonatomic) IBOutlet UILabel *PersonalLeve;
@property (strong, nonatomic) IBOutlet UILabel *PersonalPhone;
@property (strong, nonatomic) IBOutlet UITextView *PersonalSigh;
@property (retain, nonatomic) IBOutlet UIButton *zanBtn;
@property (retain, nonatomic) IBOutlet UILabel *zanNumLabel;
@property (retain, nonatomic) IBOutlet UIImageView *zanImg;

@property (nonatomic,copy)NSString *phoneNum;//传当前点击的号码
//@property (nonatomic,copy)NSString *isSelect;//传当前点击的号码

@property (nonatomic)BOOL isSelect;//传当前是否选中状态

@end

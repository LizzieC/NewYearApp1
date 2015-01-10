//
//  TabBarController.h
//  NewYearApp
//
//  Created by chenliqian on 14-12-17.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController
{
    UIView *tabBarView;//创建一个UIView，用于放入各个按钮
    int                                 _currentSelectedIndex;  //当前选择按钮所属位置
}
@property(nonatomic, assign)int currentSelectedIndex;
// 自定义TabBar标签按钮
- (void)customTabBar;

@end

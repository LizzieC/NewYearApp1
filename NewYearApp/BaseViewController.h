//
//  BaseViewController.h
//  WldhClient
//
//  Created by mini1 on 13-9-4.
//  Copyright (c) 2013年 guoling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseViewController : UIViewController

/*************************
 函数描述:添加滑动手势
 输入参数:N/A
 输出参数:N/A
 返回值 : N/A
 **************************/
- (void)addSwapFunction;

- (void)swapToLeft;

- (void)swapToRight;

@end

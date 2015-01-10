//
//  BaseViewController.m
//  WldhClient
//
//  Created by mini1 on 13-9-4.
//  Copyright (c) 2013年 guoling. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@implementation BaseViewController

/*************************
 函数描述:添加滑动手势
 输入参数:N/A
 输出参数:N/A
 返回值 : N/A
 **************************/
- (void)addSwapFunction
{
    return;
    BOOL isSwapLeft = NO;
    BOOL isSwapRight = NO;
    NSArray *rList = [self.view gestureRecognizers];
    for (id aRecognizer in rList)
    {
        if ([aRecognizer isKindOfClass:[UISwipeGestureRecognizer class]])
        {
            UISwipeGestureRecognizer *bRecon = (UISwipeGestureRecognizer *)aRecognizer;
            if (bRecon.direction == UISwipeGestureRecognizerDirectionLeft)
            {
                isSwapLeft = YES;
                NSLog(@"已经添加向左的滑动手势");
            }
            else if (bRecon.direction == UISwipeGestureRecognizerDirectionRight)
            {
                isSwapRight = YES;
                NSLog(@"已经添加向右的滑动手势");
            }
            
            if (isSwapRight && isSwapLeft)
            {
                return;
            }
        }
    }
    
    if (!isSwapLeft)
    {
        UISwipeGestureRecognizer *mySwapGestureRecognizer = [[UISwipeGestureRecognizer alloc] init];
        mySwapGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [mySwapGestureRecognizer addTarget:self action:@selector(viewSwap:)];
        
        [self.view addGestureRecognizer:mySwapGestureRecognizer];
        [mySwapGestureRecognizer release];
    }
    
    if (!isSwapRight)
    {
        UISwipeGestureRecognizer *rightSwapGestureRecognizer = [[UISwipeGestureRecognizer alloc] init];
        rightSwapGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [rightSwapGestureRecognizer addTarget:self action:@selector(viewSwap:)];
        
        [self.view addGestureRecognizer:rightSwapGestureRecognizer];
        [rightSwapGestureRecognizer release];
    }
}

- (void)viewSwap:(UISwipeGestureRecognizer *)swapGestureRecognizer
{
    if (swapGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if (swapGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) //向左滑动
        {
            [self performSelectorOnMainThread:@selector(swapToLeft) withObject:nil waitUntilDone:YES];
        }
        else if (swapGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) //向右滑动
        {
            [self performSelectorOnMainThread:@selector(swapToRight) withObject:nil waitUntilDone:YES];
        }
    }
}

- (void)swapToLeft
{
    NSLog(@"-----%@ 向左滑动------",NSStringFromClass([self class]));
}

- (void)swapToRight
{
    NSLog(@"-----%@ 向右滑动------",NSStringFromClass([self class]));
    CustomNavigationController *myNav = (CustomNavigationController *)self.navigationController;
    if (myNav == nil || [myNav.viewControllers count] <= 1)
    {
        return;
    }
    if(myNav.customDelegate &&
       [ myNav.customDelegate respondsToSelector:@selector(backButtonAction)])
    {
        [myNav.customDelegate backButtonAction];
    }
    else
    {
        if(myNav.isNeedPopActive == NO)
        {
            [myNav popViewControllerAnimated:YES];
        }
        else
        {
            CATransition* transition = [CATransition animation];
            transition.duration = 0.4;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;//kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
            transition.subtype = kCATransitionFromLeft;//kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
            [myNav.view.layer addAnimation:transition forKey:nil];
            [myNav popViewControllerAnimated:NO];
        }
    }
}

- (void)setTitle:(NSString *)title
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        if (self.navigationController
            && [self.navigationController isKindOfClass:[CustomNavigationController class]])
        {
            CustomNavigationController *aNav = (CustomNavigationController *)self.navigationController;
            self.navigationItem.titleView = [aNav createTitleView:title];
        }
        else
        {
            [super setTitle:title];
        }
    }
    else
    {
        [super setTitle:title];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = kDialViewBgColor;
}

@end

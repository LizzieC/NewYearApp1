//
//  CustomNavigationController.m
//  WldhClient
//
//  Created by dyn on 13-8-22.
//  Copyright (c) 2013年 guoling. All rights reserved.
//

#import "CustomNavigationController.h"
#import <QuartzCore/QuartzCore.h>
@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect
{
    //    UIImage *image = [UIImage imageNamed: @"CustomizedNavBarBg.png"];
    //    [image drawInRect:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height/2)];
    if (kWldhClientIsIOS7)
    {
        [self setTintColor:kNavigationBarTintColor];
        [self setBarTintColor:kNavigationBarBgColor];
    }
    else
    {
        [self setTintColor:kNavigationBarBgColor];
    }
}
@end

@implementation CustomNavigationController
@synthesize customDelegate;
@synthesize backButton;
@synthesize title;
@synthesize isNeedPopActive;
@synthesize isNeedBackButton;


@synthesize backgroundView;
@synthesize screenShotsList;
@synthesize isMoving = _isMoving;
@synthesize canDragBack;
@synthesize isNotBack;

@synthesize ingroRect;

//调试图片大小
- (UIImage *)transformToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    UIImage *image = [UIImage imageNamed: @"CustomizedNavBarBg.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [imageView release];
    return scaledImage;
}

- (UIImage*)createImageWithColor: (UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController])
	{
        self.isNeedPopActive = NO;
        self.isNeedBackButton = YES;
        
        if (kWldhClientIsIOS7)
        {
            self.navigationBar.tintColor = kNavigationBarTintColor;
            self.navigationBar.barTintColor = kNavigationBarBgColor;
        }
        else
        {
            self.navigationBar.tintColor = kNavigationBarBgColor;
        }
        
        [self.navigationBar setBackgroundImage: kWldhClientIsIOS7 ? [self createImageWithColor:kNavigationBarBgColor] : [self createImageWithColor:kNavigationBarBgColor]
                                 forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setBackgroundColor:kNavigationBarBgColor];
        
        
        self.screenShotsList = [[[NSMutableArray alloc]initWithCapacity:2]autorelease];
        self.canDragBack = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIPanGestureRecognizer *recognizer = [[[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(paningGestureReceive:)]autorelease];
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
}

- (UIView *)createTitleView:(NSString *)titleStr
{
    UILabel *tempTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 44)];
    tempTitleLabel.textAlignment = NSTextAlignmentCenter;
    tempTitleLabel.backgroundColor = [UIColor clearColor];
    tempTitleLabel.textColor = kCustomNavigationBarTextColor;
    tempTitleLabel.font = kCustomNavigationBarFont;
    tempTitleLabel.text = titleStr;
    return [tempTitleLabel autorelease];
}

- (UIBarButtonItem*) createBackButton:(NSString *)title
{
    UIImage *imageNormal= [UIImage imageNamed:@"back.png"];
    UIImage *imageHighted = [UIImage imageNamed:@"back.png"];
    
    CGRect backframe= CGRectMake(0, 0, imageNormal.size.width/2, imageNormal.size.height/2);
    backframe.origin.x -= kMoreNavigationButtonFrameOX;
    
    UIButton  *tempBackButton= [UIButton buttonWithType:UIButtonTypeCustom];
    
    tempBackButton.frame = backframe;
    [tempBackButton setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [tempBackButton setBackgroundImage:imageHighted forState:UIControlStateHighlighted];
    [tempBackButton setTitleColor:kCustomNavigationBarBackButtonTextColor forState:UIControlStateNormal];
    [tempBackButton setTitleColor:kCustomNavigationBarBackButtonTextHighlightedColor forState:UIControlStateHighlighted];
    
    tempBackButton.titleLabel.font=kCustomNavigationBarBackButtonTextFont;
    
    [tempBackButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    //定制自己的风格的  UIBarButtonItem
    UIBarButtonItem* someBarButtonItem= [[[UIBarButtonItem alloc] initWithCustomView:tempBackButton] autorelease];
    
    return someBarButtonItem;
}

- (void)popself
{
    if(self.customDelegate &&
       [ self.customDelegate respondsToSelector:@selector(backButtonAction)])
    {
        [self.customDelegate backButtonAction];
    }
    else
    {
        if(self.isNeedPopActive == NO)
        {
            [self popViewControllerAnimated:YES];
        }
        else
        {
            CATransition* transition = [CATransition animation];
            transition.duration = 0.4;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;//kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
            transition.subtype = kCATransitionFromLeft;//kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
            [self.view.layer addAnimation:transition forKey:nil];
            [self popViewControllerAnimated:NO];
            
        }
    }
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([self capture])
    {
        [self.screenShotsList addObject:[self capture]];
    }
    
    [super pushViewController:viewController animated:animated];
    
    viewController.navigationItem.titleView =[self createTitleView:viewController.title];
    
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1)
    {
        NSString *str = [viewController parentViewController].title;
        if(self.isNeedBackButton)
        {
            viewController.navigationItem.leftBarButtonItem = [self createBackButton:str];
        }
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeLastObject];
    self.isNotBack = NO;
    
    return [super popViewControllerAnimated:animated];
}


- (void)dealloc
{
    self.screenShotsList = nil;
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    
    [super dealloc];
}

-(void) setTitle:(NSString*)titleText
{
    self.tabBarController.navigationController.navigationItem.titleView = [self createTitleView:titleText];
    //self.navigationItem.titleView = [self createTitleView:titleText];
}

-(NSString*) title
{
	return self.navigationController.navigationItem.title ;
}

#pragma mark - Utility Methods -

// get the current view screen shot
- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

// set lastScreenShotView 's position and alpha when paning
- (void)moveViewWithX:(float)x
{
    
    NSLog(@"Move to:%f",x);
    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float scale = (x/6400)+0.95;
    float alpha = 0.4 - (x/800);
    
    _lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    _blackMask.alpha = alpha;
    
}

#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    if (!CGRectIsEmpty(self.ingroRect))
    {
        CGPoint pos = [recoginzer locationInView:self.view];
        if (CGRectContainsPoint(self.ingroRect,pos))
        {
            return;
        }
    }
    
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication] keyWindow]];
    
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan)
    {
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)]autorelease];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
            _blackMask = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)]autorelease];
            _blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:_blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (_lastScreenShotView) [_lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        _lastScreenShotView = [[[UIImageView alloc]initWithImage:lastScreenShot] autorelease];
        [self.backgroundView insertSubview:_lastScreenShotView belowSubview:_blackMask];
        
        //End paning, always check that if it should move right or move left automatically
    }
    else if (recoginzer.state == UIGestureRecognizerStateEnded)
    {
        if (touchPoint.x - startTouch.x > 160)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:320];
            } completion:^(BOOL finished) {
                if (!self.isNotBack)
                {
                    [self popViewControllerAnimated:NO];
                }
                else
                {
                    [self.screenShotsList removeLastObject];
                    self.isNotBack = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigationControllerBack" object:nil userInfo:nil];
                }
                
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
        
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    // it keeps move with touch
    if (_isMoving)
    {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}

@end

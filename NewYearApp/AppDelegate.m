//
//  AppDelegate.m
//  NewYearApp
//
//  Created by chenliqian on 14-12-17.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "LoginViewController.h"
#import "ContactViewController.h"
#import "MsgViewController.h"
#import "VoteViewController.h"


static AppDelegate *g_wldhClientDelegate = nil;

@implementation AppDelegate
@synthesize splashView;
- (void)dealloc
{
    [super dealloc];
}
+ (AppDelegate *)shareWldhClientDelegate
{
    return g_wldhClientDelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self createMainView];
    [self.window makeKeyAndVisible];
    /**
    splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
    splashView.image = [UIImage imageNamed:@"Default.png"];
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];
    
    [self performSelector:@selector(scale_1) withObject:nil afterDelay:0.0f];
    [self performSelector:@selector(scale_2) withObject:nil afterDelay:0.5f];
    [self performSelector:@selector(scale_3) withObject:nil afterDelay:1.0f];
    [self performSelector:@selector(scale_4) withObject:nil afterDelay:1.5f];
    [self performSelector:@selector(scale_5) withObject:nil afterDelay:2.0f];
    [self performSelector:@selector(showWord) withObject:nil afterDelay:2.5f];
    **/
    return YES;
}

-(void)scale_1
{
    UIImageView *round_1 = [[UIImageView alloc]initWithFrame:CGRectMake(100, 240, 15, 15)];
    round_1.image = [UIImage imageNamed:@"zan_nol.png"];
    [splashView addSubview:round_1];
    [self setAnimation:round_1];
}

-(void)scale_2
{
    UIImageView *round_2 = [[UIImageView alloc]initWithFrame:CGRectMake(105, 210, 20, 20)];
    round_2.image = [UIImage imageNamed:@"zan_sel.png"];
    [splashView addSubview:round_2];
    [self setAnimation:round_2];
}

-(void)scale_3
{
    UIImageView *round_3 = [[UIImageView alloc]initWithFrame:CGRectMake(125, 170, 30, 30)];
    round_3.image = [UIImage imageNamed:@"cancelZan.png"];
    [splashView addSubview:round_3];
    [self setAnimation:round_3];
}

-(void)scale_4
{
    UIImageView *round_4 = [[UIImageView alloc]initWithFrame:CGRectMake(160, 135, 40, 40)];
    round_4.image = [UIImage imageNamed:@"zan.png"];
    [splashView addSubview:round_4];
    [self setAnimation:round_4];
}

-(void)scale_5
{
    UIImageView *heart_1 = [[UIImageView alloc]initWithFrame:CGRectMake(130, 180, 100, 100)];
    heart_1.image = [UIImage imageNamed:@"login_icon.png"];
    [splashView addSubview:heart_1];
    [self setAnimation:heart_1];
}

-(void)setAnimation:(UIImageView *)nowView
{
    [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationOptionCurveLinear
                     animations:^
     {
         // 执行的动画code
         [nowView setFrame:CGRectMake(nowView.frame.origin.x- nowView.frame.size.width*0.1, nowView.frame.origin.y-nowView.frame.size.height*0.1, nowView.frame.size.width*1.2, nowView.frame.size.height*1.2)];
     }
                     completion:^(BOOL finished)
     {
         // 完成后执行code
         [nowView removeFromSuperview];
     }
     ];
    
}

-(void)showWord
{
    
    UIImageView *word_ = [[UIImageView alloc]initWithFrame:CGRectMake(75, 440, 170, 29)];
    word_.image = [UIImage imageNamed:@"word_"];
    [splashView addSubview:word_];
    
    word_.alpha = 0.0;
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveLinear
                     animations:^
     {
         word_.alpha = 1.0;
     }
                     completion:^(BOOL finished)
     {
         // 完成后执行code
         [NSThread sleepForTimeInterval:1.0f];
         [splashView removeFromSuperview];
         
         [self createMainView];
     }
     ];
}

- (void)createMainView
{
    TabBarController *tabBar = [[TabBarController alloc]init];
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    //初始化子控制器
    MsgViewController *aViewCor = [[MsgViewController alloc] init];
    aViewCor.title = @"消息";
    VoteViewController *bViewCor = [[VoteViewController alloc] init];
    bViewCor.title = @"投片";
    ContactViewController *cViewCor = [[ContactViewController alloc] init];
    cViewCor.title = @"全部员工";
    
    [controllers addObject:aViewCor];
    [controllers addObject:bViewCor];
    [controllers addObject:cViewCor];
    
    tabBar.viewControllers = controllers;
    [tabBar customTabBar];
    
    CustomNavigationController *navigationBar = [[CustomNavigationController alloc]initWithRootViewController:tabBar];
    CGFloat plateOy = navigationBar.view.frame.size.height - 225 - 69 - 44 - 86;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        plateOy += kWldhClientIsIphone5 ? 72 : 86;
    }
    else
    {
        plateOy += kWldhClientIsIphone5 ? 76 : 86;
    }
    aViewCor.MsgRect = CGRectMake(navigationBar.view.frame.size.width - 320,
                                  plateOy,
                                  320,
                                  225);
    if (kWldhClientIsIOS7)
    {
        navigationBar.navigationBar.barTintColor = kNavigationBarBgColor;
        navigationBar.navigationBar.tintColor = kNavigationBarTintColor;
    }
    else
    {
        navigationBar.navigationBar.tintColor = kNavigationBarBgColor;
    }
    
    self.window.rootViewController = navigationBar;
    [self.window makeKeyAndVisible];
    
    //获取uid/pwd
    //是否需要登录界面
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *phone = [userDefaults objectForKey:kPhone];
    if (phone.length == 0) {
        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        loginViewController.view.frame = [[UIScreen mainScreen] applicationFrame];
        UINavigationController *LoginNavigationBar = [[UINavigationController alloc]initWithRootViewController:loginViewController];
        [self.window addSubview:LoginNavigationBar.view];
        [self.window bringSubviewToFront:LoginNavigationBar.view];
    }
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

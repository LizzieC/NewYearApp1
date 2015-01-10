//
//  TabBarController.m
//  NewYearApp
//
//  Created by chenliqian on 14-12-17.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import "TabBarController.h"
#import "MsgViewController.h"
#import "VoteViewController.h"

static TabBarController* g_wldhTabBar = NULL;

@interface TabBarController ()
@end

@implementation TabBarController
@synthesize currentSelectedIndex = _currentSelectedIndex;

- (void)dealloc
{
    [super dealloc];
    R(tabBarView);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
          g_wldhTabBar = self;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    g_wldhTabBar = self;
}

// 类的单实例
+ (TabBarController *)shareWldhTabBar
{
    if(g_wldhTabBar == nil)
    {
        g_wldhTabBar = [[TabBarController alloc] init];
    }
    
    return g_wldhTabBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

// 自定义TabBar标签按钮
- (void)customTabBar
{
    //隐藏原有的TabBar标签按钮
    [self hideRealTabBar];
    
    //创建按钮
    [self createtabBarButtons];
    
}
// 隐藏原有的TabBar标签按钮
- (void)hideRealTabBar
{
	for(UIView *view in self.view.subviews)
    {
		if([view isKindOfClass:[UITabBar class]])
        {
			view.hidden = YES;
			break;
		}
	}
}


//创建自定义tabBar
- (void)createtabBarButtons {
   // iphone中获取屏幕分辨率的方法
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 49, width, 49)];//49为tabBar的高度
    tabBarView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    tabBarView.backgroundColor = [UIColor whiteColor];//设置tabBar的背景颜色
    [self.view addSubview:tabBarView];
    
    NSArray *backgroud = @[@"tab_0_nol.png",@"tab_1_nol.png",@"tab_2_nol.png"];//tabBarItem中的按钮
    NSArray *heightBackground = @[@"tab_0_pre.png",@"tab_1_pre.png",@"tab_2_pre.png"];//tabBarItem中高亮时候的按钮
    //将按钮添加到自定义的_tabbarView中，并为按钮设置tag（tag从0开始）
    for (int i=0; i<backgroud.count; i++) {
        NSString *backImage = backgroud[i];
        NSString *heightImage = heightBackground[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width/3*i +(320/3-106)/2, (49-30)/2, 106, 30);
//        button.backgroundColor = [UIColor redColor];
        button.tag = i +100;
        [button setImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:heightImage] forState:UIControlStateSelected];
        if (i==0) {
            button.selected=YES;
        }
        [button addTarget:self action:@selector(selectTabBarIndex:) forControlEvents:UIControlEventTouchUpInside];
        [tabBarView addSubview:button];
    }
}

//选择某个tab栏
- (void)selectTabBarIndex:(UIButton *)button
{
    button.selected=YES;
    int nextIndex=button.tag - 100;
    if (nextIndex!=_currentSelectedIndex) {
        UIButton *btn=(UIButton*)[tabBarView viewWithTag:_currentSelectedIndex+100];
        btn.selected=NO;
        _currentSelectedIndex=nextIndex;
        self.selectedIndex=nextIndex;
    }
    else
    {
        //刷新table数据
        switch (nextIndex)
        {
            case 0:
            {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"loadMsgWebViewNotifacation" object:self];
            }
                break;
            case 1:
            {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"loadVoteWebViewNotifacation" object:self];
            }
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

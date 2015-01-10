//
//  VoteViewController.m
//  NewYearApp
//
//  Created by chenliqian on 14-12-17.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import "VoteViewController.h"

@interface VoteViewController ()

@end

@implementation VoteViewController
{
    UILabel *tipsLabel;
    UIWebView *VoteWebView;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadVoteWebViewNotifacation" object:nil];
    R(VoteWebView);
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    CustomNavigationController *customNavigation =(CustomNavigationController *)self.tabBarController.navigationController;
    customNavigation.isNeedPopActive = YES;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.titleView = [customNavigation createTitleView:@"投票"];

    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"投票";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadWebview)
                                                 name:@"loadVoteWebViewNotifacation" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];

    tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320, 60)];
    tipsLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    tipsLabel.text = @"小伙伴们,别心急\n年会投票还没开始呢";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.numberOfLines = 0;
    tipsLabel.textColor = [UIColor grayColor];
    tipsLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipsLabel];
    tipsLabel.hidden = YES;
    R(tipsLabel);
    
     VoteWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight - 64 - 49)];
    [VoteWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kVoteURL]]];
    VoteWebView.delegate = self;
    [self.view addSubview:VoteWebView];
      VoteWebView.hidden = NO;
    [SVProgressHUD showInView:self.navigationController.view
                       status:@"请稍候"
             networkIndicator: NO
                         posY: -1
                     maskType: SVProgressHUDMaskTypeClear];
    _loadTimerout = [NSTimer scheduledTimerWithTimeInterval:30
                                                     target:self
                                                   selector:@selector(handleTimerOut)
                                                   userInfo:nil
                                                    repeats:NO];

}

-(void)handleTimerOut
{
    [SVProgressHUD dismiss];
}

- (void)loadWebview
{
    [VoteWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kVoteURL]]];
    [SVProgressHUD showInView:self.navigationController.view
                       status:@"请稍候"
             networkIndicator: NO
                         posY: -1
                     maskType: SVProgressHUDMaskTypeClear];
    _loadTimerout = [NSTimer scheduledTimerWithTimeInterval:30
                                                     target:self
                                                   selector:@selector(handleTimerOut)
                                                   userInfo:nil
                                                    repeats:NO];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", request.URL.relativeString);
    
    return YES;
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    if(_loadTimerout)
    {
        [_loadTimerout invalidate];
        _loadTimerout = nil;
    }
    [SVProgressHUD dismiss];
    
}

-(void)dismissHUD
{
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webview didFailLoadWithError %@ , and err is %@", webView.debugDescription, error.debugDescription);

     tipsLabel.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

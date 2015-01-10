//
//  MsgViewController.m
//  NewYearApp
//
//  Created by chenliqian on 14-12-17.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import "MsgViewController.h"
#import "PersonalCenterViewController.h"
#import "WebViewController.h"
#import "UIImageView+WebCache.h"

@interface MsgViewController ()

@end

@implementation MsgViewController
{
    UIWebView *MsgWebView;
}
@synthesize MsgRect;
-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loginSucessNotficaiton" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadMsgWebViewNotifacation" object:nil];
 R(MsgWebView);
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
    CustomNavigationController *customNavigation =(CustomNavigationController *)self.tabBarController.navigationController;
    customNavigation.isNeedPopActive = YES;
     self.tabBarController.navigationItem.titleView = [customNavigation createTitleView:@"公告"];
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.navigationController.navigationBar.hidden = NO;

    [self createLeftBarButton];
    [super viewWillAppear:animated];
}

- (void)createLeftBarButton
{
    UIButton *loginUB = [UIButton buttonWithType:UIButtonTypeCustom];
    loginUB.frame = CGRectMake(0, 5, 35, 35);
    [loginUB addTarget:self action:@selector(centerClick) forControlEvents:UIControlEventTouchUpInside];
    [loginUB setHidden:NO];
    NSString *imgRUL = [NHUtils getValueForKey:kSubImag];
   
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35 , 35)];
    if (imgRUL.length > 0)
    {
        [imageView setImageWithURL:[NSURL URLWithString:imgRUL] placeholderImage:[UIImage imageNamed:@"login_icon.png"] options:SDWebImageLowPriority];
//        [imageView setImageWithURL:[NSURL URLWithString:imgRUL] placeholderImage: [UIImage imageNamed:@"login_icon.png"]];
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"login_icon.png"];
    }
    
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 17.5;
    [loginUB addSubview:imageView];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:loginUB];
    self.tabBarController.navigationItem.leftBarButtonItem = leftBtn;
    R(imageView);R(leftBtn);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
      _loadTimerout = nil;
    
    //获取当前网络环境
    PhoneNetType netType = [NHUtils getPhoneNetMode];
    if(netType == PNT_UNKNOWN)
    {
        [WSPromptHUD showInView:self.view info:@"请检查您的网络后重试" isCenter:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createLeftBarButton)
                                                 name:@"loginSucessNotficaiton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadWebview)
                                                 name:@"loadMsgWebViewNotifacation" object:nil];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    MsgWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight- 49 - 64)];
    [MsgWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kMsgUrl]]];
    MsgWebView.delegate = self;
    [self.view addSubview:MsgWebView];
    
}

-(void)handleTimerOut
{
    [SVProgressHUD dismiss];
}

- (void)loadWebview
{
    [MsgWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kMsgUrl]]];
    [SVProgressHUD showInView:[UIApplication sharedApplication].keyWindow
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
- (void)centerClick
{
    PersonalCenterViewController *personalCenter = [[PersonalCenterViewController alloc]initWithNibName:@"PersonalCenterViewController" bundle:[NSBundle mainBundle]];
    personalCenter.phoneNum = [[NSUserDefaults standardUserDefaults]objectForKey:kPhone];
    [self.navigationController pushViewController:personalCenter animated:YES];
    R(personalCenter);
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", request.URL.relativeString);
    NSString *str = request.URL.relativeString;
    NSRange range = [request.URL.relativeString rangeOfString:@"inweb?param="];
    if (range.length > 0)
    {
        NSRange paramRange = NSMakeRange(range.location+range.length, str.length - (range.location+range.length));
        NSString *paramStr = [str substringWithRange:paramRange];
        if ([paramStr rangeOfString:@"\'"].length > 0)
        {
            paramStr = [paramStr stringByReplacingOccurrencesOfString:@"\'" withString:[NSString stringWithFormat:@"\""]];
        }
        if ([paramStr rangeOfString:@"%7B"].length > 0)
        {
            paramStr = [paramStr stringByReplacingOccurrencesOfString:@"%7B" withString:[NSString stringWithFormat:@"{"]];
        }
        if ([paramStr rangeOfString:@"%7D"].length > 0)
        {
            paramStr = [paramStr stringByReplacingOccurrencesOfString:@"%7D" withString:[NSString stringWithFormat:@"}"]];
        }
        if ([paramStr rangeOfString:@"%20"].length > 0)
        {
            paramStr = [paramStr stringByReplacingOccurrencesOfString:@"%20" withString:[NSString stringWithFormat:@""]];
        }
        if ([paramStr rangeOfString:@"%22"].length > 0)
        {
            paramStr = [paramStr stringByReplacingOccurrencesOfString:@"%22" withString:[NSString stringWithFormat:@"\""]];
        }
        
        NSDictionary *paramDict = [paramStr JSONValue];
        if (nil != paramDict)
        {
            NSString *url = [paramDict objectForKey:@"url"];
            //调用系统浏览器
            WebViewController *web = [[WebViewController alloc]init];
            [web setTitle:nil withURL:url];
            [self.navigationController pushViewController:web animated:YES];
        }
    }
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

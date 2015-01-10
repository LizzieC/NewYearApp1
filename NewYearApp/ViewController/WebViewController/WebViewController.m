//
//  WebViewController.m
//  NewYearApp
//
//  Created by chenliqian on 14-12-23.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
{
    UIWebView *_mainWebView;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    _mainWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 20)];
    _loadTimerout = nil;
    [_mainWebView setOpaque:NO];
    [_mainWebView setBackgroundColor:[UIColor clearColor]];
    [_mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlRequest]]];
    [_mainWebView setScalesPageToFit:YES];
    [_mainWebView setDelegate:self];
    [self.view addSubview:_mainWebView];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate=self;
    singleTap.cancelsTouchesInView = NO;
    [_mainWebView addGestureRecognizer:singleTap];
    
    isNeedUPdata = YES;
    self.title = m_strTitle;

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(isNeedUPdata)
    {
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
        isNeedUPdata = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated;
{
    
    PhoneNetType netType = [NHUtils getPhoneNetMode];
    if(netType == PNT_UNKNOWN)
    {
        if(_loadTimerout)
        {
            [_loadTimerout invalidate];
            _loadTimerout = nil;
            [SVProgressHUD dismissWithError: @"请检查您的网络后重试" afterDelay:1.0];
        }
    }
}

-(void)handleTimerOut
{
    [SVProgressHUD dismiss];
}

- (void)setTitle:(NSString *)title withURL:(NSString *)urlStr
{
    m_strTitle = title;
    _urlRequest = urlStr;
}

#pragma  mark UIWebViewDelegate

- (void) webViewDidStartLoad:(UIWebView *)webView
{
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
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webview didFailLoadWithError %@ , and err is %@",webView.debugDescription, error.debugDescription);
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", request.URL.relativeString);
    
    return YES;
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    
    CGPoint pt = [sender locationInView:_mainWebView];
    
    NSLog(@"pint =%@",NSStringFromCGPoint(pt));
    //取得标签名
    NSString *script1 = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).parentNode.tagName", pt.x, pt.y];
    
    NSString *tagName = [_mainWebView stringByEvaluatingJavaScriptFromString:script1];
    //取得class 名
    NSString *script2 = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).parentNode.className", pt.x, pt.y];
    NSString *className = [_mainWebView stringByEvaluatingJavaScriptFromString:script2];
    
    NSLog(@"tagName = %@",tagName);
    NSLog(@"className = %@",className);
    if ([tagName isEqualToString:@"A"]&&[className isEqualToString:@"back"]) {
        if (![_mainWebView canGoBack]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

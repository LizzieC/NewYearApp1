//
//  LoginViewController.m
//  NewYearApp
//
//  Created by chenliqian on 14-12-17.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarController.h"
#import "HttpRequest.h"
#import "wldh_md5.h"
#import "AppDelegate.h"
#import "ContactViewController.h"
#import "UIImage+Scale.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    UITextField *phoneTextield;
}

-(void)dealloc
{
    R(phoneTextield);
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
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //获取当前网络环境
    PhoneNetType netType = [NHUtils getPhoneNetMode];
    if(netType == PNT_UNKNOWN)
    {
        [WSPromptHUD showInView:self.view info:@"请检查您的网络后重试" isCenter:YES];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *imgRUL = [[NSUserDefaults standardUserDefaults]objectForKey:kImgUrl];
    //圆形image
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50.f,109, 108.f, 108.f)];
    
    if (imgRUL.length > 0) {
        [imageView setImageWithURL:[NSURL URLWithString:imgRUL] placeholderImage: [UIImage imageNamed:@"login_icon.png"]];
        }else
    {
        imageView.image  = [UIImage imageNamed:@"login_icon.png"];
    }
    
    imageView.center = CGPointMake(kScreenWidth/2, 109);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 50;
    [self.view addSubview:imageView];
    
    phoneTextield  = [[UITextField alloc]initWithFrame:CGRectMake(27.5, 236.5, 265, 47)];
    phoneTextield.placeholder = @"  请输入你的手机号";
    phoneTextield.textAlignment = NSTextAlignmentCenter;
    phoneTextield.center = CGPointMake(kScreenWidth/2, 236.5);
    phoneTextield.font = [UIFont systemFontOfSize:17];
    phoneTextield.textColor = [UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1];
    phoneTextield.keyboardType = UIKeyboardTypeNumberPad;
    phoneTextield.returnKeyType = UIReturnKeyDone;
    phoneTextield.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTextield.delegate = self;
    
    //画边框
    phoneTextield.layer.cornerRadius = 7.0;
    phoneTextield.layer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0].CGColor;
    phoneTextield.layer.borderWidth = 1.0;
    phoneTextield.layer.masksToBounds = YES;
    [self.view addSubview:phoneTextield];
    
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldResponed:)];
    tapGr.delegate = self;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:tapGr];
    
    UISwipeGestureRecognizer *swipGrUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldResponed:)];
    [swipGrUp setDirection:UISwipeGestureRecognizerDirectionUp];
    swipGrUp.delegate = self;
    [self.view addGestureRecognizer:swipGrUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldResponed:)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    swipeDown.delegate = self;
    [self.view addGestureRecognizer:swipeDown];
    
    R(tapGr);  R(swipGrUp);  R(swipeDown);
    
    UIImage * loginDefaultImage = [[[UIImage imageNamed:@"login_btn_nol.png"] stretchableImageWithLeftCapWidth:36 topCapHeight:35] scaleToSize:CGSizeMake(560, 88)];
    UIImage * loginLightImage = [[[UIImage imageNamed:@"login_btn_sel.png"] stretchableImageWithLeftCapWidth:36 topCapHeight:35] scaleToSize:CGSizeMake(560, 88)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(27.5, 300.5, 265, 47);
    button.center = CGPointMake(self.view.frame.size.width/2, 300.5);
    [button setBackgroundImage:loginDefaultImage forState:UIControlStateNormal];
    [button setBackgroundImage:loginLightImage forState:UIControlStateHighlighted];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setTitle:@"登录" forState:UIControlStateHighlighted];
    [self.view addSubview:button];
    
}

//登录
- (void)loginClick
{
    NSString *str = nil;
    if (phoneTextield.text.length  == 0) {
        str = @"请输入您的电话号码";
    }
    if (phoneTextield.text.length  < 13) {
        str = @"请输入正确的手机号码";
    }
    
    if (str.length > 0) {
        UIAlertView *showAlerView = [[UIAlertView alloc]initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [showAlerView show];
        
        return;
    }
    
    NSString *phone = [phoneTextield.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    //时间戳
    NSDate *data = [NSDate date];
    NSTimeInterval interval = [data timeIntervalSince1970];
    int timeInterval = interval;
    NSString *strTime = [NSString stringWithFormat:@"%d", timeInterval];
    
    //sign
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@",phone,strTime,KPublicKey];
    NSString *sign =  [[wldh_md5 shareUtility] md5:signStr];
    
    NSString *url = [NSString stringWithFormat:@"%@&phone=%@&time=%@&sign=%@",kLoginURL,phone,strTime,sign];
    NSLog(@"loginRrl = %@",url);
    [HttpRequest requestWithUrlString:url target:self
                               action:@selector(requestFinished:)
                            isRefresh:YES];
    
    [SVProgressHUD showInView:[[UIApplication sharedApplication]keyWindow]
                       status:@"正在为您登录，请稍候..."
             networkIndicator:YES
                         posY:-1
                     maskType:SVProgressHUDMaskTypeClear];
}

#pragma mark HTTPRequestDelegate
- (void)requestFinished:(HttpRequest *)request
{
    //停止网络请求标志
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (request.downloadData) {
        id myResult = [NSJSONSerialization JSONObjectWithData:request.downloadData
                                                      options:NSJSONReadingMutableContainers
                                                        error:nil];
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)myResult;
            NSLog(@"dict = %@",dict);
            id result = [dict objectForKey:@"result"];
            NSString *strReason = [dict objectForKey:@"msg"];
            if (result)
            {
                NSInteger resultCode = [result integerValue];
                if (resultCode == 0)
                {
                    NSDictionary *infoDict =  [dict objectForKey:@"info"];
                    
                    //保存信息
                    [NHUtils setValue:[infoDict objectForKey:@"phone"] forKey:kPhone];
                    [NHUtils setValue:[infoDict objectForKey:@"company"] forKey:kCompany];
                    [NHUtils setValue:[infoDict objectForKey:@"name"] forKey:kName];
                    [NHUtils setValue:[infoDict objectForKey:@"levelone"] forKey:kLevelone];
                    [NHUtils setValue:[infoDict objectForKey:@"leveltwo"] forKey:kLeveltwo];
                    [NHUtils setValue:[infoDict objectForKey:@"id"] forKey:kRTXid];
                    [NHUtils setValue:[infoDict objectForKey:@"img"] forKey:kImgUrl];
                    [NHUtils setValue:[infoDict objectForKey:@"subimg"] forKey:kSubImag];
                    [NHUtils setValue:[infoDict objectForKey:@"kVip"] forKey:kVip];

                    [SVProgressHUD dismissWithSuccess:@"登录成功" afterDelay:3.0];
                    [self performSelector:@selector(loginSuccess) withObject:nil afterDelay:3.0];
                    
                }
                else
                {
                    [SVProgressHUD dismissWithError:strReason afterDelay:3.0];
                }
            }
        }
    }
    else
    {
        [SVProgressHUD dismissWithError:@"请检查您的网络后重试" afterDelay:3.0f];
    }
}
//登录成功
- (void)loginSuccess{
    
    [self.navigationController.view removeFromSuperview];
    [self.navigationController release];
    [[AppDelegate shareWldhClientDelegate].window makeKeyAndVisible];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"loginSucessNotficaiton" object:self];
}

- (void)textFieldResponed:(UITapGestureRecognizer*)tapGr
{
    [phoneTextield resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *currFullString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (string.length > 0) {    // 在增加字符
        if (currFullString.length > 13)
            return NO;
        if (range.location == 3 && textField.text.length == 3)
            textField.text = [textField.text stringByAppendingString:@"-"];
        if (range.location == 8 && textField.text.length == 8)
            textField.text = [textField.text stringByAppendingString:@"-"];
        if (range.location == 13 && textField.text.length == 13)
            textField.text = [textField.text stringByAppendingString:@"-"];
    }
    else
    {
        if ([currFullString hasSuffix:@"-"] || [currFullString hasSuffix:@" "]) {
            textField.text = [currFullString substringToIndex:currFullString.length];
        }
    }
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate
//ios6以下手势会挡住按钮点击事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

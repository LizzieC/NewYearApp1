//
//  PersonalCenterViewController.m
//  NewYearApp
//
//  Created by chenliqian on 14-12-21.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "HttpRequest.h"
#import "wldh_md5.h"
#import "UIImage+Scale.h"
#import "UIImageView+WebCache.h"

@interface PersonalCenterViewController ()
{
    BOOL isKeyBoardShow;
    CGRect oldFrame;
}
@end

@implementation PersonalCenterViewController
{
    UILabel *uilabel;
    UIButton *editBtn;
    NSString *examineText;
    int likeN;
}
@synthesize PersonalImg;
@synthesize PersonalLeve;
@synthesize PersonalName;
@synthesize PersonalPhone;
@synthesize PersonalSigh;
@synthesize mainScrollView;

- (void)dealloc
{
    [_zanBtn release];
    [_zanNumLabel release];
    [_zanImg release];
    R(PersonalImg);R(PersonalLeve);R(PersonalName);R(PersonalPhone);R(PersonalSigh);R(mainScrollView);

    [[NSNotificationCenter defaultCenter]removeObserver:nil name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:nil name:UIKeyboardWillHideNotification object:nil];

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
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [super viewDidLoad];
    
    self.title = @"个人主页";
    
    [self.mainScrollView setContentSize:CGSizeMake(320, 568)];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldResponed:)];
    tapGr.delegate = self;
    [self.view setUserInteractionEnabled:YES];
    [self.mainScrollView addGestureRecognizer:tapGr];
    
    UISwipeGestureRecognizer *swipGrUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldResponed:)];
    [swipGrUp setDirection:UISwipeGestureRecognizerDirectionUp];
    swipGrUp.delegate = self;
    [self.mainScrollView addGestureRecognizer:swipGrUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldResponed:)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    swipeDown.delegate = self;
    [self.mainScrollView addGestureRecognizer:swipeDown];
    
    R(tapGr);  R(swipGrUp);  R(swipeDown);
    
    [self createData];
    
    [self createUI];
    

    //    //监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //收键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)tap:(UITapGestureRecognizer *)gesture
{
    if (!self.PersonalSigh.isFirstResponder) {
        return;
    }
    [self.PersonalSigh resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.mainScrollView.frame = oldFrame;
        isKeyBoardShow = NO;
    }completion:^(BOOL finished) {
        
    }];
}
#pragma mark Notification
//keyBoard已经展示出来
- (void)keyboardDidShow:(NSNotification *)notification
{
    if (isKeyBoardShow) {
        return;
    }
    NSValue* aValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    oldFrame = self.mainScrollView.frame;
    CGRect frame = oldFrame;
    
    frame.origin.y -= keyboardHeight+20;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.mainScrollView.frame = frame;
        isKeyBoardShow = YES;
    }completion:^(BOOL finished) {
        
    }];
}
//keyBoard已经展示出来
- (void)keyboardHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 animations:^{
        self.mainScrollView.frame = oldFrame;
        isKeyBoardShow = NO;
    }completion:^(BOOL finished) {
        
    }];
}
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(17, 11, 25, 36);
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [PersonalImg addSubview:backBtn];
    
    PersonalImg.userInteractionEnabled = YES;
    PersonalImg.image = [UIImage imageNamed:@"contactBg.png"];
    
    //个性签名
    PersonalSigh.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    PersonalSigh.delegate = self;
    PersonalSigh.layer.cornerRadius = 5.0;
    PersonalSigh.layer.borderWidth = 0.0;
    PersonalSigh.layer.masksToBounds = YES;
    PersonalSigh.textColor = [UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1];

    uilabel = [[UILabel alloc]init];
    uilabel.frame =CGRectMake(5, 3,65, 20);
    uilabel.text = @"编辑签名";
    uilabel.textColor = [UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1];
    uilabel.enabled = NO;//lable必须设置为不可用
    uilabel.backgroundColor = [UIColor clearColor];
    uilabel.adjustsFontSizeToFitWidth = YES;
    [PersonalSigh addSubview:uilabel];
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame =CGRectMake(CGRectGetMaxX(uilabel.frame), 3, 20, 20);
    editBtn.enabled = NO;//lable必须设置为不可用
    [editBtn setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    [editBtn setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateHighlighted];
    editBtn.backgroundColor = [UIColor clearColor];
    [PersonalSigh addSubview:editBtn];
    
     PersonalPhone.textColor =  [UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1];
     PersonalLeve.textColor = [UIColor colorWithRed:95/255.0 green:95/255.0 blue:95/255.0 alpha:1];
     PersonalName.textColor =  [UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:1];
    
    [_zanBtn addTarget:self action:@selector(likeRequest) forControlEvents:UIControlEventTouchUpInside];
    [_zanBtn setImage:[UIImage imageNamed:@"zan_nol.png"] forState:UIControlStateNormal];
    [_zanBtn setImage:[UIImage imageNamed:@"zan_sel.png"] forState:UIControlStateSelected];
    
    if (_isSelect) {
        _zanBtn.selected = YES;
    }
    else
    {
        _zanBtn.selected = NO;
    }
    _zanBtn.hidden = YES;
    
    if(![_phoneNum isEqualToString:[NHUtils getValueForKey:kPhone]])
    {
        uilabel.hidden = YES;
        _zanBtn.hidden = NO;
        editBtn.hidden = YES;
    }
    _zanNumLabel.text = @"0";
}

- (void)saveSighData
{
    //获取当前网络环境
    PhoneNetType netType = [NHUtils getPhoneNetMode];
    if(netType == PNT_UNKNOWN)
    {
        [WSPromptHUD showInView:self.view info:@"请检查您的网络后重试" isCenter:YES];
        return;
    }
    //时间戳
    NSDate *data = [NSDate date];
    NSTimeInterval interval = [data timeIntervalSince1970];
    int timeInterval = interval;
    NSString *strTime = [NSString stringWithFormat:@"%d", timeInterval];
    
    //sign
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@",_phoneNum,strTime,KPublicKey];
    NSString *sign =  [[wldh_md5 shareUtility] md5:signStr];
    
    NSString *sighStr = [PersonalSigh.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *url = [NSString stringWithFormat:@"%@&phone=%@&time=%@&sign=%@&signature=%@",kAddSigh,_phoneNum,strTime,sign,sighStr];
    NSLog(@"saveSignRrl = %@",url);
    [HttpRequest requestWithUrlString:url target:self
                               action:@selector(requestSaveSignFinished:)
                            isRefresh:YES];
        [SVProgressHUD showInView:self.navigationController.view
                           status:@"正在为您保存数据,请稍候..."
                 networkIndicator:YES
                             posY:-1
                         maskType:SVProgressHUDMaskTypeClear];
}

- (void)createData
{
    //获取当前网络环境
    PhoneNetType netType = [NHUtils getPhoneNetMode];
    if(netType == PNT_UNKNOWN)
    {
        [WSPromptHUD showInView:self.view info:@"请检查您的网络后重试" isCenter:YES];
        return;
    }
    //时间戳
    NSDate *data = [NSDate date];
    NSTimeInterval interval = [data timeIntervalSince1970];
    int timeInterval = interval;
    NSString *strTime = [NSString stringWithFormat:@"%d", timeInterval];
    
    //sign
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@",_phoneNum,strTime,KPublicKey];
    NSString *sign =  [[wldh_md5 shareUtility] md5:signStr];
    
    NSString *url = [NSString stringWithFormat:@"%@&phone=%@&time=%@&sign=%@",KgetOneURL,_phoneNum,strTime,sign];
    NSLog(@"loginRrl = %@",url);
    [HttpRequest requestWithUrlString:url target:self
                               action:@selector(requestFinished:)
                            isRefresh:YES];
}

- (void)likeRequest
{
    _zanBtn.selected = !_zanBtn.selected;
    NSString *likeBtn = nil;
    if (_zanBtn.selected == YES) {
        likeBtn = @"like";
        ++likeN;
    }
    else
    {
        likeBtn = @"dislike";
        --likeN;
    }
    //时间戳
    NSDate *data = [NSDate date];
    NSTimeInterval interval = [data timeIntervalSince1970];
    int timeInterval = interval;
    NSString *strTime = [NSString stringWithFormat:@"%d", timeInterval];
    
    //sign
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@", [[NSUserDefaults standardUserDefaults]objectForKey:kPhone],strTime,KPublicKey];
    NSString *sign =  [[wldh_md5 shareUtility] md5:signStr];
    
    NSString *likeStrURL =  [NSString stringWithFormat:@"%@&act=%@&clickid=%@&actphone=%@&time=%@&sign=%@",kLikeClick,likeBtn,[NHUtils getValueForKey:kPhone],[[NSUserDefaults standardUserDefaults]objectForKey:kPhone],strTime,sign];
    [HttpRequest requestWithUrlString:likeStrURL target:self aciton:@selector(lickRequestFinished:)];
    
    [SVProgressHUD showInView:self.navigationController.view
                       status:@"请稍候..."
             networkIndicator:YES
                         posY:-1
                     maskType:SVProgressHUDMaskTypeClear];
}
#pragma mark  -------HttpRequestDelegate
//获取单人信息
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
            id result = [dict objectForKey:@"result"];
            NSString *strReason = [dict objectForKey:@"msg"];
            if (result)
            {
                NSDictionary *infoDict =  [dict objectForKey:@"info"];
                 [PersonalImg setImageWithURL:[NSURL URLWithString:[infoDict objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"login_icon.png"] options:SDWebImageLowPriority];
                PersonalName.text = [infoDict objectForKey:@"name"];
                PersonalLeve.text = [NSString stringWithFormat:@"%@/%@",[infoDict objectForKey:@"company"],[infoDict objectForKey:@"levelone"]];
                PersonalPhone.text = [infoDict objectForKey:@"phone"];
                PersonalSigh.text = [infoDict objectForKey:@"sigh"];
                likeN =[[infoDict objectForKey:@"like"] intValue];
                _zanNumLabel.text = [NSString stringWithFormat:@"%d",likeN];//[infoDict objectForKey:@"like"];
                if ( [[infoDict objectForKey:@"sigh"] length]>0) {
                    uilabel.text = @"";
                    editBtn.hidden = YES;
                }
               
            }
            else
            {
                [SVProgressHUD dismissWithError:strReason afterDelay:3.0f];
            }
        }
    }
    else
    {
        [SVProgressHUD dismissWithError:@"请检查您的网络后重试" afterDelay:3.0f];
    }
}
//点赞
- (void)lickRequestFinished:(HttpRequest *)request
{
    //停止网络请求标志
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (request.downloadData) {
        id myResult = [NSJSONSerialization JSONObjectWithData:request.downloadData
                                                      options:NSJSONReadingMutableContainers
                                                        error:nil];
        if ([myResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = (NSDictionary *)myResult;
            id result = [dict objectForKey:@"result"];
            NSString *strReason = [dict objectForKey:@"msg"];
            if (result)
            {
                NSInteger resultCode = [result integerValue];
                if (resultCode == 0)
                {
                    _zanNumLabel.text = [NSString stringWithFormat:@"%d",likeN];
                    [SVProgressHUD dismissWithSuccess:strReason afterDelay:3.0f];
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"likeSucessNotficaiton" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.phoneNum,@"id",
                                                                                        [NSNumber numberWithBool: _zanBtn.selected],@"like",nil]];
                }
                else
                {
                    [SVProgressHUD dismissWithError:strReason afterDelay:3.0f];
                }
            }
        }
    }
    else
    {
        [SVProgressHUD dismissWithError:@"请检查您的网络后重试" afterDelay:3.0f];
    }
}
//保存签名
- (void)requestSaveSignFinished:(HttpRequest *)request
{
    //停止网络请求标志
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (request.downloadData) {
        id myResult = [NSJSONSerialization JSONObjectWithData:request.downloadData
                                                      options:NSJSONReadingMutableContainers
                                                        error:nil];
        if ([myResult isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)myResult;
            id result = [dict objectForKey:@"result"];
            NSString *strReason = [dict objectForKey:@"msg"];
            if (result)
            {
                [SVProgressHUD dismissWithSuccess:strReason afterDelay:3.0f];
            }
            else
            {
                [SVProgressHUD dismissWithError:strReason afterDelay:3.0f];
            }
        }
    }
    else
    {
        [SVProgressHUD dismissWithError:@"请检查您的网络后重试" afterDelay:3.0f];
    }
}

- (void)textFieldResponed:(UITapGestureRecognizer*)tapGr
{
    [PersonalSigh resignFirstResponder];
}

#pragma mark -----UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    examineText =  textView.text;
    if (textView.text.length == 0) {
        uilabel.text = @"编辑签名";
        editBtn.hidden = NO;
    }else{
        uilabel.text = @"";
        editBtn.hidden = YES;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if(![_phoneNum isEqualToString:[NHUtils getValueForKey:kPhone]])
    {
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"] && text.length > 0) {
        //上传签名
        [self saveSighData];
        
        [textView resignFirstResponder];
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

//
//  PersonalCenterViewController2.m
//  NewYearApp
//
//  Created by chenzhihao on 15-1-4.
//  Copyright (c) 2015年 chenliqian. All rights reserved.
//

#import "PersonalCenterViewController2.h"
#import "HttpRequest.h"
#import "wldh_md5.h"
#import "UIImage+Scale.h"

@interface PersonalCenterViewController2 ()<UITextViewDelegate>
{
    UILabel *uilabel;
    CGRect oldFrame;
    BOOL isKeyBoardShow;
}

@property (nonatomic,strong) UIImageView *personalImage;
@property (nonatomic,strong) UILabel *personalName;
@property (nonatomic,strong) UILabel *personalDepartment;
@property (nonatomic,strong) UILabel *personalPhoneNum;
@property (nonatomic,strong) UIButton *saveSign;
@property (nonatomic,strong) UITextView *personalSignment;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong)UIImage *likeBtn;

@property (nonatomic,strong) UIScrollView *landScapeView;

@end

@implementation PersonalCenterViewController2

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if (!self.personalSignment.isFirstResponder) {
        return;
    }
    [self.personalSignment resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = oldFrame;
        isKeyBoardShow = NO;
    }completion:^(BOOL finished) {
        
    }];
}

- (void)createUI
{
    isKeyBoardShow = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    
    self.personalImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 270)];
    [self.scrollView addSubview:self.personalImage];
    
    self.personalName = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.personalImage.frame)+5, 280, 44)];
    self.personalName.font = [UIFont boldSystemFontOfSize:30.0f];
    self.personalName.textColor = [UIColor blackColor];
    [self.scrollView addSubview:self.personalName];
    
    self.personalDepartment = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.personalName.frame)+5, 280, 20)];
    self.personalDepartment.font = [UIFont systemFontOfSize:16.0f];
    self.personalDepartment.textColor = [UIColor blackColor];
    [self.scrollView addSubview:self.personalDepartment];
    
    self.personalPhoneNum = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.personalDepartment.frame)+10, 320*0.5, 20)];
    self.personalPhoneNum.font = [UIFont systemFontOfSize:16.0f];
    self.personalPhoneNum.textColor = [UIColor darkGrayColor];
    [self.scrollView addSubview:self.personalPhoneNum];
    
    UIImage * loginDefaultImage = [[[UIImage imageNamed:@"login_btn_nol.png"] stretchableImageWithLeftCapWidth:36 topCapHeight:35] scaleToSize:CGSizeMake(560, 88)];
    UIImage * loginLightImage = [[[UIImage imageNamed:@"login_btn_sel.png"] stretchableImageWithLeftCapWidth:36 topCapHeight:35] scaleToSize:CGSizeMake(560, 88)];
    self.saveSign = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveSign.frame = CGRectMake(200, CGRectGetMaxY(self.personalDepartment.frame), 100, 30);
    [self.saveSign setBackgroundImage:loginDefaultImage forState:UIControlStateNormal];
    [self.saveSign setBackgroundImage:loginLightImage forState:UIControlStateHighlighted];
    [self.saveSign addTarget:self action:@selector(saveSighData) forControlEvents:UIControlEventTouchUpInside];
    [self.saveSign setTitle:@"保存签名" forState:UIControlStateNormal];
    [self.saveSign setTitle:@"保存签名" forState:UIControlStateHighlighted];
    self.saveSign.userInteractionEnabled = NO;
    NSLog(@"%@ %@",_phoneNum,[NHUtils getValueForKey:kPhone]);
    if(![_phoneNum isEqualToString:[NHUtils getValueForKey:kPhone]])
    {
        self.saveSign.hidden = YES;
    }
    [self.scrollView addSubview:self.saveSign];
    
    self.personalSignment = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.saveSign.frame)+10, 280, 100)];
    self.personalSignment.backgroundColor = [UIColor lightGrayColor];
    self.personalSignment.layer.borderWidth = 1.0f;
    self.personalSignment.layer.borderColor = [[UIColor blackColor] CGColor];
    self.personalSignment.layer.cornerRadius = 5.0f;
    self.personalSignment.layer.masksToBounds = YES;
    self.personalSignment.delegate = self;
    [self.scrollView addSubview:self.personalSignment];
    
    uilabel = [[UILabel alloc]init];
    uilabel.frame =CGRectMake(0, 0, self.personalSignment.frame.size.width, 20);
    uilabel.text = @"编辑签名...";
    uilabel.textColor = [UIColor blackColor];
    uilabel.enabled = NO;//lable必须设置为不可用
    uilabel.backgroundColor = [UIColor clearColor];
    [self.personalSignment addSubview:uilabel];
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.personalSignment.frame)+10);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    //    //监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
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
    oldFrame = self.view.frame;
    CGRect frame = oldFrame;
    NSInteger orientation = [UIDevice currentDevice].orientation;
    if (orientation==1 || orientation==5 || orientation==6) {
        frame.origin.y -= keyboardHeight;
    }
    else{
        frame.origin.y -= 100;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = frame;
        isKeyBoardShow = YES;
    }completion:^(BOOL finished) {
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createData];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSInteger orientation = [UIDevice currentDevice].orientation;
    if (orientation==1 || orientation==5 || orientation==6) {
        [self createPortaitView];
    }
    else{
        [self createLandScapeView];
    }
}

- (void)saveSighData
{
    //时间戳
    NSDate *data = [NSDate date];
    NSTimeInterval interval = [data timeIntervalSince1970];
    int timeInterval = interval;
    NSString *strTime = [NSString stringWithFormat:@"%d", timeInterval];
    
    //sign
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@",_phoneNum,strTime,KPublicKey];
    NSString *sign =  [[wldh_md5 shareUtility] md5:signStr];
    
    NSString *sighStr = [self.personalSignment.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
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

#pragma mark  -------HttpRequestDelegate
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
                
                [self.personalImage setImageWithURL:[NSURL URLWithString:[infoDict objectForKey:@"subimg"]] placeholderImage:[UIImage imageNamed:@"login_icon.png"]];
                self.personalName.text = [infoDict objectForKey:@"name"];
                self.personalDepartment.text = [NSString stringWithFormat:@"%@/%@",[infoDict objectForKey:@"levelone"],[infoDict objectForKey:@"leveltwo"]];
                self.personalPhoneNum.text = [infoDict objectForKey:@"phone"];
                self.personalSignment.text = [infoDict objectForKey:@"sigh"];
                if ( [[infoDict objectForKey:@"sigh"] length]>0) {
                    uilabel.text = @"";
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
        [SVProgressHUD dismissWithError:@"请检查您的网络!" afterDelay:3.0f];
    }
}
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
        [SVProgressHUD dismissWithError:@"请检查您的网络!" afterDelay:3.0f];
    }
}
- (void)textFieldResponed:(UITapGestureRecognizer*)tapGr
{
    [self.personalSignment resignFirstResponder];
}

#pragma mark -----UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        uilabel.text = @"编辑签名...";
        self.saveSign.userInteractionEnabled = NO;
    }else{
        uilabel.text = @"";
        self.saveSign.userInteractionEnabled = YES;
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
    self.personalSignment.text = @"";
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
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

- (void)createPortaitView
{
    R(self.landScapeView);
    R(self.scrollView);
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    self.personalImage.frame = CGRectMake(0, 0, 320, 270);
    [self.landScapeView addSubview:self.personalImage];
    
    self.personalName.frame = CGRectMake(10, CGRectGetMaxY(self.personalImage.frame), width-20, 44);
    self.personalName.backgroundColor = [self getRandomColor];
    [self.scrollView addSubview:self.personalName];
    
    self.personalDepartment.frame = CGRectMake(10, CGRectGetMaxY(self.personalName.frame), width-20, 21);
    self.personalDepartment.backgroundColor = [self getRandomColor];
    [self.scrollView addSubview:self.personalDepartment];
    
    CGSize size = [self.personalPhoneNum.text sizeWithAttributes:@{NSFontAttributeName:self.personalPhoneNum.font}];
    self.personalPhoneNum.frame = CGRectMake(10, CGRectGetMaxY(self.personalDepartment.frame)+5, size.width, 21);
    self.personalPhoneNum.backgroundColor = [self getRandomColor];
    [self.scrollView addSubview:self.personalPhoneNum];
    
    self.saveSign.frame = CGRectMake(width-120, CGRectGetMaxY(self.personalDepartment.frame), 100, 30);
    [self.scrollView addSubview:self.saveSign];
    
    self.personalSignment.frame = CGRectMake(10, CGRectGetMaxY(self.personalPhoneNum.frame)+10, width-20, height-CGRectGetMaxY(self.personalPhoneNum.frame)-20);
    [self.scrollView addSubview:self.personalSignment];
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.personalSignment.frame));
    [self.view addSubview:self.scrollView];
}

- (UIColor *)getRandomColor
{

    return [UIColor clearColor];
}

- (void)createLandScapeView
{
    R(self.landScapeView);
    R(self.scrollView);
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    self.landScapeView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    self.personalImage.frame = CGRectMake(0, 0, 320, height);
    [self.landScapeView addSubview:self.personalImage];
    
    
    
    self.personalName.frame = CGRectMake(CGRectGetMaxX(self.personalImage.frame)+10, 0, width-CGRectGetWidth(self.personalImage.frame)-20, 44);
    self.personalName.backgroundColor = [self getRandomColor];
    [self.landScapeView addSubview:self.personalName];
    
    self.personalDepartment.frame = CGRectMake(CGRectGetMaxX(self.personalImage.frame)+10, CGRectGetMaxY(self.personalName.frame), width-CGRectGetWidth(self.personalImage.frame)-20, 21);
    self.personalDepartment.backgroundColor = [self getRandomColor];
    [self.landScapeView addSubview:self.personalDepartment];
    
    CGSize size = [self.personalPhoneNum.text sizeWithAttributes:@{NSFontAttributeName:self.personalPhoneNum.font}];
    self.personalPhoneNum.frame = CGRectMake(CGRectGetMaxX(self.personalImage.frame)+10, CGRectGetMaxY(self.personalDepartment.frame)+5, size.width, 21);
    self.personalPhoneNum.backgroundColor = [self getRandomColor];
    [self.landScapeView addSubview:self.personalPhoneNum];
    
    self.saveSign.frame = CGRectMake(width-110, CGRectGetMaxY(self.personalSignment.frame), 100, 30);
    [self.landScapeView addSubview:self.saveSign];
    
    self.personalSignment.frame = CGRectMake(CGRectGetMaxX(self.personalImage.frame)+10, CGRectGetMaxY(self.personalPhoneNum.frame)+10, width-CGRectGetWidth(self.personalImage.frame)-20, 100);
    [self.landScapeView addSubview:self.personalSignment];
    
    self.landScapeView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.personalSignment.frame));
    [self.view addSubview:self.landScapeView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation==UIDeviceOrientationPortrait || orientation==UIDeviceOrientationFaceUp ||  orientation==UIDeviceOrientationFaceDown) {
        [self createPortaitView];
    }
    else
    {
        [self createLandScapeView];
    }
}

@end

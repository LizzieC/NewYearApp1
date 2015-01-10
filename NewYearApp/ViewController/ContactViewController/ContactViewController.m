//
//  ContactViewController.m
//  NewYearApp
//
//  Created by chenliqian on 14-12-17.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import "ContactViewController.h"
#import "PersonalCenterViewController.h"
#import "EmployeeCollectionViewCell.h"
#import "HttpRequest.h"
#import "wldh_md5.h"
#import "ContactModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "PersonalCenterViewController.h"
#import "UIImageView+WebCache.h"

static NSString *cellIdentifier = @"TestCell";

@interface ContactViewController ()
{
    //上拉加载更多页数
    int index;
    int clickLikeNum;//记录赞人数
    UIView *bgView;
}
@end

@implementation ContactViewController
@synthesize dataArray;
@synthesize InfoDataArray;
@synthesize currentSelectedIndex = _currentSelectedIndex;
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"likeSucessNotficaiton" object:nil];

    R(dataArray);R(InfoDataArray);R(_tabCollectionView);R(_employSearchBar);R(_cachedPics);R(_ShowDataArray);
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
    self.tabBarController.navigationItem.titleView = [customNavigation createTitleView:@"疯人院"];//self.employSearchBar
    self.navigationController.navigationBar.hidden = NO;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarClick)];
    self.tabBarController.navigationItem.rightBarButtonItem = leftBtn;
    
    [super viewWillAppear:animated];
}
- (void)searchBarClick
{
    if (bgView != nil) {
        [bgView removeFromSuperview];
        R(bgView);
    }
    if (self.employSearchBar != nil) {
        [self.employSearchBar removeFromSuperview];
        R(self.employSearchBar);
    }
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, kScreenHeight- 49 - 64-44)];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [self.view addSubview:bgView];
    [self.view bringSubviewToFront:bgView];
    //搜索框
    self.employSearchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    self.employSearchBar.placeholder=@"请输入姓名或手机号码搜索";
    self.employSearchBar.delegate=self;
    self.employSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;//不自动大写
    self.employSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;//不自动纠错
    [self.view addSubview:self.employSearchBar];
     self.employSearchBar.showsCancelButton=NO;//是否显示取消按钮
    self.employSearchBar.hidden = NO;
    [self.employSearchBar becomeFirstResponder];
    for (UIView *searchbuttons in self.employSearchBar.subviews)
    {
        if ([searchbuttons isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)searchbuttons;
            cancelButton.enabled = YES;
            [cancelButton setTitle:@"取消"  forState:UIControlStateNormal];//文字
            break;
        }
    }
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstSearchBar)];
    tapGr.delegate = self;
    [self.view setUserInteractionEnabled:YES];
    [bgView addGestureRecognizer:tapGr];
    
    UISwipeGestureRecognizer *swipGrUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstSearchBar)];
    [swipGrUp setDirection:UISwipeGestureRecognizerDirectionUp];
    swipGrUp.delegate = self;
    [bgView addGestureRecognizer:swipGrUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstSearchBar)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    swipeDown.delegate = self;
    [bgView addGestureRecognizer:swipeDown];
    
    R(tapGr);  R(swipGrUp);  R(swipeDown);

    
    self.tabCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.employSearchBar.frame), self.view.frame.size.width,kScreenHeight- 49 - 64-self.employSearchBar.frame.size.height);
}

- (void)updetaPersonInfo:(NSNotification*)notifice
{
    
    NSString *personId=[notifice.userInfo objectForKey:@"id"];
    NSNumber *num=[notifice.userInfo objectForKey:@"like"];
    BOOL islike=[num  boolValue];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.phone = %@",personId];
    NSArray *predArray = [self.dataArray filteredArrayUsingPredicate:pred];
    if (predArray&&[predArray count]>0) {
        ContactModel *model = [predArray objectAtIndex:0];
        int rowNum = [self.dataArray indexOfObject:model];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:rowNum inSection:0];
        if (indexPath!=nil)
        {
            id *cell =[self.tabCollectionView cellForItemAtIndexPath:indexPath];
            if ([cell isKindOfClass:[EmployeeCollectionViewCell class]]) {
                if (islike) {
                    ++model.SaveLikeNum;
                      ((EmployeeCollectionViewCell *)cell).likeImg.highlighted = YES;
                    ((EmployeeCollectionViewCell *)cell).likeNum.text = [NSString stringWithFormat:@"%d",model.SaveLikeNum];

                }
                else
                {
                    --model.SaveLikeNum;
                    ((EmployeeCollectionViewCell *)cell).likeImg.highlighted = NO;
                    ((EmployeeCollectionViewCell *)cell).likeNum.text = [NSString stringWithFormat:@"%d",model.SaveLikeNum];

                }
              
            }
        }
    }
    
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updetaPersonInfo:)
                                                 name:@"likeSucessNotficaiton" object:nil];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    _isSearching = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    
    //请求数据
    [self creatData];
}
- (void)createUI
{
    
    //瀑布流
    PSUICollectionViewFlowLayout *collectionViewFlowLayout = [[PSUICollectionViewFlowLayout alloc] init];
    [collectionViewFlowLayout setScrollDirection:PSTCollectionViewScrollDirectionVertical];
    [collectionViewFlowLayout setItemSize:CGSizeMake(100, 128)];
    [collectionViewFlowLayout setMinimumInteritemSpacing:3];
    [collectionViewFlowLayout setMinimumLineSpacing:2];
    
    self.tabCollectionView=[[PSUICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kScreenHeight- 49 - 64) collectionViewLayout:collectionViewFlowLayout];
    self.tabCollectionView.dataSource=self;
    self.tabCollectionView.delegate=self;
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapRecognizer.delegate=self;
    [self.tabCollectionView addGestureRecognizer:tapRecognizer];
    
    self.tabCollectionView.backgroundColor=[UIColor whiteColor];
    [self.tabCollectionView registerClass:[EmployeeCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tabCollectionView];
    
    //下拉刷新
    [self.tabCollectionView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //上拉加载更多
    [self.tabCollectionView addFooterWithTarget:self action:@selector(loadMoreRereshing)];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tabCollectionView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tabCollectionView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tabCollectionView.headerRefreshingText = @"正在帮你刷新中,不客气";
    
    self.tabCollectionView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tabCollectionView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tabCollectionView.footerRefreshingText = @"正在帮你加载中,不客气";
}
- (void)creatData
{
    index = 0;
    
    dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    InfoDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    _cachedPics = [[NSMutableDictionary alloc]initWithCapacity:0];
    _ShowDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
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
    NSString *signStr = [NSString stringWithFormat:@"%@%@",strTime,KPublicKey];
    NSString *sign =  [[wldh_md5 shareUtility] md5:signStr];
    
    NSString *allImgUrl = [NSString stringWithFormat:@"%@&phone=%@&time=%@&sign=%@",kGetAllImgURL,[NHUtils getValueForKey:kPhone],strTime,sign];
    [HttpRequest requestWithUrlString:allImgUrl target:self action:@selector(requestFinished:) isRefresh:NO];
    
    [SVProgressHUD showInView:self.navigationController.view
                       status:@"请稍候..."
             networkIndicator:YES
                         posY:-1
                     maskType:SVProgressHUDMaskTypeClear];
}

#pragma mark HTTPRequestDelegate
- (void)requestFinished:(HttpRequest *)request
{
    if (self.dataArray) {
        [self.dataArray removeAllObjects];
    }

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
                    _infoDict =  [dict objectForKey:@"info"];
                    NSArray *infoArray = [_infoDict allValues];
                    NSLog(@"allContact = %@",infoArray);
                    for (NSDictionary *atem in infoArray)
                    {
                        ContactModel *model = [[ContactModel alloc]init];
                        model.isVip = [atem objectForKey:@"bk"];
                        model.idcard = [atem objectForKey:@"idcard"];
                        model.imgURL = [atem objectForKey:@"img"];
                        model.name = [atem objectForKey:@"name"];
                        model.phone = [atem objectForKey:@"phone"];
                        model.subimgURL = [atem objectForKey:@"subimg"];
                        model.uid = [atem objectForKey:@"id"];
                        model.likeNum = [atem objectForKey:@"like"];
                        model.SaveLikeNum =  [[atem objectForKey:@"like"]intValue];
                        model.isLike = [atem objectForKey:@"islike"];
                        model.company = [atem objectForKey:@"company"];
                        model.levelone = [atem objectForKey:@"levelone"];

                        [dataArray addObject:model];
                        R(model);
                    }
                    
                    NSRange range = NSMakeRange(index*30, 30);
                   NSArray *subArray = [self.dataArray subarrayWithRange:range];
                    [InfoDataArray addObjectsFromArray:subArray];
                    
                    [SVProgressHUD dismissWithSuccess:strReason afterDelay:3.0f];
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
    [self.tabCollectionView reloadData];
}

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
            NSLog(@"dict = %@",dict);
            id result = [dict objectForKey:@"result"];
            NSString *strReason = [dict objectForKey:@"msg"];
            if (result)
            {
                NSInteger resultCode = [result integerValue];
                if (resultCode == 0)
                {
                    [SVProgressHUD dismissWithSuccess:strReason afterDelay:3.0f];
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

#pragma mart - 搜索事件
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton=YES;
    _isSearching = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0) {
        for (id cc in searchBar.subviews)
        {
            if([cc isKindOfClass:[UIButton class]])
            {
                UIButton *btn=(UIButton *)cc;
                [btn setTitleColor:[UIColor colorWithRed:95/255.0 green:95/255 blue:95/255 alpha:1] forState:UIControlStateNormal];
                [btn setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    }else{
        NSArray *array = searchBar.subviews;
        for (UIView *subView in array)
        {
            NSArray *array2 = subView.subviews;
            for (UIView *ndLeveSubView in array2)
            {
                if ([ndLeveSubView isKindOfClass:[UIButton class]])
                {
                    UIButton *cancelButton = (UIButton*)ndLeveSubView;
                     [cancelButton setTitleColor:[UIColor colorWithRed:95/255.0 green:95/255 blue:95/255 alpha:1] forState:UIControlStateNormal];
                    [cancelButton setTitle:@"取消"  forState:UIControlStateNormal];
                    break;
                }
            }
        }
    }
    return YES;
}

//搜索button点击事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm]; //搜索内容 删除words里面的空分区和不匹配内容
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //搜索内容随着输入及时地显示出来
    if([searchText length] == 0)
    {
        [self.view bringSubviewToFront:bgView];
        _isSearching  = NO;
        [self.employSearchBar resignFirstResponder];
        [_ShowDataArray removeAllObjects];
        [self.tabCollectionView reloadData];
        return;
    }
    else
    {
        [self handleSearchForTerm:searchText];
        [self.view sendSubviewToBack:bgView];
    }
}
//重设tableview坐标
- (void)resignFirstSearchBar
{
    if( self.employSearchBar.text.length > 0)
    {
        [self.employSearchBar resignFirstResponder];
        return;
    }
        _isSearching  = NO;
    [self.employSearchBar resignFirstResponder];
    self.employSearchBar.hidden = YES;
    [self.tabCollectionView reloadData];
    self.tabCollectionView.frame = CGRectMake(0, 0, self.view.frame.size.width,kScreenHeight- 49 - 64);
    [self.view sendSubviewToBack:bgView];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar //点击取消按钮
{
    self.employSearchBar.text = @"";  //标题 为空
    [self.employSearchBar removeFromSuperview];
    [self resignFirstSearchBar];//重设坐标
}

//实现搜索方法
- (void)handleSearchForTerm:(NSString *)searchTerm
{
    //近似匹配字符串，类似SQL中的语法
    NSString *match = [NSString stringWithFormat:@"*%@*",searchTerm];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.phone LIKE[cd] %@",match];
    NSArray *predArray = [self.dataArray filteredArrayUsingPredicate:pred];
    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF.name LIKE[cd] %@",match];
    NSArray *predArray1 = [self.dataArray filteredArrayUsingPredicate:pred1];
    
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF.company LIKE[cd] %@",match];
    NSArray *predArray2 = [self.dataArray filteredArrayUsingPredicate:pred2];
    
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF.levelone LIKE[cd] %@",match];
    NSArray *predArray3 = [self.dataArray filteredArrayUsingPredicate:pred3];
    
    [_ShowDataArray removeAllObjects];
    [_ShowDataArray addObjectsFromArray:predArray];
    [_ShowDataArray addObjectsFromArray:predArray1];
    [_ShowDataArray addObjectsFromArray:predArray2];
    [_ShowDataArray addObjectsFromArray:predArray3];

    if (_ShowDataArray.count == 0) {
        [WSPromptHUD showInView:self.view info:@"没有搜索到想要的内容哦~" isCenter:YES];
    }
    
    [self.tabCollectionView reloadData];
}

#pragma mark -
#pragma mark PSUICollectionView stuff
- (NSInteger)numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_isSearching == YES) {
        return [_ShowDataArray count]>0?[_ShowDataArray count]:0;
    }
    return InfoDataArray.count;
}


- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearching ==YES && self.employSearchBar.text.length > 0) {
        EmployeeCollectionViewCell *cell = (EmployeeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        /**设置员工信息**/
        ContactModel *model = [_ShowDataArray objectAtIndex:indexPath.row];
        
         [cell.employeeImageView setImageWithURL:[NSURL URLWithString:model.imgURL] placeholderImage:[UIImage imageNamed:@"contactBg.png"] options:SDWebImageProgressiveDownload|SDWebImageCacheMemoryOnly|SDWebImageLowPriority];
        cell.labTitle.text= model.name;
        cell.likeNum.text = [NSString stringWithFormat:@"%d", model.SaveLikeNum];//点赞人数
        cell.bkImgView.hidden = ![model.isVip boolValue];
        cell.likeImg.highlighted = [model.isLike boolValue];
        [cell.btnVote addTarget:self action:@selector(clickZan:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnVote.tag = indexPath.row + 10000;
        return cell;
    }
    EmployeeCollectionViewCell *cell = (EmployeeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    /**设置员工信息**/
    ContactModel *model = [InfoDataArray objectAtIndex:indexPath.row];
    
    [cell.employeeImageView setImageWithURL:[NSURL URLWithString:model.imgURL] placeholderImage:[UIImage imageNamed:@"contactBg.png"] options:SDWebImageProgressiveDownload|SDWebImageCacheMemoryOnly|SDWebImageLowPriority];
    cell.labTitle.text= model.name;
    cell.likeNum.text = [NSString stringWithFormat:@"%d", model.SaveLikeNum];//点赞人数
   cell.likeImg.highlighted = [model.isLike boolValue];
    cell.bkImgView.hidden = ![model.isVip boolValue];
    [cell.btnVote addTarget:self action:@selector(clickZan:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnVote.tag = indexPath.row + 10000;
    return cell;
}

- (PSUICollectionReusableView *)collectionView:(PSUICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    PSUICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    
    // TODO Setup view
    
    return supplementaryView;
}

#pragma mark -选中行事件
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint initialPinchPoint = [sender locationInView:self.tabCollectionView];
        NSIndexPath* tappedCellPath = [self.tabCollectionView indexPathForItemAtPoint:initialPinchPoint];
        
        if (tappedCellPath!=nil)
        {
            id cell=[self.tabCollectionView cellForItemAtIndexPath:tappedCellPath];
            if ([cell isKindOfClass:[EmployeeCollectionViewCell class]]) {
                
                if(_isSearching == YES && self.employSearchBar.text.length > 0)
                {
                    //跳转到详情页面
                    ContactModel *model = [_ShowDataArray objectAtIndex:tappedCellPath.row];
                    
                    PersonalCenterViewController *personalCenter = [[PersonalCenterViewController alloc]initWithNibName:@"PersonalCenterViewController" bundle:[NSBundle mainBundle]];
                    personalCenter.phoneNum = model.phone;
                    personalCenter.isSelect = [model.isLike boolValue];
                    [self.navigationController pushViewController:personalCenter animated:YES];
                    R(personalCenter);
                }else{
                    //跳转到详情页面
                    ContactModel *model = [dataArray objectAtIndex:tappedCellPath.row];
                    
                    PersonalCenterViewController *personalCenter = [[PersonalCenterViewController alloc]initWithNibName:@"PersonalCenterViewController" bundle:[NSBundle mainBundle]];
                    personalCenter.phoneNum = model.phone;
                    personalCenter.isSelect = [model.isLike boolValue];

                    [self.navigationController pushViewController:personalCenter animated:YES];
                    R(personalCenter);
                }
            }
        }
        //跳出去之后取消搜索栏(可选)
        [self resignFirstSearchBar];
    }
}

//点赞事件
- (void)clickZan:(UIButton *)btn
{
    ContactModel *model = [dataArray objectAtIndex:btn.tag - 10000];

    btn.selected= !btn.selected;
    
    NSString *likeBtn = nil;
    if (btn.selected == YES) {
        likeBtn = @"like";
        ++model.SaveLikeNum;
    }
    else
    {
        likeBtn = @"dislike";
        --model.SaveLikeNum;
    }
    int rowNum = btn.tag - 10000;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:rowNum inSection:0];
    if (indexPath!=nil)
    {
        id *cell =[self.tabCollectionView cellForItemAtIndexPath:indexPath];
        if ([cell isKindOfClass:[EmployeeCollectionViewCell class]]) {
            if (btn.selected == YES) {
                ((EmployeeCollectionViewCell *)cell).likeImg.highlighted = YES;
                ((EmployeeCollectionViewCell *)cell).likeNum.text = [NSString stringWithFormat:@"%d",model.SaveLikeNum];
            }else{
                ((EmployeeCollectionViewCell *)cell).likeImg.highlighted = NO;
                ((EmployeeCollectionViewCell *)cell).likeNum.text = [NSString stringWithFormat:@"%d",model.SaveLikeNum];
            }
        }
    }
    //时间戳
    NSDate *data = [NSDate date];
    NSTimeInterval interval = [data timeIntervalSince1970];
    int timeInterval = interval;
    NSString *strTime = [NSString stringWithFormat:@"%d", timeInterval];
    
    //sign
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@", [[NSUserDefaults standardUserDefaults]objectForKey:kPhone],strTime,KPublicKey];
    NSString *sign =  [[wldh_md5 shareUtility] md5:signStr];
    
    NSString *likeStrURL =  [NSString stringWithFormat:@"%@&act=%@&clickid=%@&actphone=%@&time=%@&sign=%@",kLikeClick,likeBtn,model.phone,[[NSUserDefaults standardUserDefaults]objectForKey:kPhone],strTime,sign];
    [HttpRequest requestWithUrlString:likeStrURL target:self aciton:@selector(lickRequestFinished:)];
    
    [SVProgressHUD showInView:self.navigationController.view
                       status:@"请稍候..."
             networkIndicator:YES
                         posY:-1
                     maskType:SVProgressHUDMaskTypeClear];
}

//下拉刷新
- (void)headerRereshing
{
    // 1.删除原数据
    index = 0;
    [InfoDataArray removeAllObjects];
    
    NSRange range = NSMakeRange(index*30, 30);
    NSArray *subArray = [self.dataArray subarrayWithRange:range];
    [InfoDataArray addObjectsFromArray:subArray];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tabCollectionView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tabCollectionView headerEndRefreshing];
    });
}
//上拉加载更多
- (void)loadMoreRereshing
{
    ++index;
    
    // 1.插入数据
    NSRange range = NSMakeRange(index*30, 30);
    NSArray *subArray = [self.dataArray subarrayWithRange:range];
    [InfoDataArray addObjectsFromArray:subArray];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tabCollectionView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tabCollectionView footerEndRefreshing];
    });
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

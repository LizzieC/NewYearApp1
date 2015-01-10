//
//  CommonType.h
//  NewYearApp
//
//  Created by chenliqian on 14-12-17.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//
//常用方法
// 电话当前网络类型
typedef enum
{
    PNT_UNKNOWN = 0,    // 未知,无网络
    PNT_WIFI    = 1,    // WIFI
    PNT_2G3G           // 2G/3G
}PhoneNetType;

#define R(obj)          {if(obj) {[obj release]; obj = nil;}}

//获取屏幕宽、高度
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height

#define kWldhClientIsIOS7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define kWldhClientIsIphone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)



#define kColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kWldhWeiShuoS5 kColorFromRGB(0x06bf04)
#define kMoreNavigationButtonFrameOX  0

#define kNavigationBarBgColor [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]

#define kNavigationBarTintColor         [UIColor colorWithRed:89.0/255.0 green:186.0/255.0 blue:252.0/255.0 alpha:1.0]

#define kCustomNavigationBarBackButtonTextFont     [UIFont fontWithName:@"STHeitiSC-Light" size:15]

//===自定义navigationbar
#define kCustomNavigationBarFont                 [UIFont fontWithName:@"STHeitiSC-Medium" size:17]
#define kCustomNavigationBarTextColor             [UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:1.0]
#define kCustomNavigationBarBackButtonTextColor    [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define kCustomNavigationBarBackButtonTextHighlightedColor    [UIColor colorWithRed:5.0/255.0 green:55.0/255.0 blue:34.0/255.0 alpha:1.0]

#define kDialViewBgColor [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:236.0/255.0 alpha:1.0]

#define KPublicKey                  @"nianhui2015#*"

#define kLoginURL                   @"http://api.uxin.com/v2/nianhui/login?"            //登陆请求
#define kGetAllImgURL               @"http://api.uxin.com/v2/nianhui/getalluser?"       //获取全部员工数据
#define KgetOneURL                  @"http://api.uxin.com/v2/nianhui/getoneuser?"       //获取单个员工数据
#define kLikeClick                  @"http://api.uxin.com/v2/nianhui/like?"              //点赞
#define kAddSigh                    @"http://api.uxin.com/v2/nianhui/addsigh?"           //上传签名

#define kVoteURL                    @"http://api.uxin.com/v2/nianhui/vote"              //投票页url
#define kMsgUrl                     @"http://api.uxin.com/v2/nianhui/news"              //新闻页广告

#define kPhone                      @"phone"                             //电话号码
#define kCompany                    @"company"                           //公司
#define kLevelone                   @"levelone"                          //一级部门
#define kLeveltwo                   @"leveltwo"                          //二级部门
#define kName                       @"name"                              //用户名
#define kRTXid                      @"RTXid"                             //用户uid
#define kImgUrl                     @"imgUrl"                            //大头像
#define kSubImag                    @"subimg"                            //小头像
#define kVip                        @"bkVip"                             //是否为会员

#define kNHUpdateImageKey            @"WSUpdateImageKey"         // 更新界面的网络图片的key


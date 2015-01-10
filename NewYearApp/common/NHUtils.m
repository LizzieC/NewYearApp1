//
//  NHUtils.m
//  NewYearApp
//
//  Created by chenliqian on 14-12-27.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import "NHUtils.h"
#import "Reachability.h"

@implementation NHUtils
+ (NHUtils *)shareInstance
{
    static NHUtils *downloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader = [NHUtils new];
    });
    return downloader;
}

+ (PhoneNetType)getPhoneNetMode
{
    PhoneNetType nPhoneNetType = PNT_UNKNOWN;
    
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable)
    {
        nPhoneNetType = PNT_WIFI;
    }
    else if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)
    {
        nPhoneNetType = PNT_2G3G;
    }
    
    return nPhoneNetType;
}

+ (void)setValue:(id)value forKey:(id)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}
+ (id)getValueForKey:(id)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id value = [defaults objectForKey:key];
    return value;
}


@end

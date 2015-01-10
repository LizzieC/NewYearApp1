//
//  NHUtils.h
//  NewYearApp
//
//  Created by chenliqian on 14-12-27.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NHUtils : NSObject
//单例
+ (NHUtils *)shareInstance;

/** 获取手机当前网络类型 */
+ (PhoneNetType)getPhoneNetMode;

/** 保存数据到NSUserDefaults里 */
+ (void)setValue:(id)value forKey:(id)key;

/** 从NSUserDefaults中获取数据 */
+ (id)getValueForKey:(id)key;

@end

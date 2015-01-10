//
//  wldh_md5.h
//  WldhUtils
//
//  Created by dyn on 13-6-5.
//  Copyright (c) 2013年 dyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wldh_md5 : NSObject

/*
 功能：   初始化方法
 输入参数：无
 返回值：  全局唯一的wldh_md5对象
 */
+ (wldh_md5*)shareUtility;

/*
 功能：加密字符串
 输入参数：str：需要加密的字符串
 返回值：  加密后字符串
 */

- (NSString *)md5:(NSString *)str ;
@end

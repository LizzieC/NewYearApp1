//
//  HttpRequestManager.h
//  DaCheJiuDianProject
//
//  Created by mac on 14-2-17.
//  Copyright (c) 2014年 mac. All rights reserved.
//

//请求管理类，维护request对象的生命周期(将request存到字典中，key值为请求地址)
#import <Foundation/Foundation.h>

@interface HttpRequestManager : NSObject
//单例
+(HttpRequestManager *)shareManager;
//存request
- (void)setRequest:(id)object key:(NSString *)urlString;
//remove request
- (void)removeRequestWithKey:(NSString *)urlString;
@end

//
//  HttpRequestManager.m
//  DaCheJiuDianProject
//
//  Created by mac on 14-2-17.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "HttpRequestManager.h"

@implementation HttpRequestManager
{
    //用户管理request对象
    NSMutableDictionary *_resultDic;
}
- (void)dealloc
{
    manager = nil;
    [manager release];
    _resultDic = nil;
    [_resultDic release];
    [super dealloc];
}
//单例
static HttpRequestManager *manager = nil;
+(HttpRequestManager *)shareManager{
    if (manager == nil) {
        manager = [[HttpRequestManager alloc] init];
    }
    return manager;
}

- (id)init{
    self = [super init];
    if (self) {
        _resultDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}
//存request
- (void)setRequest:(id)object key:(NSString *)urlString{
    if (object == nil) {
        return;
    }
    //object 为nil  setObject 方法直接崩溃
    [_resultDic setObject:object forKey:urlString];
}
//remove request
- (void)removeRequestWithKey:(NSString *)urlString{
    [_resultDic removeObjectForKey:urlString];
}


@end

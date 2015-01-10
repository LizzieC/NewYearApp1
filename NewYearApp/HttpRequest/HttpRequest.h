//
//  HttpRequest.h
//  DaCheJiuDianProject
//
//  Created by mac on 14-2-17.
//  Copyright (c) 2014年 mac. All rights reserved.
//与服务器交互的类（请求类）

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject<NSURLConnectionDataDelegate>
//请求地址
@property (nonatomic,copy) NSString *requestUrlString;
//请求下来的数据
@property (nonatomic,retain) NSMutableData *downloadData;
//通知id 来进行后续的操作
@property (nonatomic,retain) id target;
//后续操作
@property (nonatomic,assign) SEL aciton;
@property (nonatomic,assign)BOOL isRefresh;

//生成httpRequest对象，并执行服务器的交互
//外部使用此类，只需要调用此方法，不用理会内部的实现
+(HttpRequest *)requestWithUrlString:(NSString *)str target:(id)target aciton:(SEL)aciton;

+ (HttpRequest *)requestWithUrlString:(NSString *)str target:(id)target action:(SEL)action isRefresh:(BOOL)isRefresh;
@end

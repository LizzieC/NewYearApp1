//
//  HttpRequest.m
//  DaCheJiuDianProject
//
//  Created by mac on 14-2-17.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "HttpRequest.h"
#import "HttpRequestManager.h"

@implementation HttpRequest
{
    NSURLConnection *_urlConnection;
    BOOL has;
}
@synthesize downloadData = _downloadData;
@synthesize requestUrlString = _requestUrlString;
@synthesize target = _target;
-(void)dealloc
{
    _downloadData = nil;
    [_downloadData release];
    _requestUrlString = nil;
    [_requestUrlString release];
    [_target release];
    _urlConnection = nil;
    [_urlConnection release];
    [super dealloc];
}
-(id)init
{
    self = [super init];
    if (self) {
        _downloadData = [[NSMutableData alloc]init];
    }
    return self;
}

+ (HttpRequest *)requestWithUrlString:(NSString *)str target:(id)target action:(SEL)action isRefresh:(BOOL)isRefresh {
    HttpRequest *request = [[HttpRequest alloc] init];
    request.requestUrlString = str;
    request.target = target;
    request.aciton = action;
    request.isRefresh = isRefresh;
    
    [request startRequest];
    //将request对象加入manager中
    [[HttpRequestManager shareManager] setRequest:request key:str];
        return request;
    [request release];

}
+(HttpRequest *)requestWithUrlString:(NSString *)str target:(id)target aciton:(SEL)aciton {
    return [HttpRequest requestWithUrlString:str target:target action:aciton isRefresh:NO];
}
//向服务器发起请求的方法
- (void)startRequest{
    if (_requestUrlString.length ==0) {
        return;
    }
    NSURL *url = [NSURL URLWithString:_requestUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //http协议 get请求  请求方式 异步
    _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
#pragma mark - url Connection Delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //清空旧数据 ,200 ok  404/400/500
    [_downloadData setLength:0];
}
//收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_downloadData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //接收完成
    //向各个视图控制器分发数据
    //移除request
    [[HttpRequestManager shareManager] removeRequestWithKey:_requestUrlString];
    if ([_target respondsToSelector:_aciton]) {
        //告知编译器 performSelector 没有问题
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_aciton withObject:self];
#pragma clang diagnostic pop
    }
}
//网络不好，或者请求失败时
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",error.localizedDescription);
    has=YES;
    
    if([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."])
    {
        has=NO;
        NSString*str=[NSString stringWithFormat:@"%d",has];
        NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
        [dict setObject:str forKey:@"123"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"has" object:self userInfo:dict];
        [dict release];
    }
}


@end

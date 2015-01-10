//
//  WebViewController.h
//  NewYearApp
//
//  Created by chenliqian on 14-12-23.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController
<UIWebViewDelegate,
UIGestureRecognizerDelegate>
{
    NSString        *m_strTitle;//窗口标题
    NSTimer            *_loadTimerout;//超时定时器
    BOOL            isNeedUPdata;
    NSString            *_urlRequest;
}

- (void)setTitle:(NSString *)title withURL:(NSString *)urlStr;
@end

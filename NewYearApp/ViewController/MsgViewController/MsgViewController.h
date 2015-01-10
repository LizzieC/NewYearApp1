//
//  MsgViewController.h
//  NewYearApp
//
//  Created by chenliqian on 14-12-17.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgViewController : BaseViewController<UIWebViewDelegate>
{
    NSTimer     *_loadTimerout;
}
@property(nonatomic,assign) CGRect   MsgRect;

@end

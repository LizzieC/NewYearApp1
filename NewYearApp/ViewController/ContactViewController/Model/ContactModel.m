//
//  ContactModel.m
//  NewYearApp
//
//  Created by chenliqian on 14-12-26.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel
@synthesize isVip;      //幕前幕后
@synthesize idcard;
@synthesize imgURL;
@synthesize name;
@synthesize phone;
@synthesize subimgURL;
@synthesize uid;
@synthesize likeNum;
@synthesize isLike;
@synthesize company;
@synthesize levelone;
@synthesize SaveLikeNum;

- (void)dealloc
{
    R(isVip);R(idcard);R(imgURL);R(name);R(phone);R(subimgURL);R(uid);R(isLike);R(likeNum);R(company);R(levelone);R(SaveLikeNum);
    [super dealloc];
}


@end

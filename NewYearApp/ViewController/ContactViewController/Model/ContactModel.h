//
//  ContactModel.h
//  NewYearApp
//
//  Created by chenliqian on 14-12-26.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject
@property (nonatomic,copy)NSString *isVip;//是否幕后
@property (nonatomic,copy)NSString *idcard;//id
@property (nonatomic,copy)NSString *imgURL;//大图
@property (nonatomic,copy)NSString *name;//名字
@property (nonatomic,copy)NSString *phone;//电话号码
@property (nonatomic,copy)NSString *subimgURL;//小图
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *likeNum;//点赞人数
@property (nonatomic)int SaveLikeNum;//保存点赞人数
@property (nonatomic,copy)NSString *isLike;//是否在点赞状态
@property (nonatomic,copy)NSString *company;//公司名
@property (nonatomic,copy)NSString *levelone;//一级部门


@end

//
//  ShopCollectionViewCell.m
//  WldhWeishuo
//
//  Created by wulanzhou-mini on 14-12-4.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "EmployeeCollectionViewCell.h"

@implementation EmployeeCollectionViewCell

-(void)dealloc
{
    R(_productContainView);R(_employeeImageView);R(_labTitle);R(_btnVote);
    [_likeNum release];
    [_likeImg release];
    [_bkImgView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"EmployeeCollectionViewCell" owner:self options:nil];
        [self.contentView addSubview:self.productContainView];
        [self.labTitle sizeToFit];
        [self.likeNum sizeToFit];
        _employeeImageView.layer.cornerRadius = 10.0;
        _employeeImageView.layer.borderWidth = 0;
        _employeeImageView.layer.masksToBounds = YES;
    }
    return self;
}


@end

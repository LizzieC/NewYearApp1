//
//  ShopCollectionViewCell.h
//  WldhWeishuo
//
//  Created by wulanzhou-mini on 14-12-4.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "PSTCollectionView.h"
@interface EmployeeCollectionViewCell : PSUICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *productContainView;
@property (strong, nonatomic) IBOutlet UIImageView *employeeImageView;
@property (strong, nonatomic) IBOutlet UILabel *labTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnVote;
@property (retain, nonatomic) IBOutlet UILabel *likeNum;
@property (retain, nonatomic) IBOutlet UIImageView *likeImg;
@property (retain, nonatomic) IBOutlet UIImageView *bkImgView;

@end

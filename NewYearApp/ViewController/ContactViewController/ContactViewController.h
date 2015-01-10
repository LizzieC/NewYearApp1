//
//  ContactViewController.h
//  NewYearApp
//
//  Created by chenliqian on 14-12-17.
//  Copyright (c) 2014年 chenliqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTCollectionView.h"
@interface ContactViewController : BaseViewController
<PSTCollectionViewDataSource,
PSTCollectionViewDelegate,
UIGestureRecognizerDelegate,
UISearchBarDelegate>
{
    int                                 _currentSelectedIndex;  //当前选择按钮所属位置
    BOOL                                _isSearching;//在搜索状态
}
@property (nonatomic,strong) PSUICollectionView *tabCollectionView;
@property (nonatomic,strong) NSMutableArray *InfoDataArray;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UISearchBar *employSearchBar;
@property (nonatomic,strong) NSMutableArray *ShowDataArray;
@property (nonatomic,strong) NSMutableDictionary *cachedPics;
@property (nonatomic,strong) NSMutableDictionary *infoDict;

@property(nonatomic, assign)int currentSelectedIndex;


@end

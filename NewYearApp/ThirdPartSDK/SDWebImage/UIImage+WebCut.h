//
//  UIImage+WebCut.h
//  WldhClient
//
//  Created by mini1 on 14-4-18.
//  Copyright (c) 2014年 guoling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WebCut)

//适应某个区域大小
- (UIImage *)imageFitToSize:(CGSize)fitSize;

//裁剪图片
- (UIImage *)imageCutInRect:(CGRect)rect;

//等比列缩放
- (UIImage *)scaleToSize:(CGSize)aSize;

//放大
-(UIImage*)scaleToBigSize:(CGSize)size;

+ (UIImage *)createImageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end

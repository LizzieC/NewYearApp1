//
//  UIImage+WebCut.m
//  WldhClient
//
//  Created by mini1 on 14-4-18.
//  Copyright (c) 2014年 guoling. All rights reserved.
//

#import "UIImage+WebCut.h"

@implementation UIImage (WebCut)

- (UIImage *)imageFitToSize:(CGSize)fitSize
{
    if (fitSize.width == 0
        || fitSize.height == 0
        || self.size.height == 0
        || self.size.width == 0)
    {
        return nil;
    }
    
    CGSize subImageSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    
    //判断是以图片的长度为基准 还是以图片的宽度为基准,默认以width为基准
    float scale = fitSize.width / fitSize.height;
    float subWidth = subImageSize.width;
    float subHeight = subImageSize.width / scale;
    
    //判断height是否足够
    if (subHeight > subImageSize.height) //以width为基准，height不够,必需以height为基准
    {
        subHeight = subImageSize.height;
        subWidth = subImageSize.height * scale;
    }
    
    //定义裁剪的区域相对于原图片的位置
    CGRect subImageRect = CGRectMake((subImageSize.width - subWidth) / 2.0,
                                     (subImageSize.height - subHeight) / 2.0,
                                     subWidth,
                                     subHeight);
    
    UIImage *aImg = [self imageCutInRect:subImageRect];
    return aImg;
//    if (aImg)
//    {
//        return [aImg scaleToSize:fitSize];
//    }
//    else
//    {
//        return aImg;
//    }
}

- (UIImage *)imageCutInRect:(CGRect)rect
{
    CGImageRef imageRef = self.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    
    CGRect drawRect = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(drawRect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, drawRect, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    CGImageRelease(subImageRef);
    
    //返回裁剪的部分图像
    return subImage;
}

- (UIImage *)scaleToSize:(CGSize)aSize
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = aSize.height * 1.0 / height;
    float horizontalRadio = aSize.width * 1.0 / width;
    
    float radio = 1;
    if(verticalRadio > 1 && horizontalRadio > 1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width * radio;
    height = height * radio;
    
    int xPos = (aSize.width - width)/2;
    int yPos = (aSize.height - height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(aSize);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(UIImage*)scaleToBigSize:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ ( UIImage  *)imageWithColor:( UIColor  *)color size:( CGSize )size

{
    @autoreleasepool  {
        CGRect  rect =  CGRectMake ( 0 ,  0 , size. width , size. height );
        UIGraphicsBeginImageContext (rect. size );
        CGContextRef  context =  UIGraphicsGetCurrentContext ();
        CGContextSetFillColorWithColor (context,
                                        color. CGColor );
        CGContextFillRect (context, rect);
        UIImage  *img =  UIGraphicsGetImageFromCurrentImageContext ();
        UIGraphicsEndImageContext ();
        return  img;
        
    }
}

@end

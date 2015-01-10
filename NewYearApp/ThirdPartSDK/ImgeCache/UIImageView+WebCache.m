/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "ImageCacher.h"
#import "FileHelpers.h"


@implementation UIImageView (WebCache)
- (void)setImageWithURL:(NSURL *)headUrl placeholderImage:(UIImage *)placeholder cachedPics:(NSMutableDictionary*)cacheDic{
    self.image=placeholder;
    if (hasCachedImage(headUrl)) {
        if ([cacheDic objectForKey:hashCodeForURL(headUrl)]!=nil) {
            [self setImage:[cacheDic objectForKey:hashCodeForURL(headUrl)]];
        }else{
            [self setImage:[UIImage imageWithContentsOfFile:pathForURL(headUrl)]];
            [cacheDic setObject:[UIImage imageWithContentsOfFile:pathForURL(headUrl)] forKey:hashCodeForURL(headUrl)];
        }
    }else
    {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:headUrl,@"url",self,@"imageView",nil];
        [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dic];
        
    }
}

- (void)setImageWithURL:(NSURL *)headUrl placeholderImage:(UIImage *)placeholder
{
    self.image=placeholder;
    if (hasCachedImage(headUrl)) {
      [self setImage:[UIImage imageWithContentsOfFile:pathForURL(headUrl)]];
    }else
    {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:headUrl,@"url",self,@"imageView",nil];
        [NSThread detachNewThreadSelector:@selector(cacheSubImage:) toTarget:[ImageCacher defaultCacher] withObject:dic];
    }
}
@end

/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "UIImage+WebCut.h"

@implementation UIImageView (WebCache)

- (void)startWaitActivity
{
    [self stopWaitActivity];
    UIActivityIndicatorView *acView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    acView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    acView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    acView.tag = 1999;
    [self addSubview:acView];
    [acView startAnimating];
}

- (void)stopWaitActivity
{
    UIView *aView = [self viewWithTag:1999];
    if (aView)
    {
        if ([aView isKindOfClass:[UIActivityIndicatorView class]])
        {
            [(UIActivityIndicatorView *)aView stopAnimating];
        }
        aView.hidden = YES;
        [aView removeFromSuperview];
    }
}

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    //[self setImageWithURL:url placeholderImage:placeholder options:0];
    [self setImageWithURL:url placeholderImage:placeholder isStoreToDisk:YES];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder isStoreToDisk:(BOOL)isStore
{
    [self setImageWithURL:url placeholderImage:placeholder isStoreToDisk:isStore options:SDWebImageRetryFailed];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self setImageWithURL:url placeholderImage:placeholder isStoreToDisk:YES options:options];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder isStoreToDisk:(BOOL)isStore options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    self.image = placeholder;
    
    if (url)
    {
        [manager downloadWithURL:url
                        delegate:self
                         options:options
                        userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:isStore]
                                                             forKey:@"imageIsStore"]];
    }
}

- (void)setImageWithURL:(NSURL *)url imageKey:(NSString *)imgKey placeholderImage:(UIImage *)placeholder isStoreToDisk:(BOOL)isStore options:(SDWebImageOptions)options
{
    [self setImageWithURL:url
                 imageKey:imgKey
         placeholderImage:placeholder
          isStartActivity:YES
            isStoreToDisk:isStore
                  options:options];
}

- (void)setImageWithURL:(NSURL *)url imageKey:(NSString *)imgKey placeholderImage:(UIImage *)placeholder isStartActivity:(BOOL)isStart isStoreToDisk:(BOOL)isStore options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    self.image = placeholder;
    
    if (url)
    {
        if (isStart)
        {
            [self performSelectorOnMainThread:@selector(startWaitActivity) withObject:nil waitUntilDone:YES];
        }
        
        [manager downloadWithURL:url
                        delegate:self
                         options:options
                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithBool:isStore],@"imageIsStore",
                                  imgKey ? imgKey : @"",@"imageStoreKey",
                                  nil]];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
    }
}
#endif

- (void)cancelCurrentImageLoad
{
    @synchronized(self)
    {
        [self performSelectorOnMainThread:@selector(stopWaitActivity) withObject:nil waitUntilDone:YES];
        [[SDWebImageManager sharedManager] cancelForDelegate:self];
    }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info
{
    if (image)
    {
        NSLog(@"---Rich msg down image success for %@",
              [info objectForKey:@"imageStoreKey"]);
//        [self performSelectorOnMainThread:@selector(stopWaitActivity) withObject:nil waitUntilDone:YES];
//        self.image = [image imageFitToSize:self.frame.size];
//        [self setNeedsLayout];
    }
    else
    {
        NSLog(@"---Rich msg down image failed for %@",
              [info objectForKey:@"imageStoreKey"]);
//        [self performSelectorOnMainThread:@selector(stopWaitActivity) withObject:nil waitUntilDone:YES];
    }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    if (image)
    {
        [self performSelectorOnMainThread:@selector(stopWaitActivity) withObject:nil waitUntilDone:YES];
        self.image = [image imageFitToSize:self.frame.size];
        [self setNeedsLayout];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(stopWaitActivity) withObject:nil waitUntilDone:YES];
    }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
    if (image)
    {
        NSLog(@"---Rich msg down image success for url:%@",url);
        [self performSelectorOnMainThread:@selector(stopWaitActivity) withObject:nil waitUntilDone:YES];
        self.image = [image imageFitToSize:self.frame.size];
        [self setNeedsLayout];
    }
    else
    {
        NSLog(@"---Rich msg down image failed for url:%@",url);
        [self performSelectorOnMainThread:@selector(stopWaitActivity) withObject:nil waitUntilDone:YES];
    }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error forURL:(NSURL *)url userInfo:(NSDictionary *)info
{
    NSLog(@"---Rich msg down image failed(%d_%@) for %@",
          [error code],
          [error domain],
          [info objectForKey:@"imageStoreKey"]);
    [self performSelectorOnMainThread:@selector(stopWaitActivity) withObject:nil waitUntilDone:YES];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error forURL:(NSURL *)url
{
//    NSLog(@"---Rich msg down image failed(%d_%@) for url:%@",
//          [error code],
//          [error domain],
//          url);
//    [self performSelectorOnMainThread:@selector(stopWaitActivity) withObject:nil waitUntilDone:YES];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error
{
//    NSLog(@"---Rich msg down image failed(%d_%@)",
//          [error code],
//          [error domain]);
//    [self performSelectorOnMainThread:@selector(stopWaitActivity) withObject:nil waitUntilDone:YES];
}

@end

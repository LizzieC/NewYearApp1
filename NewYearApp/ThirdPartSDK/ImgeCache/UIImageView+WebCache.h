

#import <UIKit/UIKit.h>

@interface UIImageView (WebCache)



/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @see setImageWithURL:placeholderImage:options:
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cachedPics:(NSMutableDictionary*)cacheDic;
//单张
- (void)setImageWithURL:(NSURL *)headUrl placeholderImage:(UIImage *)placeholder;

@end

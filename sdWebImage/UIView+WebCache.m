// UIView+WebCache

/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageCompat.h"
#import "SDWebImageDefine.h"
#import "SDWebImageManager.h"
#import "SDWebImageTransition.h"
#import "SDWebImageIndicator.h"

/**
 The value specify that the image progress unit count cannot be determined because the progressBlock is not been called.
 */
FOUNDATION_EXPORT const int64_t SDWebImageProgressUnitCountUnknown; /* 1LL */

typedef void(^SDSetImageBlock)(UIImage * _Nullable image, NSData * _Nullable imageData, SDImageCacheType cacheType, NSURL * _Nullable imageURL);

/**
 Integrates SDWebImage async downloading and caching of remote images with UIView subclass.
 */
@interface UIView (WebCache)

/**
 * Get the current image URL.
 *
 * @note Note that because of the limitations of categories this property can get out of sync if you use setImage: directly.
 */
@property (nonatomic, strong, readonly, nullable) NSURL *sd_imageURL;

/**
 * Get the current image operation key. Operation key is used to identify the different queries for one view instance (like UIButton).
 * See more about this in `SDWebImageContextSetImageOperationKey`.
 * If you cancel current image load, the key will be set to nil.
 * @note You can use method `UIView+WebCacheOperation` to investigate different queries' operation.
 */
@property (nonatomic, strong, readonly, nullable) NSString *sd_latestOperationKey;

/**
 * The current image loading progress associated to the view. The unit count is the received size and excepted size of download.
 * The `totalUnitCount` and `completedUnitCount` will be reset to 0 after a new image loading start (change from current queue). And they will be set to `SDWebImageProgressUnitCountUnknown` if the progressBlock not been called but the image loading success to mark the progress finished (change from main queue).
 * @note You can use Key-Value Observing on the progress, but you should take care that the change to progress is from a background queue during download(the same as progressBlock). If you want to using KVO and update the UI, make sure to dispatch on the main queue. And it's recommend to use some KVO libs like KVOController because it's more safe and easy to use.
 * @note The getter will create a progress instance if the value is nil. But by default, we don't create one. If you need to use Key-Value Observing, you must trigger the getter or set a custom progress instance before the loading start. The default value is nil.
 * @note Note that because of the limitations of categories this property can get out of sync if you update the progress directly.
 */
@property (nonatomic, strong, null_resettable) NSProgress *sd_imageProgress;

/**
 * Set the imageView `image` with an `url` and optionally a placeholder image.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param context        A context contains different options to perform specify changes or processes, see `SDWebImageContextOption`. This hold the extra objects which `options` enum can not hold.
 * @param setImageBlock  Block used for custom set image code. If not provide, use the built-in set image code (supports `UIImageView/NSImageView` and `UIButton/NSButton` currently)
 * @param progressBlock  A block called while image is downloading
 *                       @note the progress block is executed on a background queue
 * @param completedBlock A block called when operation has been completed.
 *   This block has no return value and takes the requested UIImage as first parameter and the NSData representation as second parameter.
 *   In case of error the image parameter is nil and the third parameter may contain an NSError.
 *
 *   The forth parameter is an `SDImageCacheType` enum indicating if the image was retrieved from the local cache
 *   or from the memory cache or from the network.
 *
 *   The fifth parameter normally is always YES. However, if you provide SDWebImageAvoidAutoSetImage with SDWebImageProgressiveLoad options to enable progressive downloading and set the image yourself. This block is thus called repeatedly with a partial image. When image is fully downloaded, the
 *   block is called a last time with the full image and the last parameter set to YES.
 *
 *   The last parameter is the original image URL
 */
- (void)sd_internalSetImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                           options:(SDWebImageOptions)options
                           context:(nullable SDWebImageContext *)context
                     setImageBlock:(nullable SDSetImageBlock)setImageBlock
                          progress:(nullable SDImageLoaderProgressBlock)progressBlock
                         completed:(nullable SDInternalCompletionBlock)completedBlock;

/**
 * Cancel the current image load
 */
- (void)sd_cancelCurrentImageLoad;

#if SD_UIKIT || SD_MAC

#pragma mark - Image Transition

/**
 The image transition when image load finished. See `SDWebImageTransition`.
 If you specify nil, do not do transition. Defaults to nil.
 */
@property (nonatomic, strong, nullable) SDWebImageTransition *sd_imageTransition;

#pragma mark - Image Indicator

/**
 The image indicator during the image loading. If you do not need indicator, specify nil. Defaults to nil
 The setter will remove the old indicator view and add new indicator view to current view's subview.
 @note Because this is UI related, you should access only from the main queue.
 */
@property (nonatomic, strong, nullable) id<SDWebImageIndicator> sd_imageIndicator;

#endif

@end

___________________________________________________________________________________________________
.m 文件的内容
___________________________________________________________________________________________________

const int64_t SDWebImageProgressUnitCountUnknown = 1LL;

@implementation UIView (WebCache)

- (nullable NSURL *)sd_imageURL {
    return objc_getAssociatedObject(self, @selector(sd_imageURL));
}

- (void)setSd_imageURL:(NSURL * _Nullable)sd_imageURL {
    objc_setAssociatedObject(self, @selector(sd_imageURL), sd_imageURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable NSString *)sd_latestOperationKey {
    return objc_getAssociatedObject(self, @selector(sd_latestOperationKey));
}

- (void)setSd_latestOperationKey:(NSString * _Nullable)sd_latestOperationKey {
    objc_setAssociatedObject(self, @selector(sd_latestOperationKey), sd_latestOperationKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSProgress *)sd_imageProgress {
    NSProgress *progress = objc_getAssociatedObject(self, @selector(sd_imageProgress));
    if (!progress) {
        progress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
        self.sd_imageProgress = progress;
    }
    return progress;
}

- (void)setSd_imageProgress:(NSProgress *)sd_imageProgress {
    objc_setAssociatedObject(self, @selector(sd_imageProgress), sd_imageProgress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sd_internalSetImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                           options:(SDWebImageOptions)options
                           context:(nullable SDWebImageContext *)context
                     setImageBlock:(nullable SDSetImageBlock)setImageBlock
                          progress:(nullable SDImageLoaderProgressBlock)progressBlock
                         completed:(nullable SDInternalCompletionBlock)completedBlock {
    if (context) {
        // copy to avoid mutable object
        context = [context copy];
    } else {
        context = [NSDictionary dictionary];
    }
    NSString *validOperationKey = context[SDWebImageContextSetImageOperationKey];
    if (!validOperationKey) {
        // pass through the operation key to downstream, which can used for tracing operation or image view class
        validOperationKey = NSStringFromClass([self class]);
        SDWebImageMutableContext *mutableContext = [context mutableCopy];
        mutableContext[SDWebImageContextSetImageOperationKey] = validOperationKey;
        context = [mutableContext copy];
    }
    self.sd_latestOperationKey = validOperationKey; // 通过类来作为一个key ，operation作为value
    [self sd_cancelImageLoadOperationWithKey:validOperationKey]; // 为什么要进行一个取消的操作
    self.sd_imageURL = url;
    
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            [self sd_setImage:placeholder imageData:nil basedOnClassOrViaCustomSetImageBlock:setImageBlock cacheType:SDImageCacheTypeNone imageURL:url];
        });
    }
    
    if (url) {
        // reset the progress // 有进度条的概念
        NSProgress *imageProgress = objc_getAssociatedObject(self, @selector(sd_imageProgress));
        if (imageProgress) {
            imageProgress.totalUnitCount = 0;
            imageProgress.completedUnitCount = 0;
        }
        
#if SD_UIKIT || SD_MAC
        // check and start image indicator 。菊花旋转的东西
        [self sd_startImageIndicator];
        id<SDWebImageIndicator> imageIndicator = self.sd_imageIndicator;
#endif
        SDWebImageManager *manager = context[SDWebImageContextCustomManager];
        if (!manager) {
            manager = [SDWebImageManager sharedManager];
        } else {
//             自定义的manger
            // remove this manager to avoid retain cycle (manger -> loader -> operation -> context -> manager)
            SDWebImageMutableContext *mutableContext = [context mutableCopy];
            mutableContext[SDWebImageContextCustomManager] = nil;
            context = [mutableContext copy];
        }
        
        SDImageLoaderProgressBlock combinedProgressBlock = ^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//             进度的处理， 看看这个要怎么进行进度的处理内容
            if (imageProgress) {
                imageProgress.totalUnitCount = expectedSize;
                imageProgress.completedUnitCount = receivedSize;
            }
#if SD_UIKIT || SD_MAC
            if ([imageIndicator respondsToSelector:@selector(updateIndicatorProgress:)]) {
                double progress = 0;
                if (expectedSize != 0) {
                    progress = (double)receivedSize / expectedSize;
                }
                progress = MAX(MIN(progress, 1), 0); // 0.0 - 1.0
                dispatch_async(dispatch_get_main_queue(), ^{
                    [imageIndicator updateIndicatorProgress:progress];
                });
            }
#endif
            if (progressBlock) {
                progressBlock(receivedSize, expectedSize, targetURL);
            }
        };
        @weakify(self);
//         主要看一下这个内容， 看看是怎么处理
        id <SDWebImageOperation> operation = [manager loadImageWithURL:url options:options context:context progress:combinedProgressBlock completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            @strongify(self);
            if (!self) { return; }
            // if the progress not been updated, mark it to complete state 表示我们这个内容宁下载成功了，进度所以是完成了的
            if (imageProgress && finished && !error && imageProgress.totalUnitCount == 0 && imageProgress.completedUnitCount == 0) {
                imageProgress.totalUnitCount = SDWebImageProgressUnitCountUnknown;
                imageProgress.completedUnitCount = SDWebImageProgressUnitCountUnknown;
            }
            
#if SD_UIKIT || SD_MAC
            // check and stop image indicator
            if (finished) { // 停止菊花
                [self sd_stopImageIndicator];
            }
#endif
            
            BOOL shouldCallCompletedBlock = finished || (options & SDWebImageAvoidAutoSetImage); // 是否可以调用 完成回调
            BOOL shouldNotSetImage = ((image && (options & SDWebImageAvoidAutoSetImage)) ||
                                      (!image && !(options & SDWebImageDelayPlaceholder))); // 不需要设置图片
            SDWebImageNoParamsBlock callCompletedBlockClojure = ^{
                if (!self) { return; }
                if (!shouldNotSetImage) { //
                    [self sd_setNeedsLayout]; //不需要设置图片，为什么需要刷新？
                }
                if (completedBlock && shouldCallCompletedBlock) {
                    completedBlock(image, data, error, cacheType, finished, url); // 下载完成回调成功
                }
            };
            
            // case 1a: we got an image, but the SDWebImageAvoidAutoSetImage flag is set
            // OR
            // case 1b: we got no image and the SDWebImageDelayPlaceholder is not set
            if (shouldNotSetImage) { // 不需要设置图片的时候， 直接回调回去
                dispatch_main_async_safe(callCompletedBlockClojure);
                return;
            }
            
            UIImage *targetImage = nil;
            NSData *targetData = nil;
            if (image) { // 如果有图片设置图片，
                // case 2a: we got an image and the SDWebImageAvoidAutoSetImage is not set
                targetImage = image;
                targetData = data;
            } else if (options & SDWebImageDelayPlaceholder) { // 如果没有，并且有占位图就设置占位图
                // case 2b: we got no image and the SDWebImageDelayPlaceholder flag is set
                targetImage = placeholder;
                targetData = nil;
            }
            
#if SD_UIKIT || SD_MAC
            // check whether we should use the image transition
            SDWebImageTransition *transition = nil;
            BOOL shouldUseTransition = NO;
            if (options & SDWebImageForceTransition) {
                // Always
                shouldUseTransition = YES; // 过渡状态， 因为我们在同步硬盘的图片或者从网络获取的图片
            } else if (cacheType == SDImageCacheTypeNone) {
                // From network
                shouldUseTransition = YES; //
            } else {
                // From disk (and, user don't use sync query)
                if (cacheType == SDImageCacheTypeMemory) {
                    shouldUseTransition = NO;
                } else if (cacheType == SDImageCacheTypeDisk) { // 图片从硬盘中获取
                    if (options & SDWebImageQueryMemoryDataSync || options & SDWebImageQueryDiskDataSync) {
                        shouldUseTransition = NO; // 内存数据同步和硬盘数据同步，这个就不需要过渡了
                    } else {
                        shouldUseTransition = YES; // 其他的情况需要？？？ 这个有什么情况？ 将硬盘的数据同步到其他网络上？？？
                    }
                } else {
                    // Not valid cache type, fallback
                    shouldUseTransition = NO; //其他低就不过渡了
                }
            }
            if (finished && shouldUseTransition) {
                transition = self.sd_imageTransition; // 过渡的内容
            }
#endif
            dispatch_main_async_safe(^{
#if SD_UIKIT || SD_MAC
                [self sd_setImage:targetImage imageData:targetData basedOnClassOrViaCustomSetImageBlock:setImageBlock transition:transition cacheType:cacheType imageURL:imageURL];
#else
                [self sd_setImage:targetImage imageData:targetData basedOnClassOrViaCustomSetImageBlock:setImageBlock cacheType:cacheType imageURL:imageURL];
#endif
                callCompletedBlockClojure(); // 回调
            });
        }];
//        设置图片的operation 到对应的key上main
        [self sd_setImageLoadOperation:operation forKey:validOperationKey];
    } else {
#if SD_UIKIT || SD_MAC // 这个是错误的内容处理
        [self sd_stopImageIndicator];
#endif
        dispatch_main_async_safe(^{
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:SDWebImageErrorInvalidURL userInfo:@{NSLocalizedDescriptionKey : @"Image url is nil"}];
                completedBlock(nil, nil, error, SDImageCacheTypeNone, YES, url);
            }
        });
    }
}

- (void)sd_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:self.sd_latestOperationKey];
    self.sd_latestOperationKey = nil;
}

- (void)sd_setImage:(UIImage *)image imageData:(NSData *)imageData basedOnClassOrViaCustomSetImageBlock:(SDSetImageBlock)setImageBlock cacheType:(SDImageCacheType)cacheType imageURL:(NSURL *)imageURL {
#if SD_UIKIT || SD_MAC
    [self sd_setImage:image imageData:imageData basedOnClassOrViaCustomSetImageBlock:setImageBlock transition:nil cacheType:cacheType imageURL:imageURL];
#else
    // watchOS does not support view transition. Simplify the logic
    if (setImageBlock) {
        setImageBlock(image, imageData, cacheType, imageURL);
    } else if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)self;
        [imageView setImage:image];
    }
#endif
}

#if SD_UIKIT || SD_MAC
// 真实的设置图片的内容
- (void)sd_setImage:(UIImage *)image imageData:(NSData *)imageData basedOnClassOrViaCustomSetImageBlock:(SDSetImageBlock)setImageBlock transition:(SDWebImageTransition *)transition cacheType:(SDImageCacheType)cacheType imageURL:(NSURL *)imageURL {
    UIView *view = self;
    SDSetImageBlock finalSetImageBlock;
    if (setImageBlock) {
        finalSetImageBlock = setImageBlock;
    } else if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)view;
        finalSetImageBlock = ^(UIImage *setImage, NSData *setImageData, SDImageCacheType setCacheType, NSURL *setImageURL) {
            imageView.image = setImage;
        };
    }
#if SD_UIKIT
    else if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        finalSetImageBlock = ^(UIImage *setImage, NSData *setImageData, SDImageCacheType setCacheType, NSURL *setImageURL) {
            [button setImage:setImage forState:UIControlStateNormal];
        };
    }
#endif
#if SD_MAC
    else if ([view isKindOfClass:[NSButton class]]) {
        NSButton *button = (NSButton *)view;
        finalSetImageBlock = ^(UIImage *setImage, NSData *setImageData, SDImageCacheType setCacheType, NSURL *setImageURL) {
            button.image = setImage;
        };
    }
#endif
    
    if (transition) {
        NSString *originalOperationKey = view.sd_latestOperationKey;

#if SD_UIKIT
        [UIView transitionWithView:view duration:0 options:0 animations:^{
            if (!view.sd_latestOperationKey || ![originalOperationKey isEqualToString:view.sd_latestOperationKey]) {
                return;
            }
            // 0 duration to let UIKit render placeholder and prepares block
            if (transition.prepares) {
                transition.prepares(view, image, imageData, cacheType, imageURL);
            }
        } completion:^(BOOL finished) {
            [UIView transitionWithView:view duration:transition.duration options:transition.animationOptions animations:^{
                if (!view.sd_latestOperationKey || ![originalOperationKey isEqualToString:view.sd_latestOperationKey]) {
                    return;
                }
                if (finalSetImageBlock && !transition.avoidAutoSetImage) {
                    finalSetImageBlock(image, imageData, cacheType, imageURL);
                }
                if (transition.animations) {
                    transition.animations(view, image);
                }
            } completion:^(BOOL finished) {
                if (!view.sd_latestOperationKey || ![originalOperationKey isEqualToString:view.sd_latestOperationKey]) {
                    return;
                }
                if (transition.completion) {
                    transition.completion(finished);
                }
            }];
        }];
#elif SD_MAC
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull prepareContext) {
            if (!view.sd_latestOperationKey || ![originalOperationKey isEqualToString:view.sd_latestOperationKey]) {
                return;
            }
            // 0 duration to let AppKit render placeholder and prepares block
            prepareContext.duration = 0;
            if (transition.prepares) {
                transition.prepares(view, image, imageData, cacheType, imageURL);
            }
        } completionHandler:^{
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                if (!view.sd_latestOperationKey || ![originalOperationKey isEqualToString:view.sd_latestOperationKey]) {
                    return;
                }
                context.duration = transition.duration;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                CAMediaTimingFunction *timingFunction = transition.timingFunction;
#pragma clang diagnostic pop
                if (!timingFunction) {
                    timingFunction = SDTimingFunctionFromAnimationOptions(transition.animationOptions);
                }
                context.timingFunction = timingFunction;
                context.allowsImplicitAnimation = SD_OPTIONS_CONTAINS(transition.animationOptions, SDWebImageAnimationOptionAllowsImplicitAnimation);
                if (finalSetImageBlock && !transition.avoidAutoSetImage) {
                    finalSetImageBlock(image, imageData, cacheType, imageURL);
                }
                CATransition *trans = SDTransitionFromAnimationOptions(transition.animationOptions);
                if (trans) {
                    [view.layer addAnimation:trans forKey:kCATransition];
                }
                if (transition.animations) {
                    transition.animations(view, image);
                }
            } completionHandler:^{
                if (!view.sd_latestOperationKey || ![originalOperationKey isEqualToString:view.sd_latestOperationKey]) {
                    return;
                }
                if (transition.completion) {
                    transition.completion(YES);
                }
            }];
        }];
#endif
    } else {
        if (finalSetImageBlock) {
            finalSetImageBlock(image, imageData, cacheType, imageURL);
        }
    }
}
#endif

- (void)sd_setNeedsLayout {
#if SD_UIKIT
    [self setNeedsLayout];
#elif SD_MAC
    [self setNeedsLayout:YES];
#elif SD_WATCH
    // Do nothing because WatchKit automatically layout the view after property change
#endif
}

#if SD_UIKIT || SD_MAC

#pragma mark - Image Transition
- (SDWebImageTransition *)sd_imageTransition {
    return objc_getAssociatedObject(self, @selector(sd_imageTransition));
}

- (void)setSd_imageTransition:(SDWebImageTransition *)sd_imageTransition {
    objc_setAssociatedObject(self, @selector(sd_imageTransition), sd_imageTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Indicator
- (id<SDWebImageIndicator>)sd_imageIndicator {
    return objc_getAssociatedObject(self, @selector(sd_imageIndicator));
}

- (void)setSd_imageIndicator:(id<SDWebImageIndicator>)sd_imageIndicator {
    // Remove the old indicator view
    id<SDWebImageIndicator> previousIndicator = self.sd_imageIndicator;
    [previousIndicator.indicatorView removeFromSuperview];
    
    objc_setAssociatedObject(self, @selector(sd_imageIndicator), sd_imageIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Add the new indicator view
    UIView *view = sd_imageIndicator.indicatorView;
    if (CGRectEqualToRect(view.frame, CGRectZero)) {
        view.frame = self.bounds;
    }
    // Center the indicator view
#if SD_MAC
    [view setFrameOrigin:CGPointMake(round((NSWidth(self.bounds) - NSWidth(view.frame)) / 2), round((NSHeight(self.bounds) - NSHeight(view.frame)) / 2))];
#else
    view.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
#endif
    view.hidden = NO;
    [self addSubview:view];
}

- (void)sd_startImageIndicator {
    id<SDWebImageIndicator> imageIndicator = self.sd_imageIndicator;
    if (!imageIndicator) {
        return;
    }
    dispatch_main_async_safe(^{
        [imageIndicator startAnimatingIndicator];
    });
}

- (void)sd_stopImageIndicator {
    id<SDWebImageIndicator> imageIndicator = self.sd_imageIndicator;
    if (!imageIndicator) {
        return;
    }
    dispatch_main_async_safe(^{
        [imageIndicator stopAnimatingIndicator];
    });
}

#endif

@end

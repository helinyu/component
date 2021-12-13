/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"

typedef NS_ENUM(NSUInteger, SDImageCacheConfigExpireType) {
    /**
     * When the image is accessed it will update this value
     */
//    * 访问的日志，也就是主要我访问了这张图片，这个日期就会改变
    SDImageCacheConfigExpireTypeAccessDate,
    /**
     * The image was obtained from the disk cache (Default)
     */
//    默认，修改的日志
    SDImageCacheConfigExpireTypeModificationDate
};


// 缓存缓存的配置
@interface SDImageCacheConfig : NSObject

/**
 * Decompressing images that are downloaded and cached can improve performance but can consume lot of memory.
 * Defaults to YES. Set this to NO if you are experiencing a crash due to excessive memory consumption.
 */
/// 下载获取和从缓存里面读取就开始解码， 消耗内存
/// 默认是YES：如果内存消耗出现崩溃可以将这个设置为NO
@property (assign, nonatomic) BOOL shouldDecompressImages;

/**
 * Whether or not to disable iCloud backup
 * Defaults to YES.
 */
// 是否取消icloud备份，默认是YES，取消
@property (assign, nonatomic) BOOL shouldDisableiCloud;

/**
 * Whether or not to use memory cache
 * @note When the memory cache is disabled, the weak memory cache will also be disabled.
 * Defaults to YES.
 */
// 默认是YES： 是否缓存在内尺寸中，weak cache
@property (assign, nonatomic) BOOL shouldCacheImagesInMemory;

/**
 * The option to control weak memory cache for images. When enable, `SDImageCache`'s memory cache will use a weak maptable to store the image at the same time when it stored to memory, and get removed at the same time.
 * However when memory warning is triggered, since the weak maptable does not hold a strong reference to image instacnce, even when the memory cache itself is purged, some images which are held strongly by UIImageViews or other live instances can be recovered again, to avoid later re-query from disk cache or network. This may be helpful for the case, for example, when app enter background and memory is purged, cause cell flashing after re-enter foreground.
 * Defautls to YES. You can change this option dynamically.
 */
// 就是说内存缓存里面还是有缓存的了？
// 默认是YES
// 当image被存储在内存中的同事使用maptable 存储这个图片。 同事被移除在内存中
// 内存警告触发：通过UIImageViews强关联或者其他活的对象重新恢复。拒绝从磁盘或者网络上恢复。
// 例如：进入后台，内存被清楚，造成cell被擦除掉，重新进入前台的时候，又可以恢复了
@property (assign, nonatomic) BOOL shouldUseWeakMemoryCache;
//和上面那个有什么区别？？？？

/**
 * The reading options while reading cache from disk.
 * Defaults to 0. You can set this to `NSDataReadingMappedIfSafe` to improve performance.
 */
//* 磁盘缓存上的数据读取
@property (assign, nonatomic) NSDataReadingOptions diskCacheReadingOptions;

/**
 * The writing options while writing cache to disk.
 * Defaults to `NSDataWritingAtomic`. You can set this to `NSDataWritingWithoutOverwriting` to prevent overwriting an existing file.
 */
// 磁盘数据写的选项
@property (assign, nonatomic) NSDataWritingOptions diskCacheWritingOptions;

/**
 * The maximum length of time to keep an image in the cache, in seconds.
 */
//* 缓存的最长时间 （s）
@property (assign, nonatomic) NSInteger maxCacheAge;

/**
 * The maximum size of the cache, in bytes.
 */
//* 缓存最大大小 （bytes）
@property (assign, nonatomic) NSUInteger maxCacheSize;

/**
 * The attribute which the clear cache will be checked against when clearing the disk cache
 * Default is Modified Date
 */
// 磁盘缓存过期的类型
@property (assign, nonatomic) SDImageCacheConfigExpireType diskCacheExpireType;

@end

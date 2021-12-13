//  解码器的管理类


//  管理多个解码器的对象
@interface SDWebImageCodersManager : NSObject<SDWebImageCoder>

/**
 Shared reusable instance
 */
+ (nonnull instancetype)sharedInstance;

/**
 All coders in coders manager. The coders array is a priority queue, which means the later added coder will have the highest priority
 */
@property (nonatomic, copy, readwrite, nullable) NSArray<id<SDWebImageCoder>> *coders;

/**
 Add a new coder to the end of coders array. Which has the highest priority.

 @param coder coder
 */
- (void)addCoder:(nonnull id<SDWebImageCoder>)coder;

/**
 Remove a coder in the coders array.

 @param coder coder
 */
- (void)removeCoder:(nonnull id<SDWebImageCoder>)coder;

@end



#import "SDWebImageCodersManager.h"
#import "SDWebImageImageIOCoder.h"
#import "SDWebImageGIFCoder.h"
#ifdef SD_WEBP
#import "SDWebImageWebPCoder.h"
#endif
#import "UIImage+MultiFormat.h"

#define LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define UNLOCK(lock) dispatch_semaphore_signal(lock);

@interface SDWebImageCodersManager ()

@property (nonatomic, strong, nonnull) dispatch_semaphore_t codersLock;

@end

@implementation SDWebImageCodersManager

+ (nonnull instancetype)sharedInstance {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        // initialize with default coders
        NSMutableArray<id<SDWebImageCoder>> *mutableCoders = [@[[SDWebImageImageIOCoder sharedCoder]] mutableCopy];
#ifdef SD_WEBP
        [mutableCoders addObject:[SDWebImageWebPCoder sharedCoder]];
#endif
        _coders = [mutableCoders copy];
        _codersLock = dispatch_semaphore_create(1);
    }
    return self;
}

#pragma mark - Coder IO operations

- (void)addCoder:(nonnull id<SDWebImageCoder>)coder { // 添加一个编码器
    if (![coder conformsToProtocol:@protocol(SDWebImageCoder)]) {
        return;
    }
    LOCK(self.codersLock);
    NSMutableArray<id<SDWebImageCoder>> *mutableCoders = [self.coders mutableCopy];
    if (!mutableCoders) {
        mutableCoders = [NSMutableArray array];
    }
    [mutableCoders addObject:coder];
    self.coders = [mutableCoders copy];
    UNLOCK(self.codersLock);
}

- (void)removeCoder:(nonnull id<SDWebImageCoder>)coder {
    if (![coder conformsToProtocol:@protocol(SDWebImageCoder)]) {
        return;
    }
    LOCK(self.codersLock);
    NSMutableArray<id<SDWebImageCoder>> *mutableCoders = [self.coders mutableCopy];
    [mutableCoders removeObject:coder];
    self.coders = [mutableCoders copy];
    UNLOCK(self.codersLock);
}

#pragma mark - SDWebImageCoder
- (BOOL)canDecodeFromData:(NSData *)data {
    LOCK(self.codersLock);
    NSArray<id<SDWebImageCoder>> *coders = self.coders;
    UNLOCK(self.codersLock);
    for (id<SDWebImageCoder> coder in coders.reverseObjectEnumerator) {
        if ([coder canDecodeFromData:data]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)canEncodeToFormat:(SDImageFormat)format { // 通过格式进行解码
    LOCK(self.codersLock);
    NSArray<id<SDWebImageCoder>> *coders = self.coders;
    UNLOCK(self.codersLock);
    for (id<SDWebImageCoder> coder in coders.reverseObjectEnumerator) {
        if ([coder canEncodeToFormat:format]) {
            return YES;
        }
    }
    return NO;
}

- (UIImage *)decodedImageWithData:(NSData *)data { // 通过数据进行解码
    LOCK(self.codersLock);
    NSArray<id<SDWebImageCoder>> *coders = self.coders;
    UNLOCK(self.codersLock);
    for (id<SDWebImageCoder> coder in coders.reverseObjectEnumerator) {
        if ([coder canDecodeFromData:data]) {
            return [coder decodedImageWithData:data];
        }
    }
    return nil;
}

- (UIImage *)decompressedImageWithImage:(UIImage *)image
                                   data:(NSData *__autoreleasing  _Nullable *)data
                                options:(nullable NSDictionary<NSString*, NSObject*>*)optionsDict { // 解压缩解码
    if (!image) {
        return nil;
    }
    LOCK(self.codersLock);
    NSArray<id<SDWebImageCoder>> *coders = self.coders;
    UNLOCK(self.codersLock);
    for (id<SDWebImageCoder> coder in coders.reverseObjectEnumerator) {
        if ([coder canDecodeFromData:*data]) {
            UIImage *decompressedImage = [coder decompressedImageWithImage:image data:data options:optionsDict];
            decompressedImage.sd_imageFormat = image.sd_imageFormat;
            return decompressedImage;
        }
    }
    return nil;
}

- (NSData *)encodedDataWithImage:(UIImage *)image format:(SDImageFormat)format {
    if (!image) {
        return nil;
    }
    LOCK(self.codersLock);
    NSArray<id<SDWebImageCoder>> *coders = self.coders;
    UNLOCK(self.codersLock);
    for (id<SDWebImageCoder> coder in coders.reverseObjectEnumerator) { // 针对倒叙的编码
        if ([coder canEncodeToFormat:format]) {
            return [coder encodedDataWithImage:image format:format];
        }
    }
    return nil;
}

@end

//
//  XNImageLoader.h
//  TestVC
//
//  Created by xn on 2021/12/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XNWebImageLoaderDefine.h"
#import "XNWebImageDefine.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^XNImageLoaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL);
typedef void(^XNImageLoaderCompletedBlock)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished);

#pragma mark - Context Options

FOUNDATION_EXPORT XNWebImageContextOption _Nonnull const XNWebImageContextLoaderCachedImage;

FOUNDATION_EXPORT UIImage * _Nullable XNImageLoaderDecodeImageData(NSData * _Nonnull imageData, NSURL * _Nonnull imageURL, XNWebImageOptions options, XNWebImageContext * _Nullable context);

FOUNDATION_EXPORT UIImage * _Nullable XNImageLoaderDecodeProgressiveImageData(NSData * _Nonnull imageData, NSURL * _Nonnull imageURL, BOOL finished,  id<XNWebImageOperation> _Nonnull operation, XNWebImageOptions options, XNWebImageContext * _Nullable context);

//FOUNDATION_EXPORT id<XNProgressiveImageCoder> _Nullable XNImageLoaderGetProgressiveCoder(id<XNWebImageOperation> _Nonnull operation);
//
//FOUNDATION_EXPORT void XNImageLoaderSetProgressiveCoder(id<XNWebImageOperation> _Nonnull operation, id<XNProgressiveImageCoder> _Nullable progressiveCoder);

#pragma mark - XNImageLoader

/**
 This is the protocol to specify custom image load process. You can create your own class to conform this protocol and use as a image loader to load image from network or any available remote resources defined by yourself.
 If you want to implement custom loader for image download from network or local file, you just need to concentrate on image data download only. After the download finish, call `XNImageLoaderDecodeImageData` or `XNImageLoaderDecodeProgressiveImageData` to use the built-in decoding process and produce image (Remember to call in the global queue). And finally callback the completion block.
 If you directly get the image instance using some third-party SDKs, such as image directly from Photos framework. You can process the image data and image instance by yourself without that built-in decoding process. And finally callback the completion block.
 @note It's your responsibility to load the image in the desired global queue(to avoid block main queue). We do not dispatch these method call in a global queue but just from the call queue (For `XNWebImageManager`, it typically call from the main queue).
*/

@protocol XNImageLoader <NSObject>

@required
- (BOOL)canRequestImageForURL:(nullable NSURL *)url API_DEPRECATED("Use canRequestImageForURL:options:context: instead", macos(10.10, API_TO_BE_DEPRECATED), ios(8.0, API_TO_BE_DEPRECATED), tvos(9.0, API_TO_BE_DEPRECATED), watchos(2.0, API_TO_BE_DEPRECATED));

@optional

- (BOOL)canRequestImageForURL:(NSURL *)url
                      options:(XNWebImageOptions)options
                      context:(nullable XNWebImageContext *)context;

@required
- (nullable id<XNWebImageOperation>)requestImageWithURL:(nullable NSURL *)url
                                                options:(XNWebImageOptions)options
                                                context:(nullable XNWebImageContext *)context
                                               progress:(nullable XNImageLoaderProgressBlock)progressBlock
                                              completed:(nullable XNImageLoaderCompletedBlock)completedBlock;

- (BOOL)shouldBlockFailedURLWithURL:(nonnull NSURL *)url
                              error:(nonnull NSError *)error API_DEPRECATED("Use shouldBlockFailedURLWithURL:error:options:context: instead", macos(10.10, API_TO_BE_DEPRECATED), ios(8.0, API_TO_BE_DEPRECATED), tvos(9.0, API_TO_BE_DEPRECATED), watchos(2.0, API_TO_BE_DEPRECATED));

@optional
- (BOOL)shouldBlockFailedURLWithURL:(nonnull NSURL *)url
                              error:(nonnull NSError *)error
                            options:(XNWebImageOptions)options
                            context:(nullable XNWebImageContext *)context;

@end

@interface XNImageLoader : NSObject


@end

NS_ASSUME_NONNULL_END

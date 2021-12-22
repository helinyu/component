//
//  XNWebImageDownloaderBlockFile.h
//  TestVC
//
//  Created by xn on 2021/12/22.
//

#ifndef XNWebImageDownloaderBlockFile_h
#define XNWebImageDownloaderBlockFile_h
@class UIImage;

typedef void(^XNWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL);

typedef void(^XNWebImageDownloaderCompletedBlock)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished);

typedef NSDictionary<NSString *, NSString *> XNHTTPHeadersDictionary;
typedef NSMutableDictionary<NSString *, NSString *> XNHTTPHeadersMutableDictionary;

typedef XNHTTPHeadersDictionary * _Nullable (^XNWebImageDownloaderHeadersFilterBlock)(NSURL * _Nullable url, XNHTTPHeadersDictionary * _Nullable headers);

#endif /* XNWebImageDownloaderBlockFile_h */

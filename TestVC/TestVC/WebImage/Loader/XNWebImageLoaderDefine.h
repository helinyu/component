//
//  XNWebImageLoaderDefine.h
//  TestVC
//
//  Created by xn on 2021/12/23.
//

#ifndef XNWebImageLoaderDefine_h
#define XNWebImageLoaderDefine_h

@class UIImage;

typedef void(^XNImageLoaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL);
typedef void(^XNImageLoaderCompletedBlock)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished);


#endif /* XNWebImageLoaderDefine_h */

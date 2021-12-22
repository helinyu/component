//
//  SDWebImageDownloadToken.m
//  TestVC
//
//  Created by xn on 2021/12/22.
//

#import "XNWebImageDownloadToken.h"
#import "XNWebImageDownloaderOperationInterface.h"

// 这里面是否需要三个属性？
@interface  XNWebImageDownloadToken ()

@property (nonatomic, weak) NSOperation<XNWebImageDownloaderOperationInterface> *downloadOpoertaion; /// 下载的操作

@end

@implementation XNWebImageDownloadToken

- (void)cancel {
    if (self.downloadOpoertaion) {
        XNWebImageDownloadToken *cancelToken = self.downloadOperationCancelToken;
        if (cancelToken) {
            [self.downloadOpoertaion cancel:cancelToken];
        }
    }
}

@end

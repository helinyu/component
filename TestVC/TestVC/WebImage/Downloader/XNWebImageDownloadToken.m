//
//  SDWebImageDownloadToken.m
//  TestVC
//
//  Created by xn on 2021/12/22.
//

#import "XNWebImageDownloadToken.h"
#import "XNWebImageDownloaderOperation.h"
#import "XNWebImageDownloaderDefine.h"

// 这里面是否需要三个属性？
@interface  XNWebImageDownloadToken ()

@property (nonatomic, strong, nullable, readwrite) NSURL *url;
@property (nonatomic, strong, nullable, readwrite) NSURLRequest *request;
@property (nonatomic, strong, nullable, readwrite) NSURLResponse *response;
@property (nonatomic, strong, nullable, readwrite) NSURLSessionTaskMetrics *metrics API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@property (nonatomic, weak, nullable, readwrite) id downloadOperationCancelToken; // 这个是不是XNWebImageDownloadToken
@property (nonatomic, weak, nullable) NSOperation<XNWebImageDownloaderOperation> *downloadOperation;
@property (nonatomic, assign, getter=isCancelled) BOOL cancelled;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new  NS_UNAVAILABLE;
- (nonnull instancetype)initWithDownloadOperation:(nullable NSOperation<XNWebImageDownloaderOperation> *)downloadOperation;

@end

@implementation XNWebImageDownloadToken

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XNWebImageDownloadReceiveResponseNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XNWebImageDownloadStopNotification object:nil];
}

- (instancetype)initWithDownloadOperation:(NSOperation<XNWebImageDownloaderOperation> *)downloadOperation {
    self = [super init];
    if (self) {
        _downloadOperation = downloadOperation;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDidReceiveResponse:) name:XNWebImageDownloadReceiveResponseNotification object:downloadOperation];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDidStop:) name:XNWebImageDownloadStopNotification object:downloadOperation];
    }
    return self;
}

- (void)downloadDidReceiveResponse:(NSNotification *)notification {
    NSOperation<XNWebImageDownloaderOperation> *downloadOperation = notification.object;
    if (downloadOperation && downloadOperation == self.downloadOperation) {
        self.response = downloadOperation.response;
    }
}

- (void)downloadDidStop:(NSNotification *)notification {
    NSOperation<XNWebImageDownloaderOperation> *downloadOperation = notification.object;
    if (downloadOperation && downloadOperation == self.downloadOperation){
        if ([downloadOperation respondsToSelector:@selector(metrics)]) {
            if (@available(iOS 10.0, *)) {
                self.metrics = downloadOperation.metrics;
            }
        }
    }
}

- (void)cancel {
    @synchronized (self) {
        if (self.isCancelled) {
            return;
        }
        self.cancelled = YES;
        [self.downloadOperation cancel:self.downloadOperationCancelToken];
        self.downloadOperationCancelToken = nil;
    }
}

@end

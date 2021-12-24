//
//  SDWebImageDownloader.m
//  TestVC
//
//  Created by xn on 2021/12/23.
//

#import "XNWebImageDownloader.h"
#import "XNWebImageDownloaderOperation.h"

@interface XNWebImageDownloader ()<NSURLSessionDataDelegate,NSURLSessionTaskDelegate>

@property (nonatomic, strong, nonnull) NSOperationQueue *downloadQueue; // 下载队列
@property (nonatomic, strong, nonnull) NSMutableDictionary<NSURL *, NSOperation<XNWebImageDownloaderOperation> *> *URLOperations; // url的操作

// the session in which data tasks will run
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation XNWebImageDownloader




@end

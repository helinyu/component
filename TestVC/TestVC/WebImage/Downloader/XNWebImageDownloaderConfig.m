//
//  XNWebImageDownloaderConfig.m
//  TestVC
//
//  Created by xn on 2021/12/23.
//

#import "XNWebImageDownloaderConfig.h"

static XNWebImageDownloaderConfig * _defaultDownloaderConfig;


@implementation XNWebImageDownloaderConfig

+ (XNWebImageDownloaderConfig *)defaultDownloaderConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultDownloaderConfig = [XNWebImageDownloaderConfig new];
    });
    return _defaultDownloaderConfig;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maxConcurrentDownloads =  6;
        _downloadTimeout = 15.0;
        _executionOrder = XNWebImageDownloaderFIFOExecutionOrder;
        _acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    XNWebImageDownloaderConfig *config = [[[self class] allocWithZone:zone] init];
    config.maxConcurrentDownloads = self.maxConcurrentDownloads;
    config.downloadTimeout = self.downloadTimeout;
    config.minimumProgressInterval = self.minimumProgressInterval;
    config.sessionConfiguration = [self.sessionConfiguration copyWithZone:zone];
    config.operationClass = self.operationClass;
    config.executionOrder = self.executionOrder;
    config.urlCredential = self.urlCredential;
    config.username = self.username;
    config.password = self.password;
    config.acceptableStatusCodes = self.acceptableStatusCodes;
    config.acceptableContentTypes = self.acceptableContentTypes;
    return config;
}

@end

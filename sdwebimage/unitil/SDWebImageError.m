
FOUNDATION_EXPORT NSErrorDomain const _Nonnull SDWebImageErrorDomain;

/// The HTTP status code for invalid download response (NSNumber *)
FOUNDATION_EXPORT NSErrorUserInfoKey const _Nonnull SDWebImageErrorDownloadStatusCodeKey;

/// SDWebImage error domain and codes
typedef NS_ERROR_ENUM(SDWebImageErrorDomain, SDWebImageError) {
    SDWebImageErrorInvalidURL = 1000, //无效的url
    SDWebImageErrorBadImageData = 1001, //坏的image数据
    SDWebImageErrorCacheNotModified = 1002, // The remote location specify that the cached image is not modified, such as the HTTP response 304 code. It's useful for `SDWebImageRefreshCached`
    SDWebImageErrorBlackListed = 1003, // The URL is blacklisted because of unrecoverable failure marked by downloader (such as 404), you can use `.retryFailed` option to avoid this
    SDWebImageErrorInvalidDownloadOperation = 2000, // The image download operation is invalid, such as nil operation or unexpected error occur when operation initialized
    SDWebImageErrorInvalidDownloadStatusCode = 2001, // The image download response a invalid status code. You can check the status code in error's userInfo under `SDWebImageErrorDownloadStatusCodeKey`
    SDWebImageErrorCancelled = 2002, // The image loading operation is cancelled before finished, during either async disk cache query, or waiting before actual network request. For actual network request error, check `NSURLErrorDomain` error domain and code.
    SDWebImageErrorInvalidDownloadResponse = 2003, // When using response modifier, the modified download response is nil and marked as failed.
};

NSErrorDomain const _Nonnull SDWebImageErrorDomain = @"SDWebImageErrorDomain";
NSErrorUserInfoKey const _Nonnull SDWebImageErrorDownloadStatusCodeKey = @"SDWebImageErrorDownloadStatusCodeKey";


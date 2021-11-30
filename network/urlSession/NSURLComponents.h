// 1） component & queryItem 的内容
// 2）

API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0))
@interface NSURLComponents : NSObject <NSCopying>

- (instancetype)init; // 初始化

//  初始化对象
//  url： 请求url
//  resolve： 决心，决定 https://mlog.club/article/1983750 这个字段的使用

- (nullable instancetype)initWithURL:(NSURL *)url resolvingAgainstBaseURL:(BOOL)resolve;
+ (nullable instancetype)componentsWithURL:(NSURL *)url resolvingAgainstBaseURL:(BOOL)resolve;

//  初始化一个urlcomponent， 这个是一个字符串的内容 ，
- (nullable instancetype)initWithString:(NSString *)URLString;
+ (nullable instancetype)componentsWithString:(NSString *)URLString;


//  返回一个url
@property (nullable, readonly, copy) NSURL *URL;

// 前缀的BaseURL 
- (nullable NSURL *)URLRelativeToURL:(nullable NSURL *)baseURL;

// Returns a URL string created from the NSURLComponents. If the NSURLComponents has an authority component (user, password, host or port) and a path component, then the path must either begin with "/" or be an empty string. If the NSURLComponents does not have an authority component (user, password, host or port) and has a path component, the path component must not start with "//". If those requirements are not met, nil is returned.
//  就是一个字符串， 这个字符串可能是很多情况的内容
@property (nullable, readonly, copy) NSString *string API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));

@property (nullable, copy) NSString *scheme;  // 协议
@property (nullable, copy) NSString *user; // 用户
@property (nullable, copy) NSString *password; // 密码
@property (nullable, copy) NSString *host; // 主机
@property (nullable, copy) NSNumber *port; // 端口 
@property (nullable, copy) NSString *path; // 路径
@property (nullable, copy) NSString *query; //查询参数
@property (nullable, copy) NSString *fragment; // 一个页里面的片断

// Getting these properties retains any percent encoding these components may have. Setting these properties assumes the component string is already correctly percent encoded. Attempting to set an incorrectly percent encoded string will cause an exception. Although ';' is a legal path character, it is recommended that it be percent-encoded for best compatibility with NSURL (-stringByAddingPercentEncodingWithAllowedCharacters: will percent-encode any ';' characters if you pass the URLPathAllowedCharacterSet).
//  其实就是一个百分号的编码
@property (nullable, copy) NSString *percentEncodedUser;
@property (nullable, copy) NSString *percentEncodedPassword;
@property (nullable, copy) NSString *percentEncodedHost;
@property (nullable, copy) NSString *percentEncodedPath;
@property (nullable, copy) NSString *percentEncodedQuery;
@property (nullable, copy) NSString *percentEncodedFragment;


// 对应的内容路径
@property (readonly) NSRange rangeOfScheme API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0));
@property (readonly) NSRange rangeOfUser API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0));
@property (readonly) NSRange rangeOfPassword API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0));
@property (readonly) NSRange rangeOfHost API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0));
@property (readonly) NSRange rangeOfPort API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0));
@property (readonly) NSRange rangeOfPath API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0));
@property (readonly) NSRange rangeOfQuery API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0));
@property (readonly) NSRange rangeOfFragment API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0));

// 查询项 、 对应的百分编码项
@property (nullable, copy) NSArray<NSURLQueryItem *> *queryItems API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
@property (nullable, copy) NSArray<NSURLQueryItem *> *percentEncodedQueryItems API_AVAILABLE(macosx(10.13), ios(11.0), watchos(4.0), tvos(11.0));

@end

//  查询项目
@interface NSURLQueryItem : NSObject <NSSecureCoding, NSCopying> {
@private
    NSString *_name;
    NSString *_value;
}
- (instancetype)initWithName:(NSString *)name value:(nullable NSString *)value NS_DESIGNATED_INITIALIZER;
+ (instancetype)queryItemWithName:(NSString *)name value:(nullable NSString *)value;
@property (readonly) NSString *name;
@property (nullable, readonly) NSString *value;
@end
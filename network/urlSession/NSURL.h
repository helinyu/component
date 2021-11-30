url  上面的内容

@interface NSURL: NSObject <NSSecureCoding, NSCopying>
{
    NSString *_urlString; //连接的字符串
    NSURL *_baseURL; // 基本的url  ，其实就是头部的url， 如果后面的urlString不是http这样的开头，就会拼接在baseurl的后面，如果是，直接用urlString
    void *_clients;
    void *_reserved;
}

#pragra mark - 初始化方法

- (nullable instancetype)initWithScheme:(NSString *)scheme host:(nullable NSString *)host path:(NSString *)path API_DEPRECATED("Use NSURLComponents instead, which lets you create a valid URL with any valid combination of URL components and subcomponents (not just scheme, host and path), and lets you set components and subcomponents with either percent-encoded or un-percent-encoded strings.", macos(10.0,10.11), ios(2.0,9.0), watchos(2.0,2.0), tvos(9.0,9.0)); 
// scheme host path 协议、主机、路径
// 这个不能够用于ipv6的username/password 或者端口。 使用NSURLComponents 处理ipv6
// this call percent-encodes both the host and path, so this cannot be used to set a username/password or port in the hostname part or with a IPv6 '[...]' type address. NSURLComponents handles IPv6 addresses correctly.


// 1）baseUrl 是基本的前面的部分，最基本部分的url </br>
// 2) URLString： 可以理解为urlPath ，会拼接在后面，如果这个值是一个完整的，那么baseUrl将会被置空
+ (nullable instancetype)URLWithString:(NSString *)URLString relativeToURL:(nullable NSURL *)baseURL;




@end


```
        NSURL *baseURL = [NSURL URLWithString:@"http://example.com/v1/"];
//        Now:
        NSURL *url = [NSURL URLWithString:@"foo" relativeToURL:baseURL];
        // Will give us http://example.com/v1/foo
        url =[NSURL URLWithString:@"foo?bar=baz" relativeToURL:baseURL];
        // -> http://example.com/v1/foo?bar=baz
        url =[NSURL URLWithString:@"/foo" relativeToURL:baseURL];
        // -> http://example.com/foo
        url =[NSURL URLWithString:@"foo/" relativeToURL:baseURL];
        // -> http://example.com/v1/foo
        url =[NSURL URLWithString:@"/foo/" relativeToURL:baseURL];
        // -> http://example.com/foo/
        url =[NSURL URLWithString:@"http://example2.com/" relativeToURL:baseURL];
        // -> http://example2.com/
                NSLog(@"url :%@",url);
            这个例子，可以查看一个baseURl的内容

```
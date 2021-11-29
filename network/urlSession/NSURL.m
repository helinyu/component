url  上面的内容

@interface NSURL: NSObject <NSSecureCoding, NSCopying>
{
    NSString *_urlString; //连接的字符串
    NSURL *_baseURL; // 基本的url  ，其实就是头部的url， 如果后面的urlString不是http这样的开头，就会拼接在baseurl的后面，如果是，直接用urlString
    void *_clients;
    void *_reserved;
}

// 1）baseUrl 是基本的前面的部分，最基本部分的url </br>
// 2) URLString： 可以理解为urlPath ，会拼接在后面，如果这个值是一个完整的，那么baseUrl将会被置空
+ (nullable instancetype)URLWithString:(NSString *)URLString relativeToURL:(nullable NSURL *)baseURL;


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
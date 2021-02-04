1、判断链接是否合法 canRequestImageForURL 有新的方法
参数：
    1） SDWebImageOptions webImage缓存的选项 （这里有个问题， 不同的而设置可能会有所不同；  （define 页面定义）
    2）typedef NSDictionary<SDWebImageContextOption, id> SDWebImageContext; 字典类型，可以包括很多，是否可以静心一个model的方式进行定义？ 还是锁，字典里面我们可以自己去定义写东西？感觉还是不要了 可以在模型中增加字典模型； 
    SDWebImageContextOption 是定义的一个字符串类型，字符串的枚举累心 ... 定义的其他内容， 包括的枚举类型需要进一步去定义

2、 - (nullable id<SDWebImageOperation>)requestImageWithURL:(nullable NSURL *)url
options:(SDWebImageOptions)options
context:(nullable SDWebImageContext *)context
progress:(nullable SDImageLoaderProgressBlock)progressBlock
completed:(nullable SDImageLoaderCompletedBlock)completedBlock
请求的接口 
//  前面三个参数是基本的参数类型
//  url: 链接
//  options ： 和上面的类型一样
//  SDWebImageContext 这个也是
//  SDImageLoaderProgressBlock 请求图片的过程的进度的回调
//  SDImageLoaderCompletedBlock 完成之后的回调

想一下： 我们的方法是否可以确定以后就是这么几个参数的么？

- (BOOL)shouldBlockFailedURLWithURL:(nonnull NSURL *)url
                              error:(nonnull NSError *)error API_DEPRECATED("Use shouldBlockFailedURLWithURL:error:options:context: instead", macos(10.10, API_TO_BE_DEPRECATED), ios(8.0, API_TO_BE_DEPRECATED), tvos(9.0, API_TO_BE_DEPRECATED), watchos(2.0, API_TO_BE_DEPRECATED));
- (BOOL)shouldBlockFailedURLWithURL:(nonnull NSURL *)url
                              error:(nonnull NSError *)error
                            options:(SDWebImageOptions)options
                            context:(nullable SDWebImageContext *)context;

//   如果失败了，是否会到， 
//  当然有新的方法了 


所以，这个加载图片的家口基本上是三种欣慰：
1、是否可以请求
2、请求
3、失败了是否回调

SDImageLoaderProgressBlock 进度的回调
SDImageLoaderCompletedBlock 完成的回调
SDImageLoaderDecodeImageData 方法， 通过data 获取的image图像像素
SDImageLoaderDecodeProgressiveImageData 有进度的解码图片


~~~~~~~~~
//  执行下载的类
@protocol SDWebImageOperation <NSObject>

- (void)cancel;

@end

/// NSOperation conform to `SDWebImageOperation`.
@interface NSOperation (SDWebImageOperation) <SDWebImageOperation>

@end

这种写法也是第一次见，  如果我们都引入了这个借口了之后，默认是NSOperation 的cancel， 要有对应的方法，否则写个base类会比较好













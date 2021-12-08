// 启动的时间

t(App 总启动时间) = t1(main()之前的加载时间) + t2(main()之后的加载时间)。
t2 = main函数执行之后到 AppDelegate 类中的applicationDidFinishLaunching:withOptions:方法执行结束前这段时间



// 看看这个过程要不要字节重排这个内容； 


// 第一种方式： 这样有代码污染的问题 ， 并且没有计算t1的时间

CFAbsoluteTime StartTime;

int main(int argc, char * argv[]) {
    @autoreleasepool {
        StartTime = CFAbsoluteTimeGetCurrent();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

extern CFAbsoluteTime StartTime;
 ...
 
// 在 applicationDidFinishLaunching:withOptions: 方法的最后统计
dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"Launched in %f sec", CFAbsoluteTimeGetCurrent() - StartTime);
});

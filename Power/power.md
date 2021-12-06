// 有关电量的处理
https://github.com/aozhimin/iOS-Monitor-Platform/blob/master/iOS-Monitor-Platform_Basic.md

我们先不管越狱的情况，主要看前面两个情况，看看这个东西的处理

```
@property(nonatomic,getter=isBatteryMonitoringEnabled) BOOL batteryMonitoringEnabled API_AVAILABLE(ios(3.0)) API_UNAVAILABLE(tvos);  // default is NO 开启控制电量
@property(nonatomic,readonly) UIDeviceBatteryState          batteryState API_AVAILABLE(ios(3.0)) API_UNAVAILABLE(tvos);  // UIDeviceBatteryStateUnknown if monitoring disabled  电池的住哪个台
@property(nonatomic,readonly) float                         batteryLevel API_AVAILABLE(ios(3.0)) API_UNAVAILABLE(tvos);  // 0 .. 1.0. -1.0 if UIDeviceBatteryStateUnknown  电池的等级


// 电池的两个通知
UIKIT_EXTERN NSNotificationName const UIDeviceBatteryStateDidChangeNotification   API_AVAILABLE(ios(3.0)) API_UNAVAILABLE(tvos);
UIKIT_EXTERN NSNotificationName const UIDeviceBatteryLevelDidChangeNotification   API_AVAILABLE(ios(3.0)) API_UNAVAILABLE(tvos);

```

```
// 非常简单的示例代码
 [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UIDeviceBatteryLevelDidChangeNotification
     object:nil queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *notification) {
        // Level has changed
        NSLog(@"电池电量：%.2f", [UIDevice currentDevice].batteryLevel);
        NSLog(@"battery state:%zd",[UIDevice currentDevice].batteryState);
        NSLog(@"Battery Level Change");
    }];
```

缺点：IOS 8.0 之后，精确度可以达到1%，但这种方案获取到的数据不是很精确，没办法应用到生产环境。 
这个时候直接就获取设备上的电池，我们可以做一个块没有电的时候的弹框。 


```
- (double)getBatteryLevel {
    // returns a blob of power source information in an opaque CFTypeRef
    CFTypeRef blob = IOPSCopyPowerSourcesInfo();
    // returns a CFArray of power source handles, each of type CFTypeRef
    CFArrayRef sources = IOPSCopyPowerSourcesList(blob);
    CFDictionaryRef pSource = NULL;
    const void *psValue;
    // returns the number of values currently in an array
    int numOfSources = CFArrayGetCount(sources);
    // error in CFArrayGetCount
    if (numOfSources == 0) {
        NSLog(@"Error in CFArrayGetCount");
        return -1.0f;
    }

    // calculating the remaining energy
    for (int i=0; i<numOfSources; i++) {
        // returns a CFDictionary with readable information about the specific power source
        pSource = IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(sources, i));
        if (!pSource) {
            NSLog(@"Error in IOPSGetPowerSourceDescription");
            return -1.0f;
        }
        psValue = (CFStringRef) CFDictionaryGetValue(pSource, CFSTR(kIOPSNameKey));

        int curCapacity = 0;
        int maxCapacity = 0;
        double percentage;

        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSCurrentCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &curCapacity);

        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSMaxCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &maxCapacity);

        percentage = ((double) curCapacity / (double) maxCapacity * 100.0f);
        NSLog(@"curCapacity : %d / maxCapacity: %d , percentage: %.1f ", curCapacity, maxCapacity, percentage);
        return percentage;
    }
    return -1.0f;
}                                        
// 准确的获取电量的方式 ， 不过我觉得上面的方法也已经足够了
```
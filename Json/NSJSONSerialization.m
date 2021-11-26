// json读取的类型
typedef NS_OPTIONS(NSUInteger, NSJSONReadingOptions) {
    // 直接填0                         返回的对象是不可变的，NSDictionary或NSArray
   
    NSJSONReadingMutableContainers = (1UL << 0),
    // 返回可变容器，NSMutableDictionary或NSMutableArray，返回的是数组字典嵌套的情况，每一层都是可变的

    NSJSONReadingMutableLeaves = (1UL << 1),
    // 返回的JSON对象中字符串的值类型为NSMutableString

    NSJSONReadingFragmentsAllowed = (1UL << 2),
    // 允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment

    NSJSONReadingJSON5Allowed API_AVAILABLE(macos(12.0), ios(15.0), watchos(8.0), tvos(15.0)) = (1UL << 3),
    //  读取json5的格式

    NSJSONReadingTopLevelDictionaryAssumed API_AVAILABLE(macos(12.0), ios(15.0), watchos(8.0), tvos(15.0)) = (1UL << 4),
    //  顶级水平的字典评估

    NSJSONReadingAllowFragments API_DEPRECATED_WITH_REPLACEMENT("NSJSONReadingFragmentsAllowed", macos(10.7, API_TO_BE_DEPRECATED), ios(5.0, API_TO_BE_DEPRECATED), watchos(2.0, API_TO_BE_DEPRECATED), tvos(9.0, API_TO_BE_DEPRECATED)) = NSJSONReadingFragmentsAllowed,
} API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));


// 1、直接填0                         返回的对象是不可变的，NSDictionary或NSArray
// 2、NSJSONReadingMutableLeaves      返回的JSON对象中字符串的值类型为NSMutableString
// 3、NSJSONReadingMutableContainers  返回可变容器，NSMutableDictionary或NSMutableArray，返回的是数组字典嵌套的情况，每一层都是可变的
// 4、NSJSONReadingAllowFragments     

//  写选项
typedef NS_OPTIONS(NSUInteger, NSJSONWritingOptions) {
    NSJSONWritingPrettyPrinted = (1UL << 0),
    // //使用空白和缩进使输出更具可读性的写入选项。输入时有\n来换行，容易阅读，但是如果与后台交互使用这样，可能会出现问题。

    /* Sorts dictionary keys for output using [NSLocale systemLocale]. Keys are compared using NSNumericSearch. The specific sorting method used is subject to change.
     */
    NSJSONWritingSortedKeys API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0)) = (1UL << 1),
    //按字典顺序对键排序的书写选项。

    NSJSONWritingFragmentsAllowed = (1UL << 2),
    //官方未说明,测试发现，该枚举允许非集合类型的输入，比如单一字符串@“test”,可转换成json字符串。如果使用其他枚举则会崩溃。

    NSJSONWritingWithoutEscapingSlashes API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0)) = (1UL << 3),
    //官方未说明，iOS13新增,应该和斜杠符号有关。
} API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));


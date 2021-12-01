//
//  NetworkMonitor.h
//  NetworkMonitor
//
//  Created by walen on 2019/10/9.
//  Copyright © 2019 CJH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkMonitor : NSObject
/// 资源数据
@property (nonatomic, strong)NSMutableDictionary *dataSource;
/// 接口是否成功
@property (nonatomic, strong)NSMutableDictionary *statusSource;
/// 接口引用计数
@property (nonatomic, strong)NSMutableDictionary *countSource;

/// 创建实例化对象
+ (instancetype)shareInstance;

/// 获取系统时间
+ (CGFloat)getUptimeInMilliseconds;

/// 网速监听
- (void)networkMonitorSpeed:(void(^)(float inStream, float outStream))scheduleBlock;

/// 网络类型监听
- (void)networkTypeMonitor:(void(^)(NSString *networkType))networkTypeBlock;

@end

NS_ASSUME_NONNULL_END

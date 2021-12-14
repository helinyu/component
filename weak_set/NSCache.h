#import <Foundation/NSObject.h>

@class NSString;
@protocol NSCacheDelegate;

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0))
@interface NSCache <KeyType, ObjectType> : NSObject 
@property (copy) NSString *name; // 名字
@property (nullable, assign) id<NSCacheDelegate> delegate; // 代理

- (nullable ObjectType)objectForKey:(KeyType)key; // 对key进行获取obj
- (void)setObject:(ObjectType)obj forKey:(KeyType)key; // 0 cost
- (void)setObject:(ObjectType)obj forKey:(KeyType)key cost:(NSUInteger)g;
- (void)removeObjectForKey:(KeyType)key;

- (void)removeAllObjects;

//  限制都是不精确的
@property NSUInteger totalCostLimit; //内存大小限制  // limits are imprecise/not strict
@property NSUInteger countLimit;	// 数目限制 limits are imprecise/not strict
@property BOOL evictsObjectsWithDiscardedContent; // 内容销毁的额时候就会删除 

@end

//  缓存的代理方法
@protocol NSCacheDelegate <NSObject>
@optional
- (void)cache:(NSCache *)cache willEvictObject:(id)obj;
@end

NS_ASSUME_NONNULL_END


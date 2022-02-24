/*	NSSet.h
	Copyright (c) 1994-2019, Apple Inc. All rights reserved.
*/

#import <Foundation/NSObject.h>
#import <Foundation/NSEnumerator.h>

@class NSArray, NSDictionary, NSString;

/****************	Immutable Set	****************/

NS_ASSUME_NONNULL_BEGIN

@interface NSSet<__covariant ObjectType> : NSObject <NSCopying, NSMutableCopying, NSSecureCoding, NSFastEnumeration>

@property (readonly) NSUInteger count; // 数目
- (nullable ObjectType)member:(ObjectType)object; // 判断这个对象是否在里面main
- (NSEnumerator<ObjectType> *)objectEnumerator; // 枚举器

//  初始化方法
- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithObjects:(const ObjectType _Nonnull [_Nullable])objects count:(NSUInteger)cnt NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@end

@interface NSSet<ObjectType> (NSExtendedSet)

@property (readonly, copy) NSArray<ObjectType> *allObjects; // 所有对象
- (nullable ObjectType)anyObject;  // 返回集合里面的任意一个对象
- (BOOL)containsObject:(ObjectType)anObject; // 是否包括某个对象

@property (readonly, copy) NSString *description; 
- (NSString *)descriptionWithLocale:(nullable id)locale; // 描述

- (BOOL)intersectsSet:(NSSet<ObjectType> *)otherSet; // 交集
- (BOOL)isEqualToSet:(NSSet<ObjectType> *)otherSet; // 是否想灯光
- (BOOL)isSubsetOfSet:(NSSet<ObjectType> *)otherSet; // 是否是自雷

//  遍历
- (void)makeObjectsPerformSelector:(SEL)aSelector NS_SWIFT_UNAVAILABLE("Use enumerateObjectsUsingBlock: or a for loop instead");
- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(nullable id)argument NS_SWIFT_UNAVAILABLE("Use enumerateObjectsUsingBlock: or a for loop instead");
- (void)enumerateObjectsUsingBlock:(void (NS_NOESCAPE ^)(ObjectType obj, BOOL *stop))block API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (NS_NOESCAPE ^)(ObjectType obj, BOOL *stop))block API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

//  NSSet 也是可以太那几的 。 一个对象、set、array , 当时返回了另外一个对象 ， 和下面的mutableset 还是有点不一样的
- (NSSet<ObjectType> *)setByAddingObject:(ObjectType)anObject API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
- (NSSet<ObjectType> *)setByAddingObjectsFromSet:(NSSet<ObjectType> *)other API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
- (NSSet<ObjectType> *)setByAddingObjectsFromArray:(NSArray<ObjectType> *)other API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));

//  通过判断，过滤掉集合中的一些结点 1、 是正序还是反序过滤  2、过滤的判断
- (NSSet<ObjectType> *)objectsPassingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, BOOL *stop))predicate API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
- (NSSet<ObjectType> *)objectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, BOOL *stop))predicate API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

@end

@interface NSSet<ObjectType> (NSSetCreation)

//  创建初始化的遍历方法
+ (instancetype)set;
+ (instancetype)setWithObject:(ObjectType)object;
+ (instancetype)setWithObjects:(const ObjectType _Nonnull [_Nonnull])objects count:(NSUInteger)cnt;
+ (instancetype)setWithObjects:(ObjectType)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
+ (instancetype)setWithSet:(NSSet<ObjectType> *)set;
+ (instancetype)setWithArray:(NSArray<ObjectType> *)array;

- (instancetype)initWithObjects:(ObjectType)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype)initWithSet:(NSSet<ObjectType> *)set;
- (instancetype)initWithSet:(NSSet<ObjectType> *)set copyItems:(BOOL)flag;
- (instancetype)initWithArray:(NSArray<ObjectType> *)array;

@end

/****************	Mutable Set	****************/

//  可变的结合方式

@interface NSMutableSet<ObjectType> : NSSet<ObjectType>

- (void)addObject:(ObjectType)object; // 添加 元素
- (void)removeObject:(ObjectType)object; // 删除 元素
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCapacity:(NSUInteger)numItems NS_DESIGNATED_INITIALIZER; // 数目

@end

@interface NSMutableSet<ObjectType> (NSExtendedMutableSet)

- (void)addObjectsFromArray:(NSArray<ObjectType> *)array; // 添加通过数组
- (void)intersectSet:(NSSet<ObjectType> *)otherSet; // 交集
- (void)minusSet:(NSSet<ObjectType> *)otherSet; // 减集
- (void)removeAllObjects; // 删除
- (void)unionSet:(NSSet<ObjectType> *)otherSet; // 并集

- (void)setSet:(NSSet<ObjectType> *)otherSet; // 里面的元素设置为otherSet的元素

@end

@interface NSMutableSet<ObjectType> (NSMutableSetCreation)

+ (instancetype)setWithCapacity:(NSUInteger)numItems;

@end

/****************	Counted Set	****************/

//  继承可变集合
//  记录一个相同元素里面有多少个个
//  如果一个对象加一次，那么数据数目就+1， 减少一次对象，那么么就-1 
@interface NSCountedSet<ObjectType> : NSMutableSet<ObjectType> {
    @private
    id _table;
    void *_reserved;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems NS_DESIGNATED_INITIALIZER; // 数目

- (instancetype)initWithArray:(NSArray<ObjectType> *)array; // 通过数组
- (instancetype)initWithSet:(NSSet<ObjectType> *)set; // 通过一般集合

- (NSUInteger)countForObject:(ObjectType)object; // 某个元素的对象

- (NSEnumerator<ObjectType> *)objectEnumerator; // 枚举器
- (void)addObject:(ObjectType)object; // 添加元素
- (void)removeObject:(ObjectType)object; // 删除元素

@end

NS_ASSUME_NONNULL_END

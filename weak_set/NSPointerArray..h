https://www.jianshu.com/p/08aef68891a6 几个表示空区别

/*
 *  NSPointerArray.h
 *  Copyright (c) 2005-2019, Apple Inc. All rights reserved.
 *
 */
 

#import <Foundation/NSObject.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSPointerFunctions.h>

NS_ASSUME_NONNULL_BEGIN

//  可以配置为弱引用的类型， 

/*
   NSPointerArray.h

   A PointerArray acts like a traditional array that slides elements on insertion or deletion.
   Unlike traditional arrays, it holds NULLs, which can be inserted or extracted (and contribute to count).
   Also unlike traditional arrays, the 'count' of the array may be set directly.
   Using NSPointerFunctionsWeakMemory object references will turn to NULL on last release.

   The copying and archiving protocols are applicable only when NSPointerArray is configured for Object uses.
   The fast enumeration protocol (supporting the for..in statement) will yield NULLs if present.  It is defined for all types of pointers although the language syntax doesn't directly support this.
*/

API_AVAILABLE(macos(10.5), ios(6.0), watchos(2.0), tvos(9.0))
@interface NSPointerArray : NSObject <NSFastEnumeration, NSCopying, NSSecureCoding>
// construction
- (instancetype)initWithOptions:(NSPointerFunctionsOptions)options NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithPointerFunctions:(NSPointerFunctions *)functions NS_DESIGNATED_INITIALIZER;

+ (NSPointerArray *)pointerArrayWithOptions:(NSPointerFunctionsOptions)options;
+ (NSPointerArray *)pointerArrayWithPointerFunctions:(NSPointerFunctions *)functions;

/* return an NSPointerFunctions object reflecting the functions in use.  This is a new autoreleased object that can be subsequently modified and/or used directly in the creation of other pointer "collections". */
@property (readonly, copy) NSPointerFunctions *pointerFunctions;

- (nullable void *)pointerAtIndex:(NSUInteger)index;

// Array like operations that slide or grow contents, including NULLs
- (void)addPointer:(nullable void *)pointer;  // add pointer at index 'count'
- (void)removePointerAtIndex:(NSUInteger)index;    // everything above index, including holes, slide lower
- (void)insertPointer:(nullable void *)item atIndex:(NSUInteger)index;  // everything at & above index, including holes, slide higher
- (void)replacePointerAtIndex:(NSUInteger)index withPointer:(nullable void *)item;  // O(1); NULL item is okay; index must be < count

- (void)compact;   // eliminate NULLs ， 这个使用的的时候注意事项， 添加了NULL之后再执行，才可以去掉里面的NULL

// Getter: the number of elements in the array, including NULLs
// Setter: sets desired number of elements, adding NULLs or removing items as necessary.
@property NSUInteger count;

@end


@interface NSPointerArray (NSPointerArrayConveniences)  

+ (NSPointerArray *)strongObjectsPointerArray API_AVAILABLE(macos(10.8), ios(6.0), watchos(2.0), tvos(9.0));
+ (NSPointerArray *)weakObjectsPointerArray API_AVAILABLE(macos(10.8), ios(6.0), watchos(2.0), tvos(9.0));
@property (readonly, copy) NSArray *allObjects;

@end

NS_ASSUME_NONNULL_END

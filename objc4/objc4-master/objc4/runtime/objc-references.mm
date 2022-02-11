/*
 * Copyright (c) 2004-2007 Apple Inc. All rights reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 * 
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 * 
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 * 
 * @APPLE_LICENSE_HEADER_END@
 */
/*
  Implementation of the weak / associative references for non-GC mode.
*/


#include "objc-private.h"
#include <objc/message.h>
#include <map>
#include "DenseMapExtras.h"

// expanded policy bits.

// 集中关联的设置和获取的枚举类型
enum {
    OBJC_ASSOCIATION_SETTER_ASSIGN      = 0,
    OBJC_ASSOCIATION_SETTER_RETAIN      = 1,
    OBJC_ASSOCIATION_SETTER_COPY        = 3,            // NOTE:  both bits are set, so we can simply test 1 bit in releaseValue below.
    OBJC_ASSOCIATION_GETTER_READ        = (0 << 8),
    OBJC_ASSOCIATION_GETTER_RETAIN      = (1 << 8),
    OBJC_ASSOCIATION_GETTER_AUTORELEASE = (2 << 8),
    OBJC_ASSOCIATION_SYSTEM_OBJECT      = _OBJC_ASSOCIATION_SYSTEM_OBJECT, // 1 << 16
};

spinlock_t AssociationsManagerLock; // 这个自旋锁 ， 到时候应该是会去掉的

namespace objc {

// objc 关联类：策略 + 值 的处理。
class ObjcAssociation {
    uintptr_t _policy; // 策略
    id _value; // 值
public:
    ObjcAssociation(uintptr_t policy, id value) : _policy(policy), _value(value) {}
    ObjcAssociation() : _policy(0), _value(nil) {}
    ObjcAssociation(const ObjcAssociation &other) = default;
    ObjcAssociation &operator=(const ObjcAssociation &other) = default;
    ObjcAssociation(ObjcAssociation &&other) : ObjcAssociation() {
        swap(other);
    }

    inline void swap(ObjcAssociation &other) { // 交换关联对象： 测录和值的交换
        std::swap(_policy, other._policy);
        std::swap(_value, other._value);
    }

    inline uintptr_t policy() const { return _policy; }
    inline id value() const { return _value; }

    inline void acquireValue() { // 获取值
        if (_value) {
            switch (_policy & 0xFF) {
            case OBJC_ASSOCIATION_SETTER_RETAIN: // 设置的处理，执行设置的操作
                _value = objc_retain(_value);
                break;
            case OBJC_ASSOCIATION_SETTER_COPY: // 拷贝的处理，执行拷贝操作
                _value = ((id(*)(id, SEL))objc_msgSend)(_value, @selector(copy));
                break;
            }
        }
    }

    inline void releaseHeldValue() { // 释放持有的值
        if (_value && (_policy & OBJC_ASSOCIATION_SETTER_RETAIN)) {
            objc_release(_value);
        }
    }

    inline void retainReturnedValue() { // 持有的值引用计数处理
        if (_value && (_policy & OBJC_ASSOCIATION_GETTER_RETAIN)) {
            objc_retain(_value);
        }
    }

    inline id autoreleaseReturnedValue() { // 自动释放处理
        if (slowpath(_value && (_policy & OBJC_ASSOCIATION_GETTER_AUTORELEASE))) { // 也就是这个现在一般咩咩有这个的判断
            return objc_autorelease(_value);
        }
        return _value;
    }
};

typedef DenseMap<const void *, ObjcAssociation> ObjectAssociationMap;
typedef DenseMap<DisguisedPtr<objc_object>, ObjectAssociationMap> AssociationsHashMap;

// class AssociationsManager manages a lock / hash table singleton pair.
// Allocating an instance acquires the lock
// 关联的管理对象
// 初始化存储
class AssociationsManager {
    using Storage = ExplicitInitDenseMap<DisguisedPtr<objc_object>, ObjectAssociationMap>;
    // 一看这个就是一个数组的内容 ， 稠密映射
    // 定义了类型： key：map ， 要看一下这个map是如何存储的
    static Storage _mapStorage; // 存储的映射

public:
    AssociationsManager()   { AssociationsManagerLock.lock(); } // 锁
    ~AssociationsManager()  { AssociationsManagerLock.unlock(); } // 解锁

    AssociationsHashMap &get() { // 获取对应的hashmap的内容
        return _mapStorage.get();
    }

    static void init() {
        _mapStorage.init(); // 初始化这个map
    }
};

AssociationsManager::Storage AssociationsManager::_mapStorage;

} // namespace objc

using namespace objc;

void
_objc_associations_init()
{
    AssociationsManager::init();
}


// 查找到有关的关联对象
id
_object_get_associative_reference(id object, const void *key)
{
    ObjcAssociation association{};

    {
        AssociationsManager manager;
        AssociationsHashMap &associations(manager.get());
        AssociationsHashMap::iterator i = associations.find((objc_object *)object);
        if (i != associations.end()) {
            ObjectAssociationMap &refs = i->second;
            ObjectAssociationMap::iterator j = refs.find(key);
            if (j != refs.end()) {
                association = j->second;
                association.retainReturnedValue();
            }
        }
    }

    return association.autoreleaseReturnedValue();
}

void
_object_set_associative_reference(id object, const void *key, id value, uintptr_t policy)
{
    // This code used to work when nil was passed for object and key. Some code
    // probably relies on that to not crash. Check and handle it explicitly.
    // rdar://problem/44094390
    if (!object && !value) return; // 关联对象和值都不存在的时候

    if (object->getIsa()->forbidsAssociatedObjects()) // 判断对象是否禁止关联
        _objc_fatal("objc_setAssociatedObject called on instance (%p) of class %s which does not allow associated objects", object, object_getClassName(object));

    DisguisedPtr<objc_object> disguised{(objc_object *)object}; // 指针封装
    ObjcAssociation association{policy, value}; // objc关联 —— oc的关联对象（策略 + 值）

    // retain the new value (if any) outside the lock.
    association.acquireValue(); // 处理对应的引用计数还是拷贝

    bool isFirstAssociation = false;
    {
        AssociationsManager manager; // 声明一个对象
        AssociationsHashMap &associations(manager.get()); // hashmap

        if (value) { // 如果值存在
            auto refs_result = associations.try_emplace(disguised, ObjectAssociationMap{});
            if (refs_result.second) {
                /* it's the first association we make */
                isFirstAssociation = true;
            }

            /* establish or replace the association */
            auto &refs = refs_result.first->second;
            auto result = refs.try_emplace(key, std::move(association));
            if (!result.second) {
                association.swap(result.first->second);
            }
        } else {
//             如果值不存在，就是擦除这个key的内容
            auto refs_it = associations.find(disguised);
            if (refs_it != associations.end()) {
                auto &refs = refs_it->second;
                auto it = refs.find(key);
                if (it != refs.end()) {
                    association.swap(it->second);
                    refs.erase(it);
                    if (refs.size() == 0) {
                        associations.erase(refs_it);
                    }
                }
            }
        }
    }

    // Call setHasAssociatedObjects outside the lock, since this
    // will call the object's _noteAssociatedObjects method if it
    // has one, and this may trigger +initialize which might do
    // arbitrary stuff, including setting more associated objects.
    if (isFirstAssociation)
        object->setHasAssociatedObjects(); // 设置有关的关联对象

    // release the old value (outside of the lock).
    association.releaseHeldValue(); // 释放持有的旧值
}

// Unlike setting/getting an associated reference,
// this function is performance sensitive because of
// raw isa objects (such as OS Objects) that can't track
// whether they have associated objects.

// 移除一个个对象的所有关联
void
_object_remove_assocations(id object, bool deallocating)
{
    ObjectAssociationMap refs{}; // 有关的关联映射

    {
        AssociationsManager manager;
        AssociationsHashMap &associations(manager.get());
        AssociationsHashMap::iterator i = associations.find((objc_object *)object);
        if (i != associations.end()) {
            refs.swap(i->second);

            // If we are not deallocating, then SYSTEM_OBJECT associations are preserved.
            bool didReInsert = false;
            if (!deallocating) {
                for (auto &ref: refs) {
                    if (ref.second.policy() & OBJC_ASSOCIATION_SYSTEM_OBJECT) {
                        i->second.insert(ref);
                        didReInsert = true;
                    }
                }
            }
            if (!didReInsert)
                associations.erase(i);
        }
    }

    // Associations to be released after the normal ones.
    SmallVector<ObjcAssociation *, 4> laterRefs;

    // release everything (outside of the lock).
    for (auto &i: refs) {
        if (i.second.policy() & OBJC_ASSOCIATION_SYSTEM_OBJECT) {
            // If we are not deallocating, then RELEASE_LATER associations don't get released.
            if (deallocating)
                laterRefs.append(&i.second);
        } else {
            i.second.releaseHeldValue();
        }
    }
    for (auto *later: laterRefs) {
        later->releaseHeldValue(); // 有关的内容处理过程
    }
}

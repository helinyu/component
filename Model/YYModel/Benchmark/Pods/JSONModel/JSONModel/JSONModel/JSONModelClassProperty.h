//
//  JSONModelClassProperty.h
//  JSONModel
//

#import <Foundation/Foundation.h>

/**
 * **You do not need to instantiate this class yourself.** This class is used internally by JSONModel
 * to inspect the declared properties of your model class.
 *
 * Class to contain the information, representing a class property
 * It features the property's name, type, whether it's a required property,
 * and (optionally) the class protocol
 */
// 属性的有关内容
@interface JSONModelClassProperty : NSObject

// deprecated
@property (assign, nonatomic) BOOL isIndex DEPRECATED_ATTRIBUTE;

/** The name of the declared property (not the ivar name) */
@property (copy, nonatomic) NSString *name; // 名字

/** A property class type  */
@property (assign, nonatomic) Class type; // 类型

/** Struct name if a struct */
@property (strong, nonatomic) NSString *structName; // 结构名字

/** The name of the protocol the property conforms to (or nil) */
@property (copy, nonatomic) NSString *protocol; // 接口

/** If YES, it can be missing in the input data, and the input would be still valid */
@property (assign, nonatomic) BOOL isOptional; // 是否可选

/** If YES - don't call any transformers on this property's value */
@property (assign, nonatomic) BOOL isStandardJSONType; //  是否是标签的json类型

/** If YES - create a mutable object for the value of the property */
@property (assign, nonatomic) BOOL isMutable; // 是否可变的属性

/** a custom getter for this property, found in the owning model */
@property (assign, nonatomic) SEL customGetter; // 自定义设置

/** custom setters for this property, found in the owning model */
@property (strong, nonatomic) NSMutableDictionary *customSetters; // 自定义设置的

@end

//
//  Copyright (c) 2014-2016 Apple Inc. All rights reserved.
//

#import <XCTest/XCTestDefines.h>

#if XCT_UI_TESTING_AVAILABLE

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#import <XCTest/XCUIElementAttributes.h>
#import <XCTest/XCUIElementTypeQueryProvider.h>
#import <XCTest/XCUIKeyboardKeys.h>
#import <XCTest/XCUIScreenshotProviding.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, XCUIKeyModifierFlags) {
    XCUIKeyModifierNone       = 0,
    XCUIKeyModifierCapsLock   = (1UL << 0),
    XCUIKeyModifierShift      = (1UL << 1),
    XCUIKeyModifierControl    = (1UL << 2),
    XCUIKeyModifierOption     = (1UL << 3),
    XCUIKeyModifierCommand    = (1UL << 4),
    XCUIKeyModifierFunction   = (1UL << 5),
    
    // These values align with UIKeyModifierFlags and CGEventFlags.
    XCUIKeyModifierAlphaShift = XCUIKeyModifierCapsLock,
    XCUIKeyModifierAlternate  = XCUIKeyModifierOption,
};

typedef CGFloat XCUIGestureVelocity NS_TYPED_EXTENSIBLE_ENUM;
XCT_EXPORT XCUIGestureVelocity const XCUIGestureVelocityDefault;
XCT_EXPORT XCUIGestureVelocity const XCUIGestureVelocitySlow;
XCT_EXPORT XCUIGestureVelocity const XCUIGestureVelocityFast;

@class XCUIElementQuery;
@class XCUICoordinate;

@interface XCUIElement : NSObject <XCUIElementAttributes, XCUIElementTypeQueryProvider>

+ (instancetype)new XCT_UNAVAILABLE("Use XCUIElementQuery to create XCUIElement instances.");
- (instancetype)init XCT_UNAVAILABLE("Use XCUIElementQuery to create XCUIElement instances.");

//  空间是否存在
@property (readonly) BOOL exists;

//  等待时间存在
- (BOOL)waitForExistenceWithTimeout:(NSTimeInterval)timeout XCT_WARN_UNUSED;

//  是否实现了事件的实现
@property (readonly, getter = isHittable) BOOL hittable;

//  获取父元素
- (XCUIElementQuery *)descendantsMatchingType:(XCUIElementType)type;

//  获取子元素
- (XCUIElementQuery *)childrenMatchingType:(XCUIElementType)type;

#if !TARGET_OS_TV
/*! Creates and returns a new coordinate that will compute its screen point by adding the offset multiplied by the size of the element’s frame to the origin of the element’s frame. */
- (XCUICoordinate *)coordinateWithNormalizedOffset:(CGVector)normalizedOffset;
#endif

/*!
 @discussion
 Provides debugging information about the element. The data in the string will vary based on the
 time at which it is captured, but it may include any of the following as well as additional data:
    • Values for the elements attributes.
    • The entire tree of descendants rooted at the element.
    • The element's query.
 This data should be used for debugging only - depending on any of the data as part of a test is unsupported.
 */
@property (readonly, copy) NSString *debugDescription;

@end

@interface XCUIElement (XCUIScreenshotProviding) <XCUIScreenshotProviding>
@end

#pragma mark - Event Synthesis


@interface XCUIElement (XCUIElementKeyboardEvents)

/*!
 * Types a string into the element. The element or a descendant must have keyboard focus; otherwise an
 * error is raised.
 *
 * This API discards any modifiers set in the current context by +performWithKeyModifiers:block: so that
 * it strictly interprets the provided text. To input keys with modifier flags, use  -typeKey:modifierFlags:.
 */
// 
- (void)typeText:(NSString *)text;

#if TARGET_OS_OSX || TARGET_OS_MACCATALYST

/*!
 * Hold modifier keys while the given block runs. This method pushes and pops the modifiers as global state
 * without need for reference to a particular element. Inside the block, elements can be clicked on, dragged
 * from, typed into, etc.
 */
+ (void)performWithKeyModifiers:(XCUIKeyModifierFlags)flags block:(XCT_NOESCAPE void (^)(void))block;

/*!
 * Types a single key with the specified modifier flags. Although `key` is a string, it must represent
 * a single key on a physical keyboard; strings that resolve to multiple keys will raise an error at runtime.
 * In addition to literal string key representations like "a", "6", and "[", keys such as the arrow keys,
 * command, control, option, and function keys can be typed using constants defined for them in XCUIKeyboardKeys.h
 */
- (void)typeKey:(NSString *)key modifierFlags:(XCUIKeyModifierFlags)flags;

#endif // TARGET_OS_OSX || TARGET_OS_MACCATALYST

@end

@interface XCUIElement (XCUIElementTouchEvents)

//  元素的实践
- (void)tap API_UNAVAILABLE(tvos);

/*!
 * Sends a double tap event to a hittable point computed for the element.
 */
- (void)doubleTap API_UNAVAILABLE(tvos);

/*!
 * Sends a long press gesture to a hittable point computed for the element, holding for the specified duration.
 *
 * @param duration
 * Duration in seconds.
 */
- (void)pressForDuration:(NSTimeInterval)duration API_UNAVAILABLE(tvos);

/*!
 * Initiates a press-and-hold gesture that then drags to another element, suitable for table cell reordering and similar operations.
 * @param duration
 * Duration of the initial press-and-hold.
 * @param otherElement
 * The element to finish the drag gesture over. In the example of table cell reordering, this would be the reorder element of the destination row.
 */
- (void)pressForDuration:(NSTimeInterval)duration thenDragToElement:(XCUIElement *)otherElement API_UNAVAILABLE(tvos);

/*!
* Initiates a press-and-hold gesture that then drags to another element with a custom velocity and then holds, suitable for table cell reordering and similar operations.
* @param duration
* Duration of the initial press-and-hold.
* @param otherElement
* The element to finish the drag gesture over. In the example of table cell reordering, this would be the reorder element of the destination row.
* @param velocity
* The velocity pixels per second at which to drag the element.
* @param holdDuration
* The duration of the final hold.
*/
- (void)pressForDuration:(NSTimeInterval)duration thenDragToElement:(XCUIElement *)otherElement withVelocity:(XCUIGestureVelocity)velocity thenHoldForDuration:(NSTimeInterval)holdDuration API_UNAVAILABLE(tvos);

#if (TARGET_OS_IOS || TARGET_OS_WATCH) && !TARGET_OS_MACCATALYST

/*!
 * Sends a two finger tap event to a hittable point computed for the element.
 */
- (void)twoFingerTap;

/*!
 * Sends one or more taps with one or more touch points.
 *
 * @param numberOfTaps
 * The number of taps.
 *
 * @param numberOfTouches
 * The number of touch points.
 */
- (void)tapWithNumberOfTaps:(NSUInteger)numberOfTaps numberOfTouches:(NSUInteger)numberOfTouches;

/*!
 * Sends a swipe-up gesture.
 */
- (void)swipeUp;

/*!
 * Sends a swipe-down gesture.
 */
- (void)swipeDown;

/*!
 * Sends a swipe-left gesture.
 */
- (void)swipeLeft;

/*!
 * Sends a swipe-right gesture.
 */
- (void)swipeRight;

/*!
 * Sends a swipe in the specified direction with a specified velocity.
 * @param velocity
 * The velocity pixels per second at which to perform the swipe at.
*/
- (void)swipeUpWithVelocity:(XCUIGestureVelocity)velocity;
- (void)swipeDownWithVelocity:(XCUIGestureVelocity)velocity;
- (void)swipeLeftWithVelocity:(XCUIGestureVelocity)velocity;
- (void)swipeRightWithVelocity:(XCUIGestureVelocity)velocity;

/*!
 * Sends a pinching gesture with two touches.
 *
 * The system makes a best effort to synthesize the requested scale and velocity: absolute accuracy is not guaranteed.
 * Some values may not be possible based on the size of the element's frame - these will result in test failures.
 *
 * @param scale
 * The scale of the pinch gesture.  Use a scale between 0 and 1 to "pinch close" or zoom out and a scale greater than 1 to "pinch open" or zoom in.
 *
 * @param velocity
 * The velocity of the pinch in scale factor per second.
 */
- (void)pinchWithScale:(CGFloat)scale velocity:(CGFloat)velocity;

/*!
 * Sends a rotation gesture with two touches.
 *
 * The system makes a best effort to synthesize the requested rotation and velocity: absolute accuracy is not guaranteed.
 * Some values may not be possible based on the size of the element's frame - these will result in test failures.
 *
 * @param rotation
 * The rotation of the gesture in radians.
 *
 * @param velocity
 * The velocity of the rotation gesture in radians per second.
 */
- (void)rotate:(CGFloat)rotation withVelocity:(CGFloat)velocity;

#endif // (TARGET_OS_IOS || TARGET_OS_WATCH) && !TARGET_OS_MACCATALYST

@end


#if TARGET_OS_OSX || TARGET_OS_MACCATALYST

@interface XCUIElement (XCUIElementMouseEvents)

/*!
 * Moves the cursor over the element.
 */
- (void)hover;

/*!
 * Sends a click event to a hittable point computed for the element.
 */
- (void)click;

/*!
 * Sends a double click event to a hittable point computed for the element.
 */
- (void)doubleClick;

/*!
 * Sends a right click event to a hittable point computed for the element.
 */
- (void)rightClick;

/*!
 * Clicks and holds for a specified duration (generally long enough to start a drag operation) then drags
 * to the other element.
 */
- (void)clickForDuration:(NSTimeInterval)duration thenDragToElement:(XCUIElement *)otherElement;

/*!
* Initiates a click-and-hold gesture that then drags to another element with a custom velocity and then holds, suitable for table cell reordering and similar operations.
* @param duration
* Duration of the initial click-and-hold.
* @param otherElement
* The element to finish the drag gesture over. In the example of table cell reordering, this would be the reorder element of the destination row.
* @param velocity
* The velocity pixels per second at which to drag the element.
* @param holdDuration
* The duration of the final hold.
*/
- (void)clickForDuration:(NSTimeInterval)duration thenDragToElement:(XCUIElement *)otherElement withVelocity:(XCUIGestureVelocity)velocity thenHoldForDuration:(NSTimeInterval)holdDuration;

/*!
 * Scroll the view the specified pixels, x and y.
 */
//  移动的距离， 这个需要进一步去查看有关 scrollView上的内容
- (void)scrollByDeltaX:(CGFloat)deltaX deltaY:(CGFloat)deltaY;

@end

#endif // TARGET_OS_OSX || TARGET_OS_MACCATALYST

/*! This category on XCUIElement provides functionality for automating UISlider and NSSlider. */
@interface XCUIElement (XCUIElementTypeSlider)

/*! Manipulates the UI to change the displayed value of the slider to one based on a normalized position. 0 corresponds to the minimum value of the slider, 1 corresponds to its maximum value. The adjustment is a "best effort" to move the indicator to the desired position; absolute fidelity is not guaranteed. */
- (void)adjustToNormalizedSliderPosition:(CGFloat)normalizedSliderPosition;

/*! Returns the position of the slider's indicator as a normalized value where 0 corresponds to the minimum value of the slider and 1 corresponds to its maximum value. */
@property (readonly) CGFloat normalizedSliderPosition;

@end

#if TARGET_OS_IOS

/*! This category on XCUIElement provides functionality for automating the picker wheels of UIPickerViews and UIDatePickers. */
@interface XCUIElement (XCUIElementTypePickerWheel)

/*! Changes the displayed value for the picker wheel. Will generate a test failure if the specified value is not available. */
- (void)adjustToPickerWheelValue:(NSString *)pickerWheelValue;

@end

#endif // TARGET_OS_IOS

@protocol XCUIElementSnapshot <XCUIElementAttributes>

@property (readonly) NSArray<id<XCUIElementSnapshot>> *children;

/*!
 * Returns a hierarchical dictionary representation with standard attributes for the element and all
 * of its descendants. The dictionary keys are of type XCUIElementAttributeName. If the value for a given
 * attribute is null, the key will not be present, but empty strings may be found in the dictionary.
 */
@property (readonly, copy) NSDictionary<XCUIElementAttributeName, id> *dictionaryRepresentation;

@end

@protocol XCUIElementSnapshotProviding <NSObject>

/*!
 * Returns a hierarchical data structure with standard attributes for the element and its children.
 */
- (nullable id<XCUIElementSnapshot>)snapshotWithError:(NSError **)outError;

@end

@interface XCUIElement (XCUIElementSnapshotProviding) <XCUIElementSnapshotProviding>
@end

NS_ASSUME_NONNULL_END

#endif

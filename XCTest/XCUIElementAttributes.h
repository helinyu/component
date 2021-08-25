typedef NS_ENUM(NSInteger, XCUIUserInterfaceSizeClass) {
    XCUIUserInterfaceSizeClassUnspecified = 0,
    XCUIUserInterfaceSizeClassCompact     = 1,
    XCUIUserInterfaceSizeClassRegular     = 2,
};

#else

#import <AppKit/AppKit.h>

typedef NS_ENUM(NSInteger, XCUIUserInterfaceSizeClass) {
    XCUIUserInterfaceSizeClassUnspecified = 0,
};

#endif

NS_ASSUME_NONNULL_BEGIN

// 接口描述舒心暴露在用户及哦啊胡元素和查询匹配是有用的
// 这些属性代表数据暴露在可访问系统中
@protocol XCUIElementAttributes  // 元素属性
@property (readonly) NSString *identifier; // 唯一标识
@property (readonly) CGRect frame; 
@property (readonly, nullable) id value; // 元素的最原始的值
@property (readonly, copy) NSString *title; // 标题
@property (readonly, copy) NSString *label; // 标签
@property (readonly) XCUIElementType elementType; // 元素的类型
@property (readonly, getter = isEnabled) BOOL enabled; // 元素是用户可操作性的
@property (readonly) XCUIUserInterfaceSizeClass horizontalSizeClass; //元素类的水平大小
@property (readonly) XCUIUserInterfaceSizeClass verticalSizeClass; // 元素列的垂直大小
@property (readonly, nullable) NSString *placeholderValue; // 占位值
@property (readonly, getter = isSelected) BOOL selected; // 元素是否选择

#if !TARGET_OS_OSX
@property (readonly) BOOL hasFocus; // 是否已经焦聚
#endif

@end

/*!
 * @enum Constants for use with APIs that accept or return objects with element attributes specified,
 * such as the dictionaries returned by XCUIElement.dictionaryRepresentation.
 */
typedef NSString * XCUIElementAttributeName NS_TYPED_ENUM;

XCT_EXPORT XCUIElementAttributeName const XCUIElementAttributeNameChildren; // 元素的孩子【数组】
XCT_EXPORT XCUIElementAttributeName const XCUIElementAttributeNameElementType; // 元素类型，number包裹
XCT_EXPORT XCUIElementAttributeName const XCUIElementAttributeNameIdentifier; // 元素的可访问标识
XCT_EXPORT XCUIElementAttributeName const XCUIElementAttributeNameValue; // 元素的可访问值， 一个字符串或者数字
XCT_EXPORT XCUIElementAttributeName const XCUIElementAttributeNamePlaceholderValue; // 元素的占位值
XCT_EXPORT XCUIElementAttributeName const XCUIElementAttributeNameTitle; // 元素的标题
XCT_EXPORT XCUIElementAttributeName const XCUIElementAttributeNameLabel; // 元素的标签
/// A dictionary representation of the element's frame, as returned by CGRectCreateDictionaryRepresentation.
XCT_EXPORT XCUIElementAttributeName const XCUIElementAttributeNameFrame; // CGRectCreateDictionaryRepresentation返回的，一个字典代表元素的frame
/// True if the element is enabled, false otherwise, an NSNumber-wrapped BOOL.
XCT_EXPORT XCUIElementAttributeName const XCUIElementAttributeNameEnabled;
/// True if the element is selected, false otherwise, an NSNumber-wrapped BOOL.
XCT_EXPORT XCUIElementAttributeName const XCUIElementAttributeNameSelected;
/// True if the element is focused, false otherwise, an NSNumber-wrapped BOOL.
XCT_EXPORT XCUIElementAttributeName const XCUIElementAttributeNameHasFocus;
/// The element's horizontal size class, an NSNumber-wrapped XCUIUserInterfaceSizeClass.
XCT_EXPORT XCUIElementAttributeName const XCUIElementAttributeNameHorizontalSizeClass;
/// The element's vertical size class, an NSNumber-wrapped XCUIUserInterfaceSizeClass.
XCT_EXPORT XCUIElementAttributeName const XCUIElementAttributeNameVerticalSizeClass;

NS_ASSUME_NONNULL_END

#endif


typedef NS_ENUM(NSUInteger, XCUIElementType) {
    XCUIElementTypeAny = 0,
    XCUIElementTypeOther = 1,
    XCUIElementTypeApplication = 2,
    XCUIElementTypeGroup = 3,
    XCUIElementTypeWindow = 4,
    XCUIElementTypeSheet = 5,
    XCUIElementTypeDrawer = 6,
    XCUIElementTypeAlert = 7,
    XCUIElementTypeDialog = 8,
    XCUIElementTypeButton = 9,
    XCUIElementTypeRadioButton = 10,
    XCUIElementTypeRadioGroup = 11,
    XCUIElementTypeCheckBox = 12,
    XCUIElementTypeDisclosureTriangle = 13,
    XCUIElementTypePopUpButton = 14,
    XCUIElementTypeComboBox = 15,
    XCUIElementTypeMenuButton = 16,
    XCUIElementTypeToolbarButton = 17,
    XCUIElementTypePopover = 18,
    XCUIElementTypeKeyboard = 19,
    XCUIElementTypeKey = 20,
    XCUIElementTypeNavigationBar = 21,
    XCUIElementTypeTabBar = 22,
    XCUIElementTypeTabGroup = 23,
    XCUIElementTypeToolbar = 24,
    XCUIElementTypeStatusBar = 25,
    XCUIElementTypeTable = 26,
    XCUIElementTypeTableRow = 27,
    XCUIElementTypeTableColumn = 28,
    XCUIElementTypeOutline = 29,
    XCUIElementTypeOutlineRow = 30,
    XCUIElementTypeBrowser = 31,
    XCUIElementTypeCollectionView = 32,
    XCUIElementTypeSlider = 33,
    XCUIElementTypePageIndicator = 34,
    XCUIElementTypeProgressIndicator = 35,
    XCUIElementTypeActivityIndicator = 36,
    XCUIElementTypeSegmentedControl = 37,
    XCUIElementTypePicker = 38,
    XCUIElementTypePickerWheel = 39,
    XCUIElementTypeSwitch = 40,
    XCUIElementTypeToggle = 41,
    XCUIElementTypeLink = 42,
    XCUIElementTypeImage = 43,
    XCUIElementTypeIcon = 44,
    XCUIElementTypeSearchField = 45,
    XCUIElementTypeScrollView = 46,
    XCUIElementTypeScrollBar = 47,
    XCUIElementTypeStaticText = 48,
    XCUIElementTypeTextField = 49,
    XCUIElementTypeSecureTextField = 50,
    XCUIElementTypeDatePicker = 51,
    XCUIElementTypeTextView = 52,
    XCUIElementTypeMenu = 53,
    XCUIElementTypeMenuItem = 54,
    XCUIElementTypeMenuBar = 55,
    XCUIElementTypeMenuBarItem = 56,
    XCUIElementTypeMap = 57,
    XCUIElementTypeWebView = 58,
    XCUIElementTypeIncrementArrow = 59,
    XCUIElementTypeDecrementArrow = 60,
    XCUIElementTypeTimeline = 61,
    XCUIElementTypeRatingIndicator = 62,
    XCUIElementTypeValueIndicator = 63,
    XCUIElementTypeSplitGroup = 64,
    XCUIElementTypeSplitter = 65,
    XCUIElementTypeRelevanceIndicator = 66,
    XCUIElementTypeColorWell = 67,
    XCUIElementTypeHelpTag = 68,
    XCUIElementTypeMatte = 69,
    XCUIElementTypeDockItem = 70,
    XCUIElementTypeRuler = 71,
    XCUIElementTypeRulerMarker = 72,
    XCUIElementTypeGrid = 73,
    XCUIElementTypeLevelIndicator = 74,
    XCUIElementTypeCell = 75,
    XCUIElementTypeLayoutArea = 76,
    XCUIElementTypeLayoutItem = 77,
    XCUIElementTypeHandle = 78,
    XCUIElementTypeStepper = 79,
    XCUIElementTypeTab = 80,
    XCUIElementTypeTouchBar = 81,
    XCUIElementTypeStatusItem = 82,
};
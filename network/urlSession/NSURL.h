url  上面的内容

@interface NSURL: NSObject <NSSecureCoding, NSCopying>
{
    NSString *_urlString; //连接的字符串
    NSURL *_baseURL; // 基本的url  ，其实就是头部的url， 如果后面的urlString不是http这样的开头，就会拼接在baseurl的后面，如果是，直接用urlString
    void *_clients;
    void *_reserved;
}

#pragra mark - 初始化方法

- (nullable instancetype)initWithScheme:(NSString *)scheme host:(nullable NSString *)host path:(NSString *)path API_DEPRECATED("Use NSURLComponents instead, which lets you create a valid URL with any valid combination of URL components and subcomponents (not just scheme, host and path), and lets you set components and subcomponents with either percent-encoded or un-percent-encoded strings.", macos(10.0,10.11), ios(2.0,9.0), watchos(2.0,2.0), tvos(9.0,9.0)); 
// scheme host path 协议、主机、路径
// 这个不能够用于ipv6的username/password 或者端口。 使用NSURLComponents 处理ipv6

// 一个本地文件/目录路径的URL ， 基于baseURL  ， 建议使用第一个方法，如果知道了是目录还是文件，减少IO
- (instancetype)initFileURLWithPath:(NSString *)path isDirectory:(BOOL)isDir relativeToURL:(nullable NSURL *)baseURL API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0)) NS_DESIGNATED_INITIALIZER;
- (instancetype)initFileURLWithPath:(NSString *)path relativeToURL:(nullable NSURL *)baseURL API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0)) NS_DESIGNATED_INITIALIZER; 

//  直接铜鼓path创建一个url
- (instancetype)initFileURLWithPath:(NSString *)path isDirectory:(BOOL)isDir API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0)) NS_DESIGNATED_INITIALIZER;
- (instancetype)initFileURLWithPath:(NSString *)path NS_DESIGNATED_INITIALIZER; 

//  对应有关的类方法
+ (NSURL *)fileURLWithPath:(NSString *)path isDirectory:(BOOL) isDir relativeToURL:(nullable NSURL *)baseURL API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0));
+ (NSURL *)fileURLWithPath:(NSString *)path relativeToURL:(nullable NSURL *)baseURL API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0)); 
+ (NSURL *)fileURLWithPath:(NSString *)path isDirectory:(BOOL)isDir API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
+ (NSURL *)fileURLWithPath:(NSString *)path; 

//  文件系统的路径， 
//  文件系统必须是空结尾的C字符串和UTF-8编码。 

//  对应的几个初始化便利方法
+ (NSURL *)fileURLWithFileSystemRepresentation:(const char *)path isDirectory:(BOOL) isDir relativeToURL:(nullable NSURL *)baseURL API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));
- (nullable instancetype)initWithString:(NSString *)URLString;
- (nullable instancetype)initWithString:(NSString *)URLString relativeToURL:(nullable NSURL *)baseURL NS_DESIGNATED_INITIALIZER;
+ (nullable instancetype)URLWithString:(NSString *)URLString;
+ (nullable instancetype)URLWithString:(NSString *)URLString relativeToURL:(nullable NSURL *)baseURL;

// 通过data和baseURL来创建一个URL ， 如果数据不是一个合法的ASCII字节， 肯能显示不符合预期。
- (instancetype)initWithDataRepresentation:(NSData *)data relativeToURL:(nullable NSURL *)baseURL API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0)) NS_DESIGNATED_INITIALIZER;
+ (NSURL *)URLWithDataRepresentation:(NSData *)data relativeToURL:(nullable NSURL *)baseURL API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0));
- (instancetype)initAbsoluteURLWithDataRepresentation:(NSData *)data relativeToURL:(nullable NSURL *)baseURL API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0)) NS_DESIGNATED_INITIALIZER;
+ (NSURL *)absoluteURLWithDataRepresentation:(NSData *)data relativeToURL:(nullable NSURL *)baseURL API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0));

//  URL关联的数据， 如果使用-initWithData:relativeToURL: 这个方法， 将返回和初始化相同的数据，否则，返回关联的字符串的UTF-8编码
@property (readonly, copy) NSData *dataRepresentation API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0));

@property (nullable, readonly, copy) NSString *absoluteString;
@property (readonly, copy) NSString *relativeString; 
@property (nullable, readonly, copy) NSURL *baseURL; 
@property (nullable, readonly, copy) NSURL *absoluteURL;
@property (nullable, readonly, copy) NSString *scheme;
@property (nullable, readonly, copy) NSString *host;
@property (nullable, readonly, copy) NSNumber *port;
@property (nullable, readonly, copy) NSString *user;
@property (nullable, readonly, copy) NSString *password;
@property (nullable, readonly, copy) NSString *path;
@property (nullable, readonly, copy) NSString *fragment;
@property (nullable, readonly, copy) NSString *parameterString API_DEPRECATED("The parameterString method is deprecated. Post deprecation for applications linked with or after the macOS 10.15, and for all iOS, watchOS, and tvOS applications, parameterString will always return nil, and the path method will return the complete path including the semicolon separator and params component if the URL string contains them.", macosx(10.2,10.15), ios(2.0,13.0), watchos(2.0,6.0), tvos(9.0,13.0));
@property (nullable, readonly, copy) NSString *query;
@property (nullable, readonly, copy) NSString *relativePath; 

//  有目录的路径
@property (readonly) BOOL hasDirectoryPath API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0));

//  是否能获取文件新系统
- (BOOL)getFileSystemRepresentation:(char *)buffer maxLength:(NSUInteger)maxBufferLength API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

//  文件系统的表示， 这个文件的字符串标识
@property (readonly) const char *fileSystemRepresentation NS_RETURNS_INNER_POINTER API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

@property (readonly, getter=isFileURL) BOOL fileURL;//是否是文件的URL

FOUNDATION_EXPORT NSString *NSURLFileScheme; // file URL scheme

@property (nullable, readonly, copy) NSURL *standardizedURL; // 标准的URL

//  判断当前的URL的资源是否存在以及可达，用在了文件系统里面。
- (BOOL)checkResourceIsReachableAndReturnError:(NSError **)error NS_SWIFT_NOTHROW API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));


/* Working with file reference URLs
 */

- (BOOL)isFileReferenceURL API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); 
//是否是file的URL，没有操作

- (nullable NSURL *)fileReferenceURL API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
//  文件URL的引用， 没有操作

@property (nullable, readonly, copy) NSURL *filePathURL API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // 文件路径的URL


// 资源的访问
/* Resource access

NSURL和CFURL的在资源缓存上的区别:
1)-removeCachedResourceValueForKey: and -removeAllCachedResourceValues , 在下个 main runloop 抽泣移除。
2)CFURLClearResourcePropertyCacheForKey or CFURLClearResourcePropertyCache ， 完全客户端控制
 */


- (BOOL)getResourceValue:(out id _Nullable * _Nonnull)value forKey:(NSURLResourceKey)key error:(out NSError ** _Nullable)error API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
//  对应的key是否有资源

- (nullable NSDictionary<NSURLResourceKey, id> *)resourceValuesForKeys:(NSArray<NSURLResourceKey> *)keys error:(NSError **)error API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
//  获取多个key的资源

- (BOOL)setResourceValue:(nullable id)value forKey:(NSURLResourceKey)key error:(NSError **)error API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
//  给key设置资源

- (BOOL)setResourceValues:(NSDictionary<NSURLResourceKey, id> *)keyedValues error:(NSError **)error API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
//  多个设置

FOUNDATION_EXPORT NSURLResourceKey const NSURLKeysOfUnsetValuesKey API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); 
//  setResourceValues:error: 这个方法调用返回错误的时候，返回一个字符串数组

//  删除缓存
- (void)removeCachedResourceValueForKey:(NSURLResourceKey)key API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));
- (void)removeAllCachedResourceValues API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

// 设置暂时的key的值
- (void)setTemporaryResourceValue:(nullable id)value forKey:(NSURLResourceKey)key API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));



/*
 The File System Resource Keys
 */

//  可以用于所有文件系统的对象
FOUNDATION_EXPORT NSURLResourceKey const NSURLNameKey                        API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // 提供文件系统的读写
FOUNDATION_EXPORT NSURLResourceKey const NSURLLocalizedNameKey               API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // 本地化的名字
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsRegularFileKey               API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // 是否是常规文件 
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsDirectoryKey                 API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // 是否是目录
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsSymbolicLinkKey              API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // 是否是连接标识符
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsVolumeKey                    API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // 是否是卷的根目录
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsPackageKey                   API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // 是否是一个打包目录
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsApplicationKey               API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0)); // 是否是一个应用
FOUNDATION_EXPORT NSURLResourceKey const NSURLApplicationIsScriptableKey     API_AVAILABLE(macos(10.11)) API_UNAVAILABLE(ios, watchos, tvos); // True if the resource is scriptable. Only applies to applications (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsSystemImmutableKey           API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // True for system-immutable resources (Read-write, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsUserImmutableKey             API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // True for user-immutable resources (Read-write, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsHiddenKey                    API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // True for resources normally not displayed to users (Read-write, value type boolean NSNumber). Note: If the resource is a hidden because its name starts with a period, setting this property to false will not change the property.
FOUNDATION_EXPORT NSURLResourceKey const NSURLHasHiddenExtensionKey          API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // True for resources whose filename extension is removed from the localized name property (Read-write, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLCreationDateKey                API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // The date the resource was created (Read-write, value type NSDate)
FOUNDATION_EXPORT NSURLResourceKey const NSURLContentAccessDateKey           API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // The date the resource was last accessed (Read-write, value type NSDate)
FOUNDATION_EXPORT NSURLResourceKey const NSURLContentModificationDateKey     API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // The time the resource content was last modified (Read-write, value type NSDate)
FOUNDATION_EXPORT NSURLResourceKey const NSURLAttributeModificationDateKey   API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // The time the resource's attributes were last modified (Read-only, value type NSDate)
FOUNDATION_EXPORT NSURLResourceKey const NSURLLinkCountKey                   API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // Number of hard links to the resource (Read-only, value type NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLParentDirectoryURLKey          API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // The resource's parent directory, if any (Read-only, value type NSURL)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeURLKey                   API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // URL of the volume on which the resource is stored (Read-only, value type NSURL)
FOUNDATION_EXPORT NSURLResourceKey const NSURLTypeIdentifierKey              API_DEPRECATED("Use NSURLContentTypeKey instead", macos(10.6, API_TO_BE_DEPRECATED), ios(4.0, API_TO_BE_DEPRECATED), watchos(2.0, API_TO_BE_DEPRECATED), tvos(9.0, API_TO_BE_DEPRECATED)); // Uniform type identifier (UTI) for the resource (Read-only, value type NSString)
FOUNDATION_EXPORT NSURLResourceKey const NSURLContentTypeKey                 API_AVAILABLE(macos(11.0), ios(14.0), watchos(7.0), tvos(14.0)); // File type (UTType) for the resource (Read-only, value type UTType)
FOUNDATION_EXPORT NSURLResourceKey const NSURLLocalizedTypeDescriptionKey    API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // User-visible type or "kind" description (Read-only, value type NSString)
FOUNDATION_EXPORT NSURLResourceKey const NSURLLabelNumberKey                 API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // The label number assigned to the resource (Read-write, value type NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLLabelColorKey                  API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // The color of the assigned label (Read-only, value type NSColor)
FOUNDATION_EXPORT NSURLResourceKey const NSURLLocalizedLabelKey              API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // The user-visible label text (Read-only, value type NSString)
FOUNDATION_EXPORT NSURLResourceKey const NSURLEffectiveIconKey               API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // The icon normally displayed for the resource (Read-only, value type NSImage)
FOUNDATION_EXPORT NSURLResourceKey const NSURLCustomIconKey                  API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // The custom icon assigned to the resource, if any (Currently not implemented, value type NSImage)
FOUNDATION_EXPORT NSURLResourceKey const NSURLFileResourceIdentifierKey      API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // An identifier which can be used to compare two file system objects for equality using -isEqual (i.e, two object identifiers are equal if they have the same file system path or if the paths are linked to same inode on the same file system). This identifier is not persistent across system restarts. (Read-only, value type id <NSCopying, NSCoding, NSSecureCoding, NSObject>)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeIdentifierKey            API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // An identifier that can be used to identify the volume the file system object is on. Other objects on the same volume will have the same volume identifier and can be compared using for equality using -isEqual. This identifier is not persistent across system restarts. (Read-only, value type id <NSCopying, NSCoding, NSSecureCoding, NSObject>)
FOUNDATION_EXPORT NSURLResourceKey const NSURLPreferredIOBlockSizeKey        API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // The optimal block size when reading or writing this file's data, or nil if not available. (Read-only, value type NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsReadableKey                  API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if this process (as determined by EUID) can read the resource. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsWritableKey                  API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if this process (as determined by EUID) can write to the resource. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsExecutableKey                API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if this process (as determined by EUID) can execute a file resource or search a directory resource. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLFileSecurityKey                API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // The file system object's security information encapsulated in a NSFileSecurity object. (Read-write, Value type NSFileSecurity)
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsExcludedFromBackupKey        API_AVAILABLE(macos(10.8), ios(5.1), watchos(2.0), tvos(9.0)); // true if resource should be excluded from backups, false otherwise (Read-write, value type boolean NSNumber). This property is only useful for excluding cache and other application support files which are not needed in a backup. Some operations commonly made to user documents will cause this property to be reset to false and so this property should not be used on user documents.
FOUNDATION_EXPORT NSURLResourceKey const NSURLTagNamesKey                    API_AVAILABLE(macos(10.9)) API_UNAVAILABLE(ios, watchos, tvos);	// The array of Tag names (Read-write, value type NSArray of NSString)
FOUNDATION_EXPORT NSURLResourceKey const NSURLPathKey                        API_AVAILABLE(macos(10.8), ios(6.0), watchos(2.0), tvos(9.0)); // the URL's path as a file system path (Read-only, value type NSString)
FOUNDATION_EXPORT NSURLResourceKey const NSURLCanonicalPathKey               API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0)); // the URL's path as a canonical absolute file system path (Read-only, value type NSString)
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsMountTriggerKey              API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if this URL is a file system trigger directory. Traversing or opening a file system trigger will cause an attempt to mount a file system on the trigger directory. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLGenerationIdentifierKey API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0)); // An opaque generation identifier which can be compared using isEqual: to determine if the data in a document has been modified. For URLs which refer to the same file inode, the generation identifier will change when the data in the file's data fork is changed (changes to extended attributes or other file system metadata do not change the generation identifier). For URLs which refer to the same directory inode, the generation identifier will change when direct children of that directory are added, removed or renamed (changes to the data of the direct children of that directory will not change the generation identifier). The generation identifier is persistent across system restarts. The generation identifier is tied to a specific document on a specific volume and is not transferred when the document is copied to another volume. This property is not supported by all volumes. (Read-only, value type id <NSCopying, NSCoding, NSSecureCoding, NSObject>)
FOUNDATION_EXPORT NSURLResourceKey const NSURLDocumentIdentifierKey API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0)); // The document identifier -- a value assigned by the kernel to a document (which can be either a file or directory) and is used to identify the document regardless of where it gets moved on a volume. The document identifier survives "safe save” operations; i.e it is sticky to the path it was assigned to (-replaceItemAtURL:withItemAtURL:backupItemName:options:resultingItemURL:error: is the preferred safe-save API). The document identifier is persistent across system restarts. The document identifier is not transferred when the file is copied. Document identifiers are only unique within a single volume. This property is not supported by all volumes. (Read-only, value type NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLAddedToDirectoryDateKey API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0)); // The date the resource was created, or renamed into or within its parent directory. Note that inconsistent behavior may be observed when this attribute is requested on hard-linked items. This property is not supported by all volumes. (Read-only before macOS 10.15, iOS 13.0, watchOS 6.0, and tvOS 13.0; Read-write after, value type NSDate)
FOUNDATION_EXPORT NSURLResourceKey const NSURLQuarantinePropertiesKey API_AVAILABLE(macos(10.10)) API_UNAVAILABLE(ios, watchos, tvos); // The quarantine properties as defined in LSQuarantine.h. To remove quarantine information from a file, pass NSNull as the value when setting this property. (Read-write, value type NSDictionary)
FOUNDATION_EXPORT NSURLResourceKey const NSURLFileResourceTypeKey            API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // Returns the file system object type. (Read-only, value type NSString)
FOUNDATION_EXPORT NSURLResourceKey const NSURLFileContentIdentifierKey       API_AVAILABLE(macos(11.0), ios(14.0), watchos(7.0), tvos(14.0)); // A 64-bit value assigned by APFS that identifies a file's content data stream. Only cloned files and their originals can have the same identifier. (Read-only, value type NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLMayShareFileContentKey         API_AVAILABLE(macos(11.0), ios(14.0), watchos(7.0), tvos(14.0)); // True for cloned files and their originals that may share all, some, or no data blocks. (Read-only, value type NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLMayHaveExtendedAttributesKey   API_AVAILABLE(macos(11.0), ios(14.0), watchos(7.0), tvos(14.0)); // True if the file has extended attributes. False guarantees there are none. (Read-only, value type NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsPurgeableKey                 API_AVAILABLE(macos(11.0), ios(14.0), watchos(7.0), tvos(14.0)); // True if the file can be deleted by the file system when asked to free space. (Read-only, value type NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsSparseKey                    API_AVAILABLE(macos(11.0), ios(14.0), watchos(7.0), tvos(14.0)); // True if the file has sparse regions. (Read-only, value type NSNumber)

typedef NSString * NSURLFileResourceType NS_TYPED_ENUM;

/* The file system object type values returned for the NSURLFileResourceTypeKey
 */
FOUNDATION_EXPORT NSURLFileResourceType const NSURLFileResourceTypeNamedPipe      API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSURLFileResourceType const NSURLFileResourceTypeCharacterSpecial API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSURLFileResourceType const NSURLFileResourceTypeDirectory      API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSURLFileResourceType const NSURLFileResourceTypeBlockSpecial   API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSURLFileResourceType const NSURLFileResourceTypeRegular        API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSURLFileResourceType const NSURLFileResourceTypeSymbolicLink   API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSURLFileResourceType const NSURLFileResourceTypeSocket         API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT NSURLFileResourceType const NSURLFileResourceTypeUnknown        API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));

FOUNDATION_EXPORT NSURLResourceKey const NSURLThumbnailDictionaryKey         API_DEPRECATED("Use the QuickLookThumbnailing framework and extension point instead", macos(10.10, 12.0), ios(8.0, 15.0), watchos(2.0, 8.0), tvos(9.0, 15.0)); // dictionary of NSImage/UIImage objects keyed by size
FOUNDATION_EXPORT NSURLResourceKey const NSURLThumbnailKey                   API_DEPRECATED("Use the QuickLookThumbnailing framework and extension point instead", macos(10.10, 12.0)) API_UNAVAILABLE(ios, watchos, tvos); // returns all thumbnails as a single NSImage

typedef NSString *NSURLThumbnailDictionaryItem NS_TYPED_EXTENSIBLE_ENUM;
/* size keys for the dictionary returned by NSURLThumbnailDictionaryKey
 */
FOUNDATION_EXPORT NSURLThumbnailDictionaryItem const NSThumbnail1024x1024SizeKey         API_DEPRECATED("Use the QuickLookThumbnailing framework and extension point instead", macos(10.10, 12.0), ios(8.0, 15.0), watchos(2.0, 8.0), tvos(9.0, 15.0)); // size key for a 1024 x 1024 thumbnail image

/* Resource keys applicable only to regular files
 */
FOUNDATION_EXPORT NSURLResourceKey const NSURLFileSizeKey                    API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // Total file size in bytes (Read-only, value type NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLFileAllocatedSizeKey           API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // Total size allocated on disk for the file in bytes (number of blocks times block size) (Read-only, value type NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLTotalFileSizeKey               API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // Total displayable size of the file in bytes (this may include space used by metadata), or nil if not available. (Read-only, value type NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLTotalFileAllocatedSizeKey      API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // Total allocated size of the file in bytes (this may include space used by metadata), or nil if not available. This can be less than the value returned by NSURLTotalFileSizeKey if the resource is compressed. (Read-only, value type NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsAliasFileKey                 API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // true if the resource is a Finder alias file or a symlink, false otherwise ( Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLFileProtectionKey              API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0)); // The protection level for this file

typedef NSString * NSURLFileProtectionType NS_TYPED_ENUM;
/* The protection level values returned for the NSURLFileProtectionKey
 */
FOUNDATION_EXPORT NSURLFileProtectionType const NSURLFileProtectionNone API_AVAILABLE(macos(11.0), ios(9.0), watchos(2.0), tvos(9.0)); // The file has no special protections associated with it. It can be read from or written to at any time.
FOUNDATION_EXPORT NSURLFileProtectionType const NSURLFileProtectionComplete API_AVAILABLE(macos(11.0), ios(9.0), watchos(2.0), tvos(9.0)); // The file is stored in an encrypted format on disk and cannot be read from or written to while the device is locked or booting.
FOUNDATION_EXPORT NSURLFileProtectionType const NSURLFileProtectionCompleteUnlessOpen API_AVAILABLE(macos(11.0), ios(9.0), watchos(2.0), tvos(9.0)); // The file is stored in an encrypted format on disk. Files can be created while the device is locked, but once closed, cannot be opened again until the device is unlocked. If the file is opened when unlocked, you may continue to access the file normally, even if the user locks the device. There is a small performance penalty when the file is created and opened, though not when being written to or read from. This can be mitigated by changing the file protection to NSURLFileProtectionComplete when the device is unlocked.
FOUNDATION_EXPORT NSURLFileProtectionType const NSURLFileProtectionCompleteUntilFirstUserAuthentication API_AVAILABLE(macos(11.0), ios(9.0), watchos(2.0), tvos(9.0)); // The file is stored in an encrypted format on disk and cannot be accessed until after the device has booted. After the user unlocks the device for the first time, your app can access the file and continue to access it even if the user subsequently locks the device.

/* Volumes resource keys 
 
 As a convenience, volume resource values can be requested from any file system URL. The value returned will reflect the property value for the volume on which the resource is located.
 */
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeLocalizedFormatDescriptionKey API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // The user-visible volume format (Read-only, value type NSString)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeTotalCapacityKey              API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // Total volume capacity in bytes (Read-only, value type NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeAvailableCapacityKey          API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // Total free space in bytes (Read-only, value type NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeResourceCountKey              API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // Total number of resources on the volume (Read-only, value type NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsPersistentIDsKey      API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // true if the volume format supports persistent object identifiers and can look up file system objects by their IDs (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsSymbolicLinksKey      API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // true if the volume format supports symbolic links (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsHardLinksKey          API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // true if the volume format supports hard links (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsJournalingKey         API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // true if the volume format supports a journal used to speed recovery in case of unplanned restart (such as a power outage or crash). This does not necessarily mean the volume is actively using a journal. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeIsJournalingKey               API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // true if the volume is currently using a journal for speedy recovery after an unplanned restart. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsSparseFilesKey        API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // true if the volume format supports sparse files, that is, files which can have 'holes' that have never been written to, and thus do not consume space on disk. A sparse file may have an allocated size on disk that is less than its logical length (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsZeroRunsKey           API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // For security reasons, parts of a file (runs) that have never been written to must appear to contain zeroes. true if the volume keeps track of allocated but unwritten runs of a file so that it can substitute zeroes without actually writing zeroes to the media. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsCaseSensitiveNamesKey API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // true if the volume format treats upper and lower case characters in file and directory names as different. Otherwise an upper case character is equivalent to a lower case character, and you can't have two names that differ solely in the case of the characters. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsCasePreservedNamesKey API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0)); // true if the volume format preserves the case of file and directory names.  Otherwise the volume may change the case of some characters (typically making them all upper or all lower case). (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsRootDirectoryDatesKey API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if the volume supports reliable storage of times for the root directory. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsVolumeSizesKey        API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if the volume supports returning volume size values (NSURLVolumeTotalCapacityKey and NSURLVolumeAvailableCapacityKey). (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsRenamingKey           API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if the volume can be renamed. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsAdvisoryFileLockingKey API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if the volume implements whole-file flock(2) style advisory locks, and the O_EXLOCK and O_SHLOCK flags of the open(2) call. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsExtendedSecurityKey   API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if the volume implements extended security (ACLs). (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeIsBrowsableKey                API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if the volume should be visible via the GUI (i.e., appear on the Desktop as a separate volume). (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeMaximumFileSizeKey            API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // The largest file size (in bytes) supported by this file system, or nil if this cannot be determined. (Read-only, value type NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeIsEjectableKey                API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if the volume's media is ejectable from the drive mechanism under software control. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeIsRemovableKey                API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if the volume's media is removable from the drive mechanism. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeIsInternalKey                 API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if the volume's device is connected to an internal bus, false if connected to an external bus, or nil if not available. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeIsAutomountedKey              API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if the volume is automounted. Note: do not mistake this with the functionality provided by kCFURLVolumeSupportsBrowsingKey. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeIsLocalKey                    API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if the volume is stored on a local device. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeIsReadOnlyKey                 API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if the volume is read-only. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeCreationDateKey               API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // The volume's creation date, or nil if this cannot be determined. (Read-only, value type NSDate)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeURLForRemountingKey           API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // The NSURL needed to remount a network volume, or nil if not available. (Read-only, value type NSURL)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeUUIDStringKey                 API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // The volume's persistent UUID as a string, or nil if a persistent UUID is not available for the volume. (Read-only, value type NSString)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeNameKey                       API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // The name of the volume (Read-write if NSURLVolumeSupportsRenamingKey is YES, otherwise read-only, value type NSString)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeLocalizedNameKey              API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // The user-presentable name of the volume (Read-only, value type NSString)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeIsEncryptedKey                API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0)); // true if the volume is encrypted. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeIsRootFileSystemKey           API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0)); // true if the volume is the root filesystem. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsCompressionKey        API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0)); // true if the volume supports transparent decompression of compressed files using decmpfs. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsFileCloningKey API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0)); // true if the volume supports clonefile(2) (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsSwapRenamingKey API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0)); // true if the volume supports renamex_np(2)'s RENAME_SWAP option (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsExclusiveRenamingKey API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0)); // true if the volume supports renamex_np(2)'s RENAME_EXCL option (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsImmutableFilesKey API_AVAILABLE(macosx(10.13), ios(11.0), watchos(4.0), tvos(11.0)); // true if the volume supports making files immutable with the NSURLIsUserImmutableKey or NSURLIsSystemImmutableKey properties (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsAccessPermissionsKey API_AVAILABLE(macosx(10.13), ios(11.0), watchos(4.0), tvos(11.0)); // true if the volume supports setting POSIX access permissions with the NSURLFileSecurityKey property (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeSupportsFileProtectionKey     API_AVAILABLE(macos(11.0), ios(14.0), watchos(7.0), tvos(14.0)); // True if the volume supports the File Protection attribute (see NSURLFileProtectionKey). (Read-only, value type NSNumber)

/* Total available capacity in bytes for "Important" resources, including space expected to be cleared by purging non-essential and cached resources. "Important" means something that the user or application clearly expects to be present on the local system, but is ultimately replaceable. This would include items that the user has explicitly requested via the UI, and resources that an application requires in order to provide functionality.
 
 Examples: A video that the user has explicitly requested to watch but has not yet finished watching or an audio file that the user has requested to download.
 
 This value should not be used in determining if there is room for an irreplaceable resource. In the case of irreplaceable resources, always attempt to save the resource regardless of available capacity and handle failure as gracefully as possible.
 */
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeAvailableCapacityForImportantUsageKey API_AVAILABLE(macos(10.13), ios(11.0)) API_UNAVAILABLE(watchos, tvos); // (Read-only, value type NSNumber)

/* Total available capacity in bytes for "Opportunistic" resources, including space expected to be cleared by purging non-essential and cached resources. "Opportunistic" means something that the user is likely to want but does not expect to be present on the local system, but is ultimately non-essential and replaceable. This would include items that will be created or downloaded without an explicit request from the user on the current device.
 
 Examples: A background download of a newly available episode of a TV series that a user has been recently watching, a piece of content explicitly requested on another device, or a new document saved to a network server by the current user from another device.
 */
FOUNDATION_EXPORT NSURLResourceKey const NSURLVolumeAvailableCapacityForOpportunisticUsageKey API_AVAILABLE(macos(10.13), ios(11.0)) API_UNAVAILABLE(watchos, tvos); // (Read-only, value type NSNumber)


/* Ubiquitous item resource keys
 */
FOUNDATION_EXPORT NSURLResourceKey const NSURLIsUbiquitousItemKey                     API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if this item is synced to the cloud, false if it is only a local file. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousItemHasUnresolvedConflictsKey API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if this item has conflicts outstanding. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousItemIsDownloadedKey           API_DEPRECATED("Use NSURLUbiquitousItemDownloadingStatusKey instead", macos(10.7,10.9), ios(5.0,7.0), watchos(2.0,2.0), tvos(9.0,9.0)); // equivalent to NSURLUbiquitousItemDownloadingStatusKey == NSURLUbiquitousItemDownloadingStatusCurrent. Has never behaved as documented in earlier releases, hence deprecated.  (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousItemIsDownloadingKey          API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if data is being downloaded for this item. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousItemIsUploadedKey             API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if there is data present in the cloud for this item. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousItemIsUploadingKey            API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)); // true if data is being uploaded for this item. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousItemPercentDownloadedKey      API_DEPRECATED("Use NSMetadataUbiquitousItemPercentDownloadedKey instead", macos(10.7,10.8), ios(5.0,6.0), watchos(2.0,2.0), tvos(9.0,9.0)); // Use NSMetadataQuery and NSMetadataUbiquitousItemPercentDownloadedKey on NSMetadataItem instead
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousItemPercentUploadedKey        API_DEPRECATED("Use NSMetadataUbiquitousItemPercentUploadedKey instead", macos(10.7,10.8), ios(5.0,6.0), watchos(2.0,2.0), tvos(9.0,9.0)); // Use NSMetadataQuery and NSMetadataUbiquitousItemPercentUploadedKey on NSMetadataItem instead
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousItemDownloadingStatusKey      API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0)); // returns the download status of this item. (Read-only, value type NSString). Possible values below.
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousItemDownloadingErrorKey       API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0)); // returns the error when downloading the item from iCloud failed, see the NSUbiquitousFile section in FoundationErrors.h (Read-only, value type NSError)
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousItemUploadingErrorKey         API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0)); // returns the error when uploading the item to iCloud failed, see the NSUbiquitousFile section in FoundationErrors.h (Read-only, value type NSError)
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousItemDownloadRequestedKey      API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0)); // returns whether a download of this item has already been requested with an API like -startDownloadingUbiquitousItemAtURL:error: (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousItemContainerDisplayNameKey   API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0)); // returns the name of this item's container as displayed to users.
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousItemIsExcludedFromSyncKey     API_AVAILABLE(macos(11.3), ios(14.5), watchos(7.4), tvos(14.5)); // true if the item is excluded from sync, which means it is locally on disk but won't be available on the server. An excluded item is no longer ubiquitous. (Read-write, value type boolean NSNumber


FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousItemIsSharedKey                               API_AVAILABLE(macosx(10.12), ios(10.0)) API_UNAVAILABLE(watchos, tvos); // true if the ubiquitous item is shared. (Read-only, value type boolean NSNumber)
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousSharedItemCurrentUserRoleKey                  API_AVAILABLE(macosx(10.12), ios(10.0)) API_UNAVAILABLE(watchos, tvos); // returns the current user's role for this shared item, or nil if not shared. (Read-only, value type NSString). Possible values below.
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousSharedItemCurrentUserPermissionsKey           API_AVAILABLE(macosx(10.12), ios(10.0)) API_UNAVAILABLE(watchos, tvos); // returns the permissions for the current user, or nil if not shared. (Read-only, value type NSString). Possible values below.
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousSharedItemOwnerNameComponentsKey              API_AVAILABLE(macosx(10.12), ios(10.0)) API_UNAVAILABLE(watchos, tvos); // returns a NSPersonNameComponents, or nil if the current user. (Read-only, value type NSPersonNameComponents)
FOUNDATION_EXPORT NSURLResourceKey const NSURLUbiquitousSharedItemMostRecentEditorNameComponentsKey   API_AVAILABLE(macosx(10.12), ios(10.0)) API_UNAVAILABLE(watchos, tvos); // returns a NSPersonNameComponents for the most recent editor of the document, or nil if it is the current user. (Read-only, value type NSPersonNameComponents)

typedef NSString * NSURLUbiquitousItemDownloadingStatus NS_TYPED_ENUM;
/* The values returned for the NSURLUbiquitousItemDownloadingStatusKey
 */
FOUNDATION_EXPORT NSURLUbiquitousItemDownloadingStatus const NSURLUbiquitousItemDownloadingStatusNotDownloaded  API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0)); // this item has not been downloaded yet. Use startDownloadingUbiquitousItemAtURL:error: to download it.
FOUNDATION_EXPORT NSURLUbiquitousItemDownloadingStatus const NSURLUbiquitousItemDownloadingStatusDownloaded     API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0)); // there is a local version of this item available. The most current version will get downloaded as soon as possible.
FOUNDATION_EXPORT NSURLUbiquitousItemDownloadingStatus const NSURLUbiquitousItemDownloadingStatusCurrent        API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0)); // there is a local version of this item and it is the most up-to-date version known to this device.

typedef NSString * NSURLUbiquitousSharedItemRole NS_TYPED_ENUM;

/* The values returned for the NSURLUbiquitousSharedItemCurrentUserRoleKey
 */
FOUNDATION_EXPORT NSURLUbiquitousSharedItemRole const NSURLUbiquitousSharedItemRoleOwner       API_AVAILABLE(macosx(10.12), ios(10.0)) API_UNAVAILABLE(watchos, tvos); // the current user is the owner of this shared item.
FOUNDATION_EXPORT NSURLUbiquitousSharedItemRole const NSURLUbiquitousSharedItemRoleParticipant API_AVAILABLE(macosx(10.12), ios(10.0)) API_UNAVAILABLE(watchos, tvos); // the current user is a participant of this shared item.

typedef NSString * NSURLUbiquitousSharedItemPermissions NS_TYPED_ENUM;

/* The values returned for the NSURLUbiquitousSharedItemCurrentUserPermissionsKey
 */
FOUNDATION_EXPORT NSURLUbiquitousSharedItemPermissions const NSURLUbiquitousSharedItemPermissionsReadOnly     API_AVAILABLE(macosx(10.12), ios(10.0)) API_UNAVAILABLE(watchos, tvos); // the current user is only allowed to read this item
FOUNDATION_EXPORT NSURLUbiquitousSharedItemPermissions const NSURLUbiquitousSharedItemPermissionsReadWrite    API_AVAILABLE(macosx(10.12), ios(10.0)) API_UNAVAILABLE(watchos, tvos); // the current user is allowed to both read and write this item

/* Working with Bookmarks and alias (bookmark) files 
 */

//  书签的创建选项
typedef NS_OPTIONS(NSUInteger, NSURLBookmarkCreationOptions) {
    NSURLBookmarkCreationPreferFileIDResolution API_DEPRECATED("Not supported", macos(10.6,10.9), ios(4.0,7.0), watchos(2.0,2.0), tvos(9.0,9.0)) = ( 1UL << 8 ), /* This option does nothing and has no effect on bookmark resolution */
    NSURLBookmarkCreationMinimalBookmark = ( 1UL << 9 ), /* creates bookmark data with "less" information, which may be smaller but still be able to resolve in certain ways */
    NSURLBookmarkCreationSuitableForBookmarkFile = ( 1UL << 10 ), /* include the properties required by writeBookmarkData:toURL:options: in the bookmark data created */
    NSURLBookmarkCreationWithSecurityScope API_AVAILABLE(macos(10.7), macCatalyst(13.0)) API_UNAVAILABLE(ios, watchos, tvos) = ( 1 << 11 ), /* include information in the bookmark data which allows the same sandboxed process to access the resource after being relaunched */
    NSURLBookmarkCreationSecurityScopeAllowOnlyReadAccess API_AVAILABLE(macos(10.7), macCatalyst(13.0)) API_UNAVAILABLE(ios, watchos, tvos) = ( 1 << 12 ), /* if used with kCFURLBookmarkCreationWithSecurityScope, at resolution time only read access to the resource will be granted */
    NSURLBookmarkCreationWithoutImplicitSecurityScope  API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)) = (1 << 29) /* Disable automatic embedding of an implicit security scope. The resolving process will not be able gain access to the resource by security scope, either implicitly or explicitly, through the returned URL. Not applicable to security-scoped bookmarks.*/
} API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

//  书签的解决选项
typedef NS_OPTIONS(NSUInteger, NSURLBookmarkResolutionOptions) {
    NSURLBookmarkResolutionWithoutUI = ( 1UL << 8 ), /* don't perform any user interaction during bookmark resolution */
    NSURLBookmarkResolutionWithoutMounting = ( 1UL << 9 ), /* don't mount a volume during bookmark resolution */
    NSURLBookmarkResolutionWithSecurityScope API_AVAILABLE(macos(10.7), macCatalyst(13.0)) API_UNAVAILABLE(ios, watchos, tvos) = ( 1 << 10 ), /* use the secure information included at creation time to provide the ability to access the resource in a sandboxed process */
    NSURLBookmarkResolutionWithoutImplicitStartAccessing API_AVAILABLE(macos(11.2), ios(14.2), watchos(7.2), tvos(14.2)) = ( 1 << 15 ), /* Disable implicitly starting access of the ephemeral security-scoped resource during resolution. Instead, call `-[NSURL startAccessingSecurityScopedResource]` on the returned URL when ready to use the resource. Not applicable to security-scoped bookmarks. */
} API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

typedef NSUInteger NSURLBookmarkFileCreationOptions;



//  关于书签的操作， 感觉这个完全可以开发一个pdf的应用了

/* Returns bookmark data for the URL, created with specified options and resource values. If this method returns nil, the optional error is populated.
 */
- (nullable NSData *)bookmarkDataWithOptions:(NSURLBookmarkCreationOptions)options includingResourceValuesForKeys:(nullable NSArray<NSURLResourceKey> *)keys relativeToURL:(nullable NSURL *)relativeURL error:(NSError **)error API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

/* Initializes a newly created NSURL that refers to a location specified by resolving bookmark data. If this method returns nil, the optional error is populated.
 */
- (nullable instancetype)initByResolvingBookmarkData:(NSData *)bookmarkData options:(NSURLBookmarkResolutionOptions)options relativeToURL:(nullable NSURL *)relativeURL bookmarkDataIsStale:(BOOL * _Nullable)isStale error:(NSError **)error API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
/* Creates and Initializes an NSURL that refers to a location specified by resolving bookmark data. If this method returns nil, the optional error is populated.
 */
+ (nullable instancetype)URLByResolvingBookmarkData:(NSData *)bookmarkData options:(NSURLBookmarkResolutionOptions)options relativeToURL:(nullable NSURL *)relativeURL bookmarkDataIsStale:(BOOL * _Nullable)isStale error:(NSError **)error API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

/* Returns the resource values for properties identified by a specified array of keys contained in specified bookmark data. If the result dictionary does not contain a resource value for one or more of the requested resource keys, it means those resource properties are not available in the bookmark data.
 */
+ (nullable NSDictionary<NSURLResourceKey, id> *)resourceValuesForKeys:(NSArray<NSURLResourceKey> *)keys fromBookmarkData:(NSData *)bookmarkData API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

/* Creates an alias file on disk at a specified location with specified bookmark data. bookmarkData must have been created with the NSURLBookmarkCreationSuitableForBookmarkFile option. bookmarkFileURL must either refer to an existing file (which will be overwritten), or to location in an existing directory. If this method returns NO, the optional error is populated.
*/
+ (BOOL)writeBookmarkData:(NSData *)bookmarkData toURL:(NSURL *)bookmarkFileURL options:(NSURLBookmarkFileCreationOptions)options error:(NSError **)error API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

/* Initializes and returns bookmark data derived from an alias file pointed to by a specified URL. If bookmarkFileURL refers to an alias file created prior to OS X v10.6 that contains Alias Manager information but no bookmark data, this method synthesizes bookmark data for the file. If this method returns nil, the optional error is populated.
*/
+ (nullable NSData *)bookmarkDataWithContentsOfURL:(NSURL *)bookmarkFileURL error:(NSError **)error API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

/* Creates and initializes a NSURL that refers to the location specified by resolving the alias file at url. If the url argument does not refer to an alias file as defined by the NSURLIsAliasFileKey property, the NSURL returned is the same as url argument. This method fails and returns nil if the url argument is unreachable, or if the original file or directory could not be located or is not reachable, or if the original file or directory is on a volume that could not be located or mounted. If this method fails, the optional error is populated. The NSURLBookmarkResolutionWithSecurityScope option is not supported by this method.
 */
+ (nullable instancetype)URLByResolvingAliasFileAtURL:(NSURL *)url options:(NSURLBookmarkResolutionOptions)options error:(NSError **)error API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));

//  开始访问安全代码资源
- (BOOL)startAccessingSecurityScopedResource API_AVAILABLE(macos(10.7), ios(8.0), watchos(2.0), tvos(9.0));

//  停止访问安全代码资源
- (void)stopAccessingSecurityScopedResource API_AVAILABLE(macos(10.7), ios(8.0), watchos(2.0), tvos(9.0));

@end


//  允许选项
@interface NSURL (NSPromisedItems)

/* Get resource values from URLs of 'promised' items. A promised item is not guaranteed to have its contents in the file system until you use NSFileCoordinator to perform a coordinated read on its URL, which causes the contents to be downloaded or otherwise generated. Promised item URLs are returned by various APIs, including currently:
 - NSMetadataQueryUbiquitousDataScope
 - NSMetadataQueryUbiquitousDocumentsScope
 - An NSFilePresenter presenting the contents of the directory located by -URLForUbiquitousContainerIdentifier: or a subdirectory thereof
 
 The following methods behave identically to their similarly named methods above (-getResourceValue:forKey:error:, etc.), except that they allow you to get resource values and check for presence regardless of whether the promised item's contents currently exist at the URL. You must use these APIs instead of the normal NSURL resource value APIs if and only if any of the following are true:
 - You are using a URL that you know came directly from one of the above APIs
 - You are inside the accessor block of a coordinated read or write that used NSFileCoordinatorReadingImmediatelyAvailableMetadataOnly, NSFileCoordinatorWritingForDeleting, NSFileCoordinatorWritingForMoving, or NSFileCoordinatorWritingContentIndependentMetadataOnly
 
 Most of the NSURL resource value keys will work with these APIs. However, there are some that are tied to the item's contents that will not work, such as NSURLContentAccessDateKey or NSURLGenerationIdentifierKey. If one of these keys is used, the method will return YES, but the value for the key will be nil.
*/
- (BOOL)getPromisedItemResourceValue:(id _Nullable * _Nonnull)value forKey:(NSURLResourceKey)key error:(NSError **)error API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
- (nullable NSDictionary<NSURLResourceKey, id> *)promisedItemResourceValuesForKeys:(NSArray<NSURLResourceKey> *)keys error:(NSError **)error API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
- (BOOL)checkPromisedItemIsReachableAndReturnError:(NSError **)error NS_SWIFT_NOTHROW API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));

@end


//  提供选项的Item
@interface NSURL (NSItemProvider) <NSItemProviderReading, NSItemProviderWriting>
@end


API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0))
// NSURLQueryItem encapsulates a single query name-value pair. The name and value strings of a query name-value pair are not percent encoded. For use with the NSURLComponents queryItems property.
@interface NSURLQueryItem : NSObject <NSSecureCoding, NSCopying> {
@private
    NSString *_name;
    NSString *_value;
}
- (instancetype)initWithName:(NSString *)name value:(nullable NSString *)value NS_DESIGNATED_INITIALIZER;
+ (instancetype)queryItemWithName:(NSString *)name value:(nullable NSString *)value;
@property (readonly) NSString *name;
@property (nullable, readonly) NSString *value;
@end


//  关于URL的字符集
@interface NSCharacterSet (NSURLUtilities)
// Predefined character sets for the six URL components and subcomponents which allow percent encoding. These character sets are passed to -stringByAddingPercentEncodingWithAllowedCharacters:.

// Returns a character set containing the characters allowed in a URL's user subcomponent.
@property (class, readonly, copy) NSCharacterSet *URLUserAllowedCharacterSet API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

// Returns a character set containing the characters allowed in a URL's password subcomponent.
@property (class, readonly, copy) NSCharacterSet *URLPasswordAllowedCharacterSet API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

// Returns a character set containing the characters allowed in a URL's host subcomponent.
@property (class, readonly, copy) NSCharacterSet *URLHostAllowedCharacterSet API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

// Returns a character set containing the characters allowed in a URL's path component. ';' is a legal path character, but it is recommended that it be percent-encoded for best compatibility with NSURL (-stringByAddingPercentEncodingWithAllowedCharacters: will percent-encode any ';' characters if you pass the URLPathAllowedCharacterSet).
@property (class, readonly, copy) NSCharacterSet *URLPathAllowedCharacterSet API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

// Returns a character set containing the characters allowed in a URL's query component.
@property (class, readonly, copy) NSCharacterSet *URLQueryAllowedCharacterSet API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

// Returns a character set containing the characters allowed in a URL's fragment component.
@property (class, readonly, copy) NSCharacterSet *URLFragmentAllowedCharacterSet API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

@end、


//  URL上面的字符串的方法处理
@interface NSString (NSURLUtilities)

// Returns a new string made from the receiver by replacing all characters not in the allowedCharacters set with percent encoded characters. UTF-8 encoding is used to determine the correct percent encoded characters. Entire URL strings cannot be percent-encoded. This method is intended to percent-encode a URL component or subcomponent string, NOT the entire URL string. Any characters in allowedCharacters outside of the 7-bit ASCII range are ignored.
- (nullable NSString *)stringByAddingPercentEncodingWithAllowedCharacters:(NSCharacterSet *)allowedCharacters API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

// Returns a new string made from the receiver by replacing all percent encoded sequences with the matching UTF-8 characters.
@property (nullable, readonly, copy) NSString *stringByRemovingPercentEncoding API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));


- (nullable NSString *)stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)enc API_DEPRECATED("Use -stringByAddingPercentEncodingWithAllowedCharacters: instead, which always uses the recommended UTF-8 encoding, and which encodes for a specific URL component or subcomponent since each URL component or subcomponent has different rules for what characters are valid.", macos(10.0,10.11), ios(2.0,9.0), watchos(2.0,2.0), tvos(9.0,9.0));
- (nullable NSString *)stringByReplacingPercentEscapesUsingEncoding:(NSStringEncoding)enc API_DEPRECATED("Use -stringByRemovingPercentEncoding instead, which always uses the recommended UTF-8 encoding.", macos(10.0,10.11), ios(2.0,9.0), watchos(2.0,2.0), tvos(9.0,9.0));

@end

@interface NSURL (NSURLPathUtilities)
    
/* The following methods work on the path portion of a URL in the same manner that the NSPathUtilities methods on NSString do.
 */
+ (nullable NSURL *)fileURLWithPathComponents:(NSArray<NSString *> *)components API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
@property (nullable, readonly, copy) NSArray<NSString *> *pathComponents API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
@property (nullable, readonly, copy) NSString *lastPathComponent API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
@property (nullable, readonly, copy) NSString *pathExtension API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

- (nullable NSURL *)URLByAppendingPathComponent:(NSString *)pathComponent API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
- (nullable NSURL *)URLByAppendingPathComponent:(NSString *)pathComponent isDirectory:(BOOL)isDirectory API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));
@property (nullable, readonly, copy) NSURL *URLByDeletingLastPathComponent API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
- (nullable NSURL *)URLByAppendingPathExtension:(NSString *)pathExtension API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
@property (nullable, readonly, copy) NSURL *URLByDeletingPathExtension API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

/* The following methods work only on `file:` scheme URLs; for non-`file:` scheme URLs, these methods return the URL unchanged.
 */
@property (nullable, readonly, copy) NSURL *URLByStandardizingPath API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
@property (nullable, readonly, copy) NSURL *URLByResolvingSymlinksInPath API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

@end
//  URL 的集合方法



API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0))
@interface NSFileSecurity : NSObject <NSCopying, NSSecureCoding>
- (nullable instancetype) initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;
@end


/* deprecated interfaces 过期的接口
 */

#if TARGET_OS_OSX
/* NSURLClient and NSURLLoading are deprecated; use NSURLConnection instead.
 */

/* Client informal protocol for use with the deprecated loadResourceDataNotifyingClient: below.
 */
#if !defined(SWIFT_CLASS_EXTRA)
@interface NSObject (NSURLClient)
- (void)URL:(NSURL *)sender resourceDataDidBecomeAvailable:(NSData *)newBytes API_DEPRECATED("Use NSURLConnection instead", macos(10.0,10.4), ios(2.0,2.0), watchos(2.0,2.0), tvos(9.0,9.0));
- (void)URLResourceDidFinishLoading:(NSURL *)sender API_DEPRECATED("Use NSURLConnection instead", macos(10.0,10.4), ios(2.0,2.0), watchos(2.0,2.0), tvos(9.0,9.0));
- (void)URLResourceDidCancelLoading:(NSURL *)sender API_DEPRECATED("Use NSURLConnection instead", macos(10.0,10.4), ios(2.0,2.0), watchos(2.0,2.0), tvos(9.0,9.0));
- (void)URL:(NSURL *)sender resourceDidFailLoadingWithReason:(NSString *)reason API_DEPRECATED("Use NSURLConnection instead", macos(10.0,10.4), ios(2.0,2.0), watchos(2.0,2.0), tvos(9.0,9.0));
@end
#endif

@interface NSURL (NSURLLoading)
- (nullable NSData *)resourceDataUsingCache:(BOOL)shouldUseCache API_DEPRECATED("Use NSURLConnection instead", macos(10.0,10.4), ios(2.0,2.0), watchos(2.0,2.0), tvos(9.0,9.0)); // Blocks to load the data if necessary.  If shouldUseCache is YES, then if an equivalent URL has already been loaded and cached, its resource data will be returned immediately.  If shouldUseCache is NO, a new load will be started
- (void)loadResourceDataNotifyingClient:(id)client usingCache:(BOOL)shouldUseCache API_DEPRECATED("Use NSURLConnection instead", macos(10.0,10.4), ios(2.0,2.0), watchos(2.0,2.0), tvos(9.0,9.0)); // Starts an asynchronous load of the data, registering delegate to receive notification.  Only one such background load can proceed at a time.
- (nullable id)propertyForKey:(NSString *)propertyKey API_DEPRECATED("Use NSURLConnection instead", macos(10.0,10.4), ios(2.0,2.0), watchos(2.0,2.0), tvos(9.0,9.0));

/* These attempt to write the given arguments for the resource specified by the URL; they return success or failure
 */
- (BOOL)setResourceData:(NSData *)data API_DEPRECATED("Use NSURLConnection instead", macos(10.0,10.4), ios(2.0,2.0), watchos(2.0,2.0), tvos(9.0,9.0));
- (BOOL)setProperty:(id)property forKey:(NSString *)propertyKey API_DEPRECATED("Use NSURLConnection instead", macos(10.0,10.4), ios(2.0,2.0), watchos(2.0,2.0), tvos(9.0,9.0));

- (nullable NSURLHandle *)URLHandleUsingCache:(BOOL)shouldUseCache API_DEPRECATED("Use NSURLConnection instead", macos(10.0,10.4), ios(2.0,2.0), watchos(2.0,2.0), tvos(9.0,9.0)); // Sophisticated clients will want to ask for this, then message the handle directly.  If shouldUseCache is NO, a newly instantiated handle is returned, even if an equivalent URL has been loaded
@end


```
        NSURL *baseURL = [NSURL URLWithString:@"http://example.com/v1/"];
//        Now:
        NSURL *url = [NSURL URLWithString:@"foo" relativeToURL:baseURL];
        // Will give us http://example.com/v1/foo
        url =[NSURL URLWithString:@"foo?bar=baz" relativeToURL:baseURL];
        // -> http://example.com/v1/foo?bar=baz
        url =[NSURL URLWithString:@"/foo" relativeToURL:baseURL];
        // -> http://example.com/foo
        url =[NSURL URLWithString:@"foo/" relativeToURL:baseURL];
        // -> http://example.com/v1/foo
        url =[NSURL URLWithString:@"/foo/" relativeToURL:baseURL];
        // -> http://example.com/foo/
        url =[NSURL URLWithString:@"http://example2.com/" relativeToURL:baseURL];
        // -> http://example2.com/
                NSLog(@"url :%@",url);
            这个例子，可以查看一个baseURl的内容

```

PS：
1）其实URL就是和资源相关的操作， 
2）书签有关的内容
3）
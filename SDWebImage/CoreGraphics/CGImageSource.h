/* Create an image source reading from `data'.  The `options' dictionary
 * may be used to request additional creation options; see the list of keys
 * above for more information. */
// 通过data来创建ImageSource
IMAGEIO_EXTERN CGImageSourceRef _iio_Nullable CGImageSourceCreateWithData(CFDataRef _iio_Nonnull data, CFDictionaryRef _iio_Nullable options) IMAGEIO_AVAILABLE_STARTING(10.4, 4.0);

/* Set the next image in the image destination `idst' to be `image' with
 * optional properties specified in `properties'.  An error is logged if
 * more images are added than specified in the original count of the image
 * destination. */

IMAGEIO_EXTERN void CGImageDestinationAddImage(CGImageDestinationRef _iio_Nonnull idst, CGImageRef _iio_Nonnull image, CFDictionaryRef _iio_Nullable properties)  IMAGEIO_AVAILABLE_STARTING(10.4, 4.0);

/** Keys for the options dictionary of
 ** "CGImageSourceCreateThumbnailAtIndex". **/

/* Specifies whether a thumbnail should be automatically created for an
 * image if a thumbnail isn't present in the image source file.  The
 * thumbnail will be created from the full image, subject to the limit
 * specified by kCGImageSourceThumbnailMaxPixelSize---if a maximum pixel
 * size isn't specified, then the thumbnail will be the size of the full
 * image, which probably isn't what you want. The value of this key must be
 * a CFBooleanRef; the default value of this key is kCFBooleanFalse. */

IMAGEIO_EXTERN const CFStringRef kCGImageSourceCreateThumbnailFromImageIfAbsent  IMAGEIO_AVAILABLE_STARTING(10.4, 4.0);


//  创建图像的基本过程， 通过url， data， provider的方式
/* Create an image source reading from the data provider `provider'. The
 * `options' dictionary may be used to request additional creation options;
 * see the list of keys above for more information. */

IMAGEIO_EXTERN CGImageSourceRef _iio_Nullable CGImageSourceCreateWithDataProvider(CGDataProviderRef _iio_Nonnull provider, CFDictionaryRef _iio_Nullable options) IMAGEIO_AVAILABLE_STARTING(10.4, 4.0);

/* Create an image source reading from `data'.  The `options' dictionary
 * may be used to request additional creation options; see the list of keys
 * above for more information. */

IMAGEIO_EXTERN CGImageSourceRef _iio_Nullable CGImageSourceCreateWithData(CFDataRef _iio_Nonnull data, CFDictionaryRef _iio_Nullable options) IMAGEIO_AVAILABLE_STARTING(10.4, 4.0);

/* Create an image source reading from `url'. The `options' dictionary may
 * be used to request additional creation options; see the list of keys
 * above for more information. */

IMAGEIO_EXTERN CGImageSourceRef _iio_Nullable CGImageSourceCreateWithURL(CFURLRef _iio_Nonnull url, CFDictionaryRef _iio_Nullable options) IMAGEIO_AVAILABLE_STARTING(10.4, 4.0);

// 有关的内容处理过程
// 
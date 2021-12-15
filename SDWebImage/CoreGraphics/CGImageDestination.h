
/* Write everything to the destination data, url or consumer of the image
 * destination `idst'.  You must call this function or the image
 * destination will not be valid.  After this function is called, no
 * additional data will be written to the image destination.  Return true
 * if the image was successfully written; false otherwise. */
// 最后的目标图片
IMAGEIO_EXTERN bool CGImageDestinationFinalize(CGImageDestinationRef _iio_Nonnull idst)  IMAGEIO_AVAILABLE_STARTING(10.4, 4.0);

/* Create an image destination writing to `data'. The parameter `type'
 * specifies the type identifier of the resulting image file.  Constants for
 * `type' are found in the LaunchServices framework header UTCoreTypes.h.  The
 * parameter `count' specifies number of images (not including thumbnails)
 * that the image file will contain. The `options' dictionary is reserved
 * for future use; currently, you should pass NULL for this parameter. */

IMAGEIO_EXTERN CGImageDestinationRef _iio_Nullable CGImageDestinationCreateWithData(CFMutableDataRef _iio_Nonnull data, CFStringRef _iio_Nonnull type, size_t count, CFDictionaryRef _iio_Nullable options)  IMAGEIO_AVAILABLE_STARTING(10.4, 4.0);







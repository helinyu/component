// SDWebImageIndicator

#import "SDWebImageCompat.h"

#if SD_UIKIT || SD_MAC

//  菊花的内容展示， 这些内容的展示结果

/**
 A protocol to custom the indicator during the image loading.
 All of these methods are called from main queue.
 */
@protocol SDWebImageIndicator <NSObject>

@required
/**
 The view associate to the indicator.

 @return The indicator view
 */
@property (nonatomic, strong, readonly, nonnull) UIView *indicatorView;

/**
 Start the animating for indicator.
 */
- (void)startAnimatingIndicator;

/**
 Stop the animating for indicator.
 */
- (void)stopAnimatingIndicator;

@optional
/**
 Update the loading progress (0-1.0) for indicator. Optional
 
 @param progress The progress, value between 0 and 1.0
 */
- (void)updateIndicatorProgress:(double)progress;

@end

#pragma mark - Activity Indicator

/**
 Activity indicator class.
 for UIKit(macOS), it use a `UIActivityIndicatorView`.
 for AppKit(macOS), it use a `NSProgressIndicator` with the spinning style.
 */
@interface SDWebImageActivityIndicator : NSObject <SDWebImageIndicator>

#if SD_UIKIT
@property (nonatomic, strong, readonly, nonnull) UIActivityIndicatorView *indicatorView;
#else
@property (nonatomic, strong, readonly, nonnull) NSProgressIndicator *indicatorView;
#endif

@end

/**
 Convenience way to use activity indicator.
 */
@interface SDWebImageActivityIndicator (Conveniences)

/// These indicator use the fixed color without dark mode support
/// gray-style activity indicator
@property (nonatomic, class, nonnull, readonly) SDWebImageActivityIndicator *grayIndicator;
/// large gray-style activity indicator
@property (nonatomic, class, nonnull, readonly) SDWebImageActivityIndicator *grayLargeIndicator;
/// white-style activity indicator
@property (nonatomic, class, nonnull, readonly) SDWebImageActivityIndicator *whiteIndicator;
/// large white-style activity indicator
@property (nonatomic, class, nonnull, readonly) SDWebImageActivityIndicator *whiteLargeIndicator;
/// These indicator use the system style, supports dark mode if available (iOS 13+/macOS 10.14+)
/// large activity indicator
@property (nonatomic, class, nonnull, readonly) SDWebImageActivityIndicator *largeIndicator;
/// medium activity indicator
@property (nonatomic, class, nonnull, readonly) SDWebImageActivityIndicator *mediumIndicator;

@end

#pragma mark - Progress Indicator

/**
 Progress indicator class.
 for UIKit(macOS), it use a `UIProgressView`.
 for AppKit(macOS), it use a `NSProgressIndicator` with the bar style.
 */
@interface SDWebImageProgressIndicator : NSObject <SDWebImageIndicator>

#if SD_UIKIT
@property (nonatomic, strong, readonly, nonnull) UIProgressView *indicatorView;
#else
@property (nonatomic, strong, readonly, nonnull) NSProgressIndicator *indicatorView;
#endif

@end

/**
 Convenience way to create progress indicator. Remember to specify the indicator width or use layout constraint if need.
 */
@interface SDWebImageProgressIndicator (Conveniences)

/// default-style progress indicator
@property (nonatomic, class, nonnull, readonly) SDWebImageProgressIndicator *defaultIndicator;
/// bar-style progress indicator
@property (nonatomic, class, nonnull, readonly) SDWebImageProgressIndicator *barIndicator API_UNAVAILABLE(macos, tvos);

@end

#endif



@interface SDWebImageActivityIndicator ()

#if SD_UIKIT
@property (nonatomic, strong, readwrite, nonnull) UIActivityIndicatorView *indicatorView;
#else
@property (nonatomic, strong, readwrite, nonnull) NSProgressIndicator *indicatorView;
#endif

@end

@implementation SDWebImageActivityIndicator

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

#if SD_UIKIT
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)commonInit {
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
}
#pragma clang diagnostic pop
#endif

#if SD_MAC
- (void)commonInit {
    self.indicatorView = [[NSProgressIndicator alloc] initWithFrame:NSZeroRect];
    self.indicatorView.style = NSProgressIndicatorStyleSpinning;
    self.indicatorView.controlSize = NSControlSizeSmall;
    [self.indicatorView sizeToFit];
    self.indicatorView.autoresizingMask = NSViewMaxXMargin | NSViewMinXMargin | NSViewMaxYMargin | NSViewMinYMargin;
}
#endif

- (void)startAnimatingIndicator {
#if SD_UIKIT
    [self.indicatorView startAnimating];
#else
    [self.indicatorView startAnimation:nil];
#endif
    self.indicatorView.hidden = NO;
}

- (void)stopAnimatingIndicator {
#if SD_UIKIT
    [self.indicatorView stopAnimating];
#else
    [self.indicatorView stopAnimation:nil];
#endif
    self.indicatorView.hidden = YES;
}

@end

@implementation SDWebImageActivityIndicator (Conveniences)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+ (SDWebImageActivityIndicator *)grayIndicator {
    SDWebImageActivityIndicator *indicator = [SDWebImageActivityIndicator new];
#if SD_UIKIT
#if SD_IOS
    indicator.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
#else
    indicator.indicatorView.color = [UIColor colorWithWhite:0 alpha:0.45]; // Color from `UIActivityIndicatorViewStyleGray`
#endif
#else
    indicator.indicatorView.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua]; // Disable dark mode support
#endif
    return indicator;
}

+ (SDWebImageActivityIndicator *)grayLargeIndicator {
    SDWebImageActivityIndicator *indicator = SDWebImageActivityIndicator.grayIndicator;
#if SD_UIKIT
    UIColor *grayColor = indicator.indicatorView.color;
    indicator.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.indicatorView.color = grayColor;
#else
    indicator.indicatorView.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua]; // Disable dark mode support
    indicator.indicatorView.controlSize = NSControlSizeRegular;
#endif
    [indicator.indicatorView sizeToFit];
    return indicator;
}

+ (SDWebImageActivityIndicator *)whiteIndicator {
    SDWebImageActivityIndicator *indicator = [SDWebImageActivityIndicator new];
#if SD_UIKIT
    indicator.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
#else
    indicator.indicatorView.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua]; // Disable dark mode support
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setDefaults];
    [lighten setValue:@(1) forKey:kCIInputBrightnessKey];
    indicator.indicatorView.contentFilters = @[lighten];
#endif
    return indicator;
}

+ (SDWebImageActivityIndicator *)whiteLargeIndicator {
    SDWebImageActivityIndicator *indicator = SDWebImageActivityIndicator.whiteIndicator;
#if SD_UIKIT
    indicator.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
#else
    indicator.indicatorView.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua]; // Disable dark mode support
    indicator.indicatorView.controlSize = NSControlSizeRegular;
    [indicator.indicatorView sizeToFit];
#endif
    return indicator;
}

+ (SDWebImageActivityIndicator *)largeIndicator {
    SDWebImageActivityIndicator *indicator = [SDWebImageActivityIndicator new];
#if SD_UIKIT
    if (@available(iOS 13.0, tvOS 13.0, *)) {
        indicator.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
    } else {
        indicator.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    }
#else
    indicator.indicatorView.controlSize = NSControlSizeRegular;
    [indicator.indicatorView sizeToFit];
#endif
    return indicator;
}

+ (SDWebImageActivityIndicator *)mediumIndicator {
    SDWebImageActivityIndicator *indicator = [SDWebImageActivityIndicator new];
#if SD_UIKIT
    if (@available(iOS 13.0, tvOS 13.0, *)) {
        indicator.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
    } else {
        indicator.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
#else
    indicator.indicatorView.controlSize = NSControlSizeSmall;
    [indicator.indicatorView sizeToFit];
#endif
    return indicator;
}
#pragma clang diagnostic pop

@end

#pragma mark - Progress Indicator

@interface SDWebImageProgressIndicator ()

#if SD_UIKIT
@property (nonatomic, strong, readwrite, nonnull) UIProgressView *indicatorView;
#else
@property (nonatomic, strong, readwrite, nonnull) NSProgressIndicator *indicatorView;
#endif

@end

@implementation SDWebImageProgressIndicator

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

#if SD_UIKIT
- (void)commonInit {
    self.indicatorView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
}
#endif

#if SD_MAC
- (void)commonInit {
    self.indicatorView = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(0, 0, 160, 0)]; // Width from `UIProgressView` default width
    self.indicatorView.style = NSProgressIndicatorStyleBar;
    self.indicatorView.controlSize = NSControlSizeSmall;
    [self.indicatorView sizeToFit];
    self.indicatorView.autoresizingMask = NSViewMaxXMargin | NSViewMinXMargin | NSViewMaxYMargin | NSViewMinYMargin;
}
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
- (void)startAnimatingIndicator {
    self.indicatorView.hidden = NO;
#if SD_UIKIT
    if ([self.indicatorView respondsToSelector:@selector(observedProgress)] && self.indicatorView.observedProgress) {
        // Ignore NSProgress
    } else {
        self.indicatorView.progress = 0;
    }
#else
    self.indicatorView.indeterminate = YES;
    self.indicatorView.doubleValue = 0;
    [self.indicatorView startAnimation:nil];
#endif
}

- (void)stopAnimatingIndicator {
    self.indicatorView.hidden = YES;
#if SD_UIKIT
    if ([self.indicatorView respondsToSelector:@selector(observedProgress)] && self.indicatorView.observedProgress) {
        // Ignore NSProgress
    } else {
        self.indicatorView.progress = 1;
    }
#else
    self.indicatorView.indeterminate = NO;
    self.indicatorView.doubleValue = 100;
    [self.indicatorView stopAnimation:nil];
#endif
}

- (void)updateIndicatorProgress:(double)progress {
#if SD_UIKIT
    if ([self.indicatorView respondsToSelector:@selector(observedProgress)] && self.indicatorView.observedProgress) {
        // Ignore NSProgress
    } else {
        [self.indicatorView setProgress:progress animated:YES];
    }
#else
    self.indicatorView.indeterminate = progress > 0 ? NO : YES;
    self.indicatorView.doubleValue = progress * 100;
#endif
}
#pragma clang diagnostic pop

@end

@implementation SDWebImageProgressIndicator (Conveniences)

+ (SDWebImageProgressIndicator *)defaultIndicator {
    SDWebImageProgressIndicator *indicator = [SDWebImageProgressIndicator new];
    return indicator;
}

#if SD_IOS
+ (SDWebImageProgressIndicator *)barIndicator {
    SDWebImageProgressIndicator *indicator = [SDWebImageProgressIndicator new];
    indicator.indicatorView.progressViewStyle = UIProgressViewStyleBar;
    return indicator;
}
#endif

@end

#endif

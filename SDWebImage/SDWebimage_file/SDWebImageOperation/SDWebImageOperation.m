#import <Foundation/Foundation.h>

//  操作的基本接口
@protocol SDWebImageOperation <NSObject>

- (void)cancel;

@end
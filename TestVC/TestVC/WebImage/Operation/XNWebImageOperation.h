//
//  SDWebImageOperation.h
//  TestVC
//
//  Created by xn on 2021/12/22.
//

#import <Foundation/Foundation.h>

// 定义这个接口，这个接口操作包括了NSOPeration，里面主要是调用了cancel方法，统一处理
@protocol XNWebImageOperation <NSObject>

- (void)cancel;

@end

@interface NSOperation (XNWebImageOperation)<XNWebImageOperation>

@end

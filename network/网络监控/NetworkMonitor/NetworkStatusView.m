//
//  NetworkStatusView.m
//  NetworkMonitor
//
//  Created by Cjh on 2020/9/18.
//  Copyright © 2020 CJH. All rights reserved.
//

#import "NetworkStatusView.h"
#import "NetworkMonitor.h"

@implementation NetworkStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self startMonitor];
        [self setNeedsDisplay];
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGAction:)];
    [self.superview addGestureRecognizer:panG];
}

- (void)setupView
{
    [self addSubview:self.lb_network];
}

- (void)panGAction:(UIPanGestureRecognizer *)panG
{
    UIGestureRecognizerState state = panG.state;
    switch (state) {
        case UIGestureRecognizerStateChanged:
        {
            CGPoint mPoint = [panG locationInView:self.superview];
            self.frame = CGRectMake(mPoint.x, mPoint.y, self.frame.size.width, self.frame.size.height);
        }
            break;
            
        default:
            break;
    }
}

- (void)startMonitor
{
    [[NetworkMonitor shareInstance] networkMonitorSpeed:^(float inStream, float outStream) {
        if (inStream < 1024.0) {
            self.lb_network.backgroundColor = [UIColor redColor];
        }else if (inStream < 1024.0*1024.0) {
            self.lb_network.backgroundColor = [UIColor orangeColor];
        }else{
            self.lb_network.backgroundColor = [UIColor greenColor];
        }
//        NSString *inStreamStr = [self formatNetworkSpeed:inStream];
//        NSString *outStramStr = [self formatNetworkSpeed:outStream];
        self.lb_network.text = [self formatNetworkSpeed:inStream];
    }];
}

- (NSString *)formatNetworkSpeed:(uint32_t)flow
{
    NSString *speed = @"0.00 b/s";
    if (flow >= 1024 * 1024 * 1024) {
        speed = [NSString stringWithFormat:@"%.2f g/s",flow / (1024 * 1024 * 1024.0)];
    }else if (flow >= 1024 * 1024) {
        speed = [NSString stringWithFormat:@"%.2f m/s",flow / (1024 * 1024.0)];
    }else if (flow >= 1024){
        speed = [NSString stringWithFormat:@"%.2f k/s",flow / 1024.0];
    }else{
        speed = [NSString stringWithFormat:@"%.2f b/s",flow / 1.0];
    }
    return speed;
}


#pragma mark - property
- (UILabel *)lb_network
{
    if (!_lb_network) {
        _lb_network = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _lb_network.textColor = [UIColor whiteColor];
        _lb_network.textAlignment = NSTextAlignmentCenter;
        _lb_network.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
        _lb_network.layer.cornerRadius = self.bounds.size.width/2.0;
        _lb_network.layer.masksToBounds = YES;
    }
    return _lb_network;
}

@end

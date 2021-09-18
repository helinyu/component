//
//  CanvasViewController.m
//  TestVC
//
//  Created by xn on 2021/9/6.
//

#import "CanvasViewController.h"
#import "CanvasViewGenerator.h"
#import "CanvasView.h"

@interface CanvasViewController ()

@property (nonatomic, strong) CanvasView *canvasView;

@end

@implementation CanvasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CanvasViewGenerator *defaultGenerator = [[CanvasViewGenerator alloc] init];
    [self loadCanvasViewWithGenerator:defaultGenerator];
}

- (void)loadCanvasViewWithGenerator:(CanvasViewGenerator *)generator {
    [self.canvasView removeFromSuperview];
    
    CGRect aFrame = CGRectMake(0.f, 0.f, self.view.bounds.size.width, self.view.bounds.size.height);
    CanvasView *aCanvasView = [generator canvasViewWithFrame:aFrame];
    [self setCanvasView:aCanvasView];
    [[self view] addSubview:aCanvasView];
}

@end

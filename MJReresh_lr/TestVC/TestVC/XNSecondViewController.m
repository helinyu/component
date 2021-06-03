//
//  XNSecondViewController.m
//  TestVC
//
//  Created by xn on 2021/5/27.
//

#import "XNSecondViewController.h"
#import "XNCustomTwoView.h"
#import "MJRefreshView.h"
#import "MJRefreshAutoNormalFooter.h"
#import "TestCollectionViewCell.h"

#define weakself(self)  __weak __typeof(self) weakSelf = self
#define strongself(self)  __strong __typeof(self) self = weakSelf

@interface XNSecondViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, strong) NSArray *colors;

@end

@implementation XNSecondViewController

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray new];
    }
    return _datasource;
}

- (void)addMoreData {
    for (NSInteger index =0; index <10; index++) {
        [self.datasource addObject:@(index)];
    }
    _count +=1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        self.colors = @[[UIColor redColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor greenColor],[UIColor blackColor]];
    }
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0.f, 0.f, 50.f, 30.f);
        btn.backgroundColor = [UIColor redColor];
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"你好" style:UIBarButtonItemStylePlain target:self action:@selector(onTeest)];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    
//    {
//        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        [self.view addSubview:tableView];
//        tableView.backgroundColor = [UIColor grayColor];
//        tableView.dataSource = self;
//        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
//        self.tableView = tableView;
//
//        weakself(self);
//        self.tableView.more_refreshView = [MJRefreshAutoNormalFooter refreshViewWithBlock:^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                strongself(self);
//                [self addMoreData];
//                [self.tableView.more_refreshView endRefreshing];
//                [self.tableView reloadData];
//            });
//        } refreshMore:YES refreshBack:NO];
//    }
    
    {
        [self addMoreData];
        UICollectionViewFlowLayout *viewLayout = [UICollectionViewFlowLayout new];
        viewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:viewLayout];
        [self.view addSubview:collectionView];
        collectionView.backgroundColor = [UIColor grayColor];
        [collectionView registerClass:[TestCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([TestCollectionViewCell class])];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        self.collectionView = collectionView;
        
        weakself(self);
        self.collectionView.reset_refreshView = [MJRefreshAutoNormalFooter refreshViewWithBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                strongself(self);
                self.count += 1;
                [self.collectionView.reset_refreshView endRefreshing];
                self.currentColor = [self.colors objectAtIndex:(self.count%(self.colors.count))];
                [self.collectionView reloadData];
            });
        } refreshMore:NO refreshBack:NO horizontalDirection:YES];
        
        self.collectionView.more_refreshView =[MJRefreshAutoNormalFooter refreshViewWithBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                strongself(self);
                [self addMoreData];
                [self.collectionView.more_refreshView endRefreshing];
//                 这里触发有关的内容进行实现这个功能；
                self.currentColor = [self.colors objectAtIndex:(self.count%(self.colors.count))];
                [self.collectionView reloadData];
            });
        } refreshMore:YES refreshBack:NO horizontalDirection:YES];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TestCollectionViewCell class]) forIndexPath:indexPath];
    cell.contentView.backgroundColor = self.currentColor;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100.f, 100.f);
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.datasource.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
//
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.datasource objectAtIndex:indexPath.row]];
//    return cell;
//}

- (void)onTeest {
    self.tableView.contentInset = UIEdgeInsetsMake(100.f, 0.f, 10.f, 10.f);
}

- (void)dealloc {
}


@end

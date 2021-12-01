//
//  NetworkViewController.m
//  NetworkMonitor
//
//  Created by Cjh on 2020/9/18.
//  Copyright © 2020 CJH. All rights reserved.
//

#import "NetworkViewController.h"
#import "NetworkTableViewCell.h"
#import "NetworkMonitor.h"

@interface NetworkViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, copy)NSArray *dataSource;

@end

@implementation NetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"接口监测";
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [UIView new];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass(NetworkTableViewCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(NetworkTableViewCell.class)];
    
    
    NSMutableArray *tarr = [[NSMutableArray alloc] init];
    for (NSString *key in [NetworkMonitor shareInstance].dataSource.keyEnumerator) {
        @autoreleasepool {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:key forKey:@"url"];
            [dict setObject:[[NetworkMonitor shareInstance].statusSource objectForKey:key] forKey:@"status"];
            NSNumber *tnumber = [NetworkMonitor shareInstance].dataSource[key];
            [dict setObject:[NSString stringWithFormat:@"时长：%.2fs",tnumber.floatValue/1000] forKey:@"urlDes"];
            [tarr addObject:dict];
        }
    }
    self.dataSource = tarr;
}

#pragma mark - setter
- (void)setDataSource:(NSArray *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        
        //刷新
        [self.tableview reloadData];
    }
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NetworkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(NetworkTableViewCell.class)];
    cell.lb_url.text = self.dataSource[indexPath.row][@"url"];
    cell.lb_urlDes.text = self.dataSource[indexPath.row][@"urlDes"];
    NSString *status = self.dataSource[indexPath.row][@"status"];
    if ([status isEqualToString:@"0"]) {
        cell.lb_status.text = @"failure";
        cell.lb_status.textColor = [UIColor redColor];
    }else{
        cell.lb_status.text = @"success";
        cell.lb_status.textColor = [UIColor greenColor];
    }
    return cell;
}



@end

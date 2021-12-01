//
//  NetworkTableViewCell.h
//  NetworkMonitor
//
//  Created by Cjh on 2020/9/18.
//  Copyright © 2020 CJH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_url;
@property (weak, nonatomic) IBOutlet UILabel *lb_status;
@property (weak, nonatomic) IBOutlet UILabel *lb_urlDes;

@end

NS_ASSUME_NONNULL_END

//
//  LECartCell.h
//  eFruit
//
//  Created by Eda on 15/12/28.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LESubOrder.h"
@interface LEOrderCell : UITableViewCell
@property (nonatomic, strong) LESubOrder *subOrder;
+(instancetype)orderCellWithTableView:(UITableView *)tableView;
@end

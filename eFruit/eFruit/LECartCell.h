//
//  LECartCell.h
//  eFruit
//
//  Created by Eda on 15/12/28.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECart.h"
@interface LECartCell : UITableViewCell
@property (nonatomic, strong) LECart *cart;
+(instancetype)cartCellWithTableView:(UITableView *)tableView;
@end

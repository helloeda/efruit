//
//  LEGoodsCell.h
//  Tuan
//
//  Created by Eda on 15/10/25.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LEGoods;
@interface LEGoodsCell : UITableViewCell
@property (nonatomic, strong) LEGoods *goods;

+ (instancetype)goodsCellWithTableView:(UITableView *)tableView;

@end

//
//  LECartCell.m
//  eFruit
//
//  Created by Eda on 15/12/28.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "LEOrderCell.h"
#import "LESubOrder.h"
#import "UIImageView+WebCache.h"
@interface LEOrderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblFruitName;
@property (weak, nonatomic) IBOutlet UILabel *lblFruitPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblQuantity;

@end

@implementation LEOrderCell



- (void)setSubOrder:(LESubOrder *)subOrder
{
    _subOrder = subOrder;
    self.lblFruitName.text = subOrder.fruitName;
    self.lblFruitPrice.text = [NSString stringWithFormat:@"¥ %@",subOrder.fruitPrice];
    self.lblQuantity.text = [NSString stringWithFormat:@"X%@",subOrder.fruitQuantity];
    
    [self.imgViewIcon sd_setImageWithURL:[NSURL URLWithString:subOrder.fruitImage] placeholderImage:[UIImage imageNamed:@"fruit_default"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
      } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //        NSLog(@"%@", [NSThread currentThread]);
    }];
}


+(instancetype)orderCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"order_cell";
    LEOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LEOrderCell" owner:nil options:nil] firstObject];
    }
    return cell;
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end

//
//  LEGoodsCell.m
//  Tuan
//
//  Created by Eda on 15/10/25.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "LEGoodsCell.h"
#import "LEGoods.h"
@interface LEGoodsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblBuyCount;


@end

@implementation LEGoodsCell


- (void)setGoods:(LEGoods *)goods
{
    _goods = goods;
    self.imgViewIcon.image = [UIImage imageNamed:goods.icon];
    self.lblTitle.text = goods.title;
    self.lblPrice.text = [NSString stringWithFormat:@"¥ %@",goods.price];
    self.lblBuyCount.text = [NSString stringWithFormat:@"%@ 人已经购买",goods.buyCount];
}


+(instancetype)goodsCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"goods_cell";
    LEGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LEGoodsCell" owner:nil options:nil] firstObject];
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

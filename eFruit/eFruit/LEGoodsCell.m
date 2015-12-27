//
//  LEGoodsCell.m
//  Tuan
//
//  Created by Eda on 15/10/25.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "LEGoodsCell.h"
#import "LEGoods.h"
#import "UIImageView+WebCache.h"
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
    self.lblTitle.text = goods.fruitName;
    self.lblPrice.text = [NSString stringWithFormat:@"¥ %@",goods.fruitPrice];
    self.lblBuyCount.text = [NSString stringWithFormat:@"%@ 人已经购买",goods.fruitSales];
    
    [self.imgViewIcon sd_setImageWithURL:[NSURL URLWithString:goods.fruitImage] placeholderImage:[UIImage imageNamed:@"user_default"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // receivedSize 已经接受到的大小
        // expectedSize 期望的大小，总大小
//        float progress = (float)receivedSize/expectedSize;
//        NSLog(@"下载进度 %f", progress);
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        NSLog(@"%@", [NSThread currentThread]);
    }];
    
    
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

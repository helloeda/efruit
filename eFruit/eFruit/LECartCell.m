//
//  LECartCell.m
//  eFruit
//
//  Created by Eda on 15/12/28.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "LECartCell.h"
#import "UIImageView+WebCache.h"
@interface LECartCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblFruitName;
@property (weak, nonatomic) IBOutlet UILabel *lblFruitPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblNum;
- (IBAction)btnPlus;
- (IBAction)btnSub;

@end

@implementation LECartCell



- (void)setCart:(LECart *)cart
{
    _cart = cart;
    self.lblFruitName.text = cart.good.fruitName;
    self.lblFruitPrice.text = [NSString stringWithFormat:@"¥ %@",cart.good.fruitPrice];
    self.lblNum.text = [NSString stringWithFormat:@"%d",cart.num];
    
    [self.imgViewIcon sd_setImageWithURL:[NSURL URLWithString:cart.good.fruitImage] placeholderImage:[UIImage imageNamed:@"fruit_default"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
      } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //        NSLog(@"%@", [NSThread currentThread]);
    }];
}


+(instancetype)cartCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cart_cell";
    LECartCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LECartCell" owner:nil options:nil] firstObject];
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

- (IBAction)btnPlus {
    
    self.cart.num++;
    self.lblNum.text = [NSString stringWithFormat:@"%d",self.cart.num];
}

- (IBAction)btnSub {
    
    if (self.cart.num > 0) {
        self.cart.num--;
        self.lblNum.text = [NSString stringWithFormat:@"%d",self.cart.num];
    }

}
@end

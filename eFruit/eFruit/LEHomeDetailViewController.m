//
//  LEHomeDetailViewController.m
//  eFruit
//
//  Created by Eda on 15/12/28.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "LEHomeDetailViewController.h"
#import "LEGoods.h"
#import "UIImageView+WebCache.h"
#import "LEGoodsCell.h"
#import "LECart.h"
#import "AppDelegate.h"
@interface LEHomeDetailViewController ()
- (IBAction)btnAddToCart;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblFruitName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblSales;
@property (weak, nonatomic) IBOutlet UITextView *textViewIntro;

@end

@implementation LEHomeDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品详情";
   
    [self.imgViewIcon sd_setImageWithURL:[NSURL URLWithString:self.good.fruitImage] placeholderImage:[UIImage imageNamed:@"fruit_default"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //        NSLog(@"%@", [NSThread currentThread]);
    }];
    self.lblFruitName.text = self.good.fruitName;
    self.lblPrice.text = self.good.fruitPrice;
    self.lblSales.text = self.good.fruitSales;
    self.textViewIntro.text = self.good.fruitIntro;

    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//return
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnAddToCart {
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    BOOL isInCarts = NO;
    //如果购物车里面已经有
    for (LECart *cart in myDelegate.carts) {
        if ([cart.good.fruitId isEqualToString:self.good.fruitId]) {
            cart.num ++;
            isInCarts = YES;
        }
    }
    if (isInCarts == NO) {
        LECart *cart = [[LECart alloc] init];
        cart.good = self.good;
        cart.num ++;
        NSMutableArray *carts = [NSMutableArray arrayWithArray: myDelegate.carts];
        [carts addObject:cart];
        myDelegate.carts = carts;
    }
    

 }
@end

//
//  LEGoods.h
//  Tuan
//
//  Created by Eda on 15/10/25.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEGoods : NSObject

@property (nonatomic, copy) NSString *fruitId;
@property (nonatomic, copy) NSString *fruitName;
@property (nonatomic, copy) NSString *fruitImage;
@property (nonatomic, copy) NSString *fruitIntro;
@property (nonatomic, copy) NSString *fruitPrice;
@property (nonatomic, copy) NSString *fruitSales;
@property (nonatomic, copy) NSString *fruitBuyable;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)goodsWithDict:(NSDictionary *)dict;





@end

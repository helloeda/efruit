//
//  LEGoods.h
//  Tuan
//
//  Created by Eda on 15/10/25.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEGoods : NSObject

@property (nonatomic, copy) NSString *buyCount;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)goodsWithDict:(NSDictionary *)dict;





@end

//
//  LESubOrder.h
//  eFruit
//
//  Created by Eda on 15/12/30.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LESubOrder : NSObject
@property (nonatomic, copy) NSString *fruitName;
@property (nonatomic, copy) NSString *fruitImage;
@property (nonatomic, copy) NSString *fruitPrice;
@property (nonatomic, copy) NSString *fruitQuantity;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)subOrderWithDict:(NSDictionary *)dict;


@end

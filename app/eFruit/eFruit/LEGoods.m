//
//  LEGoods.m
//  Tuan
//
//  Created by Eda on 15/10/25.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "LEGoods.h"

@implementation LEGoods


- (instancetype)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)goodsWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];

}


@end

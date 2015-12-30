//
//  LESubOrder.m
//  eFruit
//
//  Created by Eda on 15/12/30.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "LESubOrder.h"

@implementation LESubOrder
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)subOrderWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
}

@end

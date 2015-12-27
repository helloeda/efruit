//
//  LEUser.m
//  eFruit
//
//  Created by Eda on 15/12/25.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "LEUser.h"

@implementation LEUser

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)userWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
}
@end

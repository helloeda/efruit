//
//  LECart.h
//  eFruit
//
//  Created by Eda on 15/12/28.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEGoods.h"
@interface LECart : NSObject
@property (nonatomic, strong) LEGoods *good;
@property int num;

@end

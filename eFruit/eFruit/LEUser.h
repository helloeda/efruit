//
//  LEUser.h
//  eFruit
//
//  Created by Eda on 15/12/25.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEUser : NSObject
@property (nonatomic, copy) NSString *loginStatus;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *userBirth;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *userPassword;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *userIcon;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)userWithDict:(NSDictionary *)dict;



@end

//
//  AppDelegate.h
//  eFruit
//
//  Created by Eda on 15/11/30.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LEUser.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) LEUser *user; //全局变量保存用户信息
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end


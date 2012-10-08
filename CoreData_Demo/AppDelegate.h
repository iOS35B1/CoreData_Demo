//
//  AppDelegate.h
//  CoreData_Demo
//
//  Created by Ibokan on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//获取被管理文件上下文
//使用Core Data的框架，大多数的功能都可以自动实现，因为我们有managed object context（管理对象的上下文，有时直接叫"Context"）。managed object context就像是一个关卡，通过它可以访问框架底层的对象——这些对象的集合我们称之为"persistence stack"（数据持久栈）。 managed object context作为程序中对象和外部的数据存储的中转站。栈的底部是persistence object stores（持久化数据存储）

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//获取被管理文件模型

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;//获取持久化存储协调器

- (void)saveContext;//把上下为你中所做的修改保存到数据库
- (NSURL *)applicationDocumentsDirectory;//获取Documents目录

@end

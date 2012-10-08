//
//  Student.h
//  CoreData_Demo
//
//  Created by Ibokan on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//今天在iphon模拟器上调试程序，用CoreData存储自己的数据，遇到了一个恶心的问题。
//每次修改完 CoreData模型的属性后，重新Build 就出现下面的错误：
//
//The model used to open the store is incompatible with the one used to create the store
//
//Google 下找到了问题解决方法：删掉模拟器上的程序后 重新Build就好了

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Student : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * image;


@end

//
//  DetailedStudentViewController.h
//  CoreData_Demo
//
//  Created by Ibokan on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
@interface DetailedStudentViewController : UIViewController
{
    UILabel *_nameLabel;//姓名    
    UILabel *_ageLabel;//年龄
    UILabel *_birthdayLabel;//出生日期
    Student *_student;//student属性 用于传值
}
@property(nonatomic,strong )Student *student;
@property(nonatomic,strong )UILabel *nameLabel;
@property(nonatomic,strong )UILabel *ageLabel;
@property(nonatomic,strong )UILabel *birthdayLabel;
@end

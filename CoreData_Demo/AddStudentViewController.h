//
//  AddStudentViewController.h
//  CoreData_Demo
//
//  Created by Ibokan on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
@interface AddStudentViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UITextField *_nameTextField;//姓名
    UITextField *_ageTextField;//年龄
    UITextField *_birthdayTextField;//生日
    NSManagedObjectContext *managedObjectContext;//被管理对象上下文，这里添加学生时不再需要单例或是代理，用上下文操作就可以了
    UIImagePickerController *imagePicker;//图像选择器
    UIImageView *imageView;//显示照片
    UIImage *currentImage;//照片
    //NSString *filePath;//照片路径
}
@property(nonatomic,strong)UITextField *nameTextField,*ageTextField,*birthdayTextField;
@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext;
-(UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
@end

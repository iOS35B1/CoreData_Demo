//
//  AddStudentViewController.m
//  CoreData_Demo
//
//  Created by Ibokan on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AddStudentViewController.h"

@implementation AddStudentViewController
@synthesize nameTextField = _nameTextField,ageTextField = _ageTextField,birthdayTextField = _birthdayTextField,managedObjectContext;
-(void)dealloc
{
    [_birthdayTextField release];
    [_nameTextField release];
    [_ageTextField release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)]autorelease];
    //self.view.backgroundColor = [UIColor grayColor];
    NSString *path1 = [[NSBundle mainBundle]pathForResource:@"backg" ofType:@"jpg"];
    UIImage *backgroudImage =[UIImage imageWithContentsOfFile:path1];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backgroudImage]];
    id delegate = [[UIApplication sharedApplication] delegate];//设置代理为AppDelegate
    
    self.managedObjectContext = [delegate managedObjectContext];//调用delegate的方法得到managedObjectContext
    
    //界面配置
    UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 100, 30)];
    nameLbl.text = @"姓名";
    nameLbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nameLbl];
    [nameLbl release];
    
    self.nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 30, 200, 30)];
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextField.delegate = self;
    [self.view addSubview:self.nameTextField];
    
    UILabel *ageLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 100, 30)];
    ageLbl.text = @"年龄";
    ageLbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:ageLbl];
    [ageLbl release];
    
    self.ageTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 80, 200, 30)];
    self.ageTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.ageTextField.placeholder = @"0";
    self.ageTextField.delegate = self;
    [self.view addSubview:self.ageTextField];
    
    UILabel *birthdayLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 130, 100, 30)];
    birthdayLbl.text = @"出生年月";
    birthdayLbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:birthdayLbl];
    [birthdayLbl release];
    
    self.birthdayTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 130, 200, 30)];
    self.birthdayTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.birthdayTextField.placeholder = @"年-月-日";
    self.birthdayTextField.delegate = self;
    [self.view addSubview:self.birthdayTextField];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(addStudent)];
    self.navigationItem.rightBarButtonItem = right;
    
    
    UIButton *addButton  = [UIButton buttonWithType:UIButtonTypeCustom];//添加按钮 对应choicePhoto事件
    addButton.frame = CGRectMake(20, 200, 80, 40);
    [addButton setBackgroundColor:[UIColor greenColor]];
    [addButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [addButton setTitle:@"添加照片" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(choicePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];

}
-(void)choicePhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithFrame:CGRectMake(0, 250, 320, 460-44-250)];
    actionSheet.delegate = self;
    actionSheet.title = nil;
    [actionSheet addButtonWithTitle:@"拍照"];
    [actionSheet addButtonWithTitle:@"相册"];
    [actionSheet addButtonWithTitle:@"取消"];
    actionSheet.cancelButtonIndex = 2;
    [actionSheet showInView:self.view];
    

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex//UIActionSheet delegate
{
    if(buttonIndex == 2)
    {
        return;
    }
    imagePicker = [[UIImagePickerController alloc] init];//图像选取器
    imagePicker.delegate = self;
    //imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//打开相册
    //imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;//过渡类型,有四种
    imagePicker.allowsEditing = NO;//禁止对图片进行编辑
    if(buttonIndex == 0)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//打开照相机
        }
    }
    else if(buttonIndex == 1)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//打开相册
        }
    }
    [self presentModalViewController:imagePicker animated:YES];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];//获取图片
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) 
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//将拍到的图片保存到相册
    }
    
   currentImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(100, 100)];
    //    currentImage = image;
    
    //调用imageWithImageSimple:scaledToSize:方法
    
    [currentImage retain];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 200, 100, 100)];
    imageView.image = currentImage;  
    [self.view addSubview:imageView];
    //    rootImage = [UIImage imageNamed:@"110.png"];
//    imageView.image = rootImage;
//    [scrollerView addSubview:imageView];
//    [imageView release];
//    
//    seg.userInteractionEnabled = YES;
//    [self.view addSubview:rootImageView];
    [self dismissModalViewControllerAnimated:YES];//关闭模态视图控制器
}

-(UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);//根据当前大小创建一个基于位图图形的环境
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];//根据新的尺寸画出传过来的图片
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();//从当前环境当中得到重绘的图片
    
    UIGraphicsEndImageContext();//关闭当前环境
    
    return newImage;
}
//
//
//imagePicker = [[UIImagePickerController alloc] init];//图像选取器
//imagePicker.delegate = self;
//imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//打开相册
//imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;//过渡类型,有四种
////        imagePicker.allowsEditing = NO;//禁止对图片进行编辑
-(void)addStudent//利用被管理对象上下文添加学生
{
    if([self.nameTextField.text length] == 0)
    {
        NSLog(@"here");
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误" message:@"姓名不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.managedObjectContext];//创建新的学生对象
    student.name = self.nameTextField.text;//学生姓名
    student.age = [[NSNumber alloc]initWithInt:[self.ageTextField.text intValue]];//学生年龄
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    student.birthday = [dateFormatter dateFromString:self.birthdayTextField.text];//学生出生年月
    
    //照片 在document中生成一张png图片，把路径跑村在student.image中
    if(currentImage != nil)
    {
        NSData *imageData = UIImagePNGRepresentation(currentImage);
        NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSLog(@"homepath = %@",homePath);
        NSString *fileName = [NSString stringWithFormat:@"%@%d",student.name,[student.age intValue]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *path = [homePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
        if([fileManager fileExistsAtPath:path])
        {
            fileName  = [fileName stringByAppendingFormat:@"1"];
            path = [homePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]];
        }
        NSLog(@"path = %@",path);
        NSError *err = nil;
        [imageData writeToFile:path options:NSDataWritingAtomic error:&err];
        if(err)
        {
            NSLog(@"error = %@",[err description]);
        }
        student.image = [NSString stringWithFormat:@"%@.png",fileName];
    }
    
    //student.photo = [NSString stringWithFormat:@"%d",arc4random()%25];
    NSError *error = nil;
    if(![managedObjectContext save:&error])//把上下文中的操作保存到持久库中
    {
        NSLog(@"Unresolved error %@, %@",error,[error userInfo]);
        abort();
    }
    [self.navigationController popViewControllerAnimated:YES];//从navigationController中出栈
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == self.nameTextField)//如果是姓名输入框，让焦点定位到年龄输入框
    {
        [self.ageTextField becomeFirstResponder];
        return NO;
    }
    else if(textField == self.ageTextField)//如果是年龄输入框，让焦点定位到生日输入框
    {
        [self.birthdayTextField becomeFirstResponder];
        return NO;
    }
    return YES;//如果是生日输入框， 回收键盘
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.birthdayTextField.delegate = self;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

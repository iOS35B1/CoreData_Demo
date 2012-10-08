//
//  DetailedStudentViewController.m
//  CoreData_Demo
//
//  Created by Ibokan on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailedStudentViewController.h"

@implementation DetailedStudentViewController
@synthesize student = _student,nameLabel = _nameLabel,ageLabel = _ageLabel,birthdayLabel = _birthdayLabel;
-(void)dealloc
{
    [_student release];
    [_nameLabel release];
    [_ageLabel release];
    [_birthdayLabel release];
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
    //配置界面
    self.view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)]autorelease];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"backg" ofType:@"jpg"];
    UIImage *backgroudImage =[UIImage imageWithContentsOfFile:path];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:backgroudImage]];
    UILabel *namelbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 100, 30)];
    namelbl.text = @"姓名";
    namelbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:namelbl];
    [namelbl release];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 30, 100, 30)];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.nameLabel];
    
    UILabel *agelbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 90, 100, 30)];
    agelbl.backgroundColor = [UIColor clearColor];
    agelbl.text = @"年龄";
    [self.view addSubview:agelbl];
    [agelbl release];
    
    self.ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 90, 100, 30)];
    self.ageLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.ageLabel];
    
    UILabel *birthdaylbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 160, 100, 30)];
    birthdaylbl.text = @"出生日期";
    birthdaylbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:birthdaylbl];
    [birthdaylbl release];
    
    self.birthdayLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 160, 100, 30)];
    self.birthdayLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.birthdayLabel];

    }



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //显示学生信息
    self.nameLabel.text = self.student.name;
    self.title = self.student.name;
    self.ageLabel.text = [self.student.age stringValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.birthdayLabel.text = [dateFormatter stringFromDate:self.student.birthday];
    
    //如果有照片 显示照片
    //UIPhoto
    if(self.student.image != nil)
    {
        NSString *docpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSString *imagepath = [docpath stringByAppendingPathComponent:self.student.image];
        NSLog(@"imagepath = %@",imagepath);
        UIImage *img = [UIImage imageWithContentsOfFile:imagepath];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
        imageView.frame = CGRectMake(10, 200, 100, 100);
        [self.view addSubview:imageView];
    }
    else
    {
        NSLog(@"NO Photo");
    }


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

//
//  RootViewController.m
//  CoreData_Demo
//
//  Created by Ibokan on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "AddStudentViewController.h"
#import "DetailedStudentViewController.h"
#import "Student.h"

@interface RootViewController()//延展 配置cell
-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
//-(void)configureSearchCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation RootViewController
@synthesize managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;
//@synthesize search_fetchedResultsController = __search_fetchedResultsController;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        id delegate = [[UIApplication sharedApplication] delegate];//设置代理为AppDelegate
        //在初始化函数中，我们看到通过获取delegate，再通过delegate调用方法managedObjectContext，这样就得到了这个NSManagedObjectContext对象，NSManagedObjectContext对象它会跟NSPersistentStoreCoordinator对象打交道，NSPersistentStoreCoordinator会去处理底层的存储方式。
        self.managedObjectContext = [delegate managedObjectContext];//得到被管理对象上下文
        
//        NSString *path = [[NSBundle mainBundle]pathForResource:@"backg" ofType:@"jpg"];
//        UIImage *backgroudImage =[UIImage imageWithContentsOfFile:path];
//        [self.view setBackgroundColor:[UIColor colorWithPatternImage:backgroudImage]];

    }
    return self;
}
-(void)dealloc
{
    [__fetchedResultsController release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"博看35班";
    //“添加” 按钮
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPushed:)];
    self.navigationItem.rightBarButtonItem = addButton;
    //编辑按钮
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    
    //配置搜索框
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.tableView.tableHeaderView = searchBar;
    //用searchBar时只需修改fetchResult的谓词
    UISearchDisplayController *searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplay.searchResultsDataSource = self;
    searchDisplay.searchResultsDelegate = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)addButtonPushed:(UIBarButtonItem *)button
{
    AddStudentViewController *addStudentViewController = [[AddStudentViewController alloc]init];
    //从底部push view
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromTop];
    [animation setDuration:1.0f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.navigationController pushViewController:addStudentViewController animated:NO];
    [self.navigationController.view.layer addAnimation:animation forKey:@"pushView"];
    [addStudentViewController release];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView//tableView中的section数
{
    if(tableView == self.tableView)
    {
        return [[self.fetchedResultsController sections] count];//(NSArray *)sections:The sections for the receiver’s fetch results
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections]objectAtIndex:section];
        //This protocol defines the interface for section objects vended by an instance of NSFetchedResultsController.
        //这个协议定义了由NSFetchedResultsController返回的section对象的接口
        return [sectionInfo numberOfObjects];//返回section对象中的对象数量
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchBar.text];//包含搜索的关键字
        if(searchResultArray)
        {
            [searchResultArray release];
            searchResultArray = nil;
        }
        searchResultArray = [[NSMutableArray alloc]initWithCapacity:10];
        int sections = [[self.fetchedResultsController sections] count];//总分区数
        for(int i=0;i<sections;i++)
        {
           id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections]objectAtIndex:i];//每个分区的信息
            NSArray *studentsInSection = [sectionInfo objects];
            for(Student *stu in studentsInSection)//对于每一个student
            {
                //NSLog(@"stu = %@",stu);
                NSString *name = stu.name;
                if([predicate evaluateWithObject:name] == YES)//如果名字中包含关键字
                {
                    //NSLog(@"yes stu = %@",stu);
                    [searchResultArray addObject:stu];//就把该学生加入searchResultArray
                }
            }
        }
       // NSLog(@"searchresult = %@",searchResultArray);
        return [searchResultArray count];//searchBar的搜索结果中只有一个分区 包含所有的搜索结果

    }    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    // Configure the cell...
    if(tableView == self.tableView)
    {
        [self configureCell:cell atIndexPath:indexPath];//调用方法配置cell
    }
    else
    {
        NSLog(@"cofigure cell searchresult = %@",searchResultArray);
        Student *student = [searchResultArray objectAtIndex:indexPath.row];//searchBar的搜索结果中只有一个分区 包含所有的搜索结果
        cell.textLabel.text = student.name;
    }
    return cell;
}
-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //通过self.fetchedResultsController的结果得到indexpath处的学生对象
    cell.textLabel.text = [managedObject valueForKey:@"name"]; //最终在cell中显示学生姓名
    
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {//删除操作
        // Delete the row from the data source
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        //通过fetchedResultsController在上下文中删除indexpath处的对象
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"Unresolved error %@, %@",error,[error userInfo]);
            abort();
        }
    }   

    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    //选中某行后做的操作
    NSLog(@"didselectrow %@",indexPath);
    DetailedStudentViewController *detailViewController = [[DetailedStudentViewController alloc] init];
    // ...
    // Pass the selected object to the new view controller.
    if(tableView == self.tableView)
    {
        detailViewController.student = [self.fetchedResultsController objectAtIndexPath:indexPath];//属性传值
    }
    else
    {
        detailViewController.student = [searchResultArray objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:detailViewController animated:YES];//datailViewController进栈
    [detailViewController release];

}
#pragma mark - Fetched results controller
-(NSFetchedResultsController *)fetchedResultsController//重写属性fetchedResultsControllerget的get方法，配置NSFetchedResultsController
{
    if(__fetchedResultsController != nil)//如果fetchedResultsController不为空
    {
        return __fetchedResultsController;//返回fetchedResultsController
    }
    // 初始化的时候，你提供四个参数：
    //    1。 一个fetch request.必须包含一个sort descriptor用来给结果集排序。
    //    2。 一个managed object context。 控制器用这个context来执行取数据的请求。
    //    3。 一个可选的key path作为section name。控制器用key path来把结果集拆分成各个section。（传nil代表只有一个section）
    //    4。 一个可选的cache file的名字，用来缓冲数据，生成section和索引信息。
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];//1。 一个fetch request
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    //你还可以选择使用NSPredicate类来为提取请求制定标准。谓词（predicate）可以用来定义提取请求结果的标准
    //NSPredicate *pred = [NSPredicate predicateWithFormat:@"name = %@",name];
    //[fetchRequest setPredicate:pred];
    //
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"birthday" ascending:NO];//一个sort descriptor用来给结果集排序
    //按生日降序排列
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Student"];//2.managed object context为self.managedObjectContext
    //3.一个可选的key path作为section name:传nil代表只有一个section
    //    4。 一个可选的cache file的名字，用来缓冲数据，生成section和索引信息。
    aFetchedResultsController.delegate = self;//NSFetchedResultsControllerDelegate
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if(![self.fetchedResultsController performFetch:&error])//当你实例都创建好之后，调用performFetch: 来执行查询
    {
        NSLog(@"Unresolved error %@,%@",error,[error userInfo]);
    }
    return __fetchedResultsController;
}
#pragma mark - NSFetchedResultsControllerDelegate
//NSFetchedResultsController代理方法 通常都用如下格式
//如果你为fetched results控制器设置了代理，代理会收到从它的managed object context中传来改变通知。delegate会处理context中任何会影响结果集或者section的变化，results也做相应的更新。控制器会告诉delegate结果集改变了什么或者section变化了哪些。你只要覆写几个方法来更新table view就行。

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];//在controllerWillChangeContent:方法中指定开始更新
}
-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type//更新section的方法
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];//插入section
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];//删除section
            break;
        default:
            break;
    }
}
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath//更新row的方法
{
    //    enum {
    //        NSFetchedResultsChangeInsert = 1,
    //        NSFetchedResultsChangeDelete = 2,
    //        NSFetchedResultsChangeMove = 3,
    //        NSFetchedResultsChangeUpdate = 4
    //    };NSFetchedResultsChangeType
    UITableView *tableView = self.tableView;
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];//在newIndexPath处插入行
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];//在indexPath处删除行
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];//更新行
            break;
        case NSFetchedResultsChangeMove://移动行
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];//先删除旧的indexPath处的行
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];//再插入到newIndexPath处
            break;
        default:
            break;
    }
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];//在controllerDidChangeContent:方法中指定结束更新
}

@end

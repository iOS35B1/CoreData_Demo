//
//  RootViewController.h
//  CoreData_Demo
//
//  Created by Ibokan on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//Implementing the Table View Datasource Methods
//实现带有fetchedResultsController的tableviewController 的步骤：
//You ask the object to provide relevant information in your implementation of the table view data source methods:
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return [[<#Fetched results controller#> sections] count];
//}
//
//- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
//    id <NSFetchedResultsSectionInfo> sectionInfo = [[<#Fetched results controller#> sections] objectAtIndex:section];
//    return [sectionInfo numberOfObjects];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewCell *cell = <#Get the cell#>;
//    NSManagedObject *managedObject = [<#Fetched results controller#> objectAtIndexPath:indexPath];
//    // Configure the cell with data from the managed object.
//    return cell;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
//    id <NSFetchedResultsSectionInfo> sectionInfo = [[<#Fetched results controller#> sections] objectAtIndex:section];
//    return [sectionInfo name];
//}
//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [<#Fetched results controller#> sectionIndexTitles];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return [<#Fetched results controller#> sectionForSectionIndexTitle:title atIndex:index];
//}

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController<NSFetchedResultsControllerDelegate>
{
    NSManagedObjectContext *managedObjectContext;//被管理对象上下文
    //使用Core Data的框架，大多数的功能都可以自动实现，因为我们有managed object context（管理对象的上下文，有时直接叫"Context"）。managed object context就像是一个关卡，通过它可以访问框架底层的对象——这些对象的集合我们称之为"persistence stack"（数据持久栈）。 managed object context作为程序中对象和外部的数据存储的中转站。栈的底部是persistence object stores（持久化数据存储）
    NSFetchedResultsController *__fetchedResultsController;//fetchedResultsController
    //NSFetchedResultsController和UITableView集成起来处理数据具有强大的灵活性。一般来说，你会创建一个NSFetchedResultsController实例作为table view的成员变量。
    //我们知道表格视图有很多种形式, fetched results 控制器主要针对列表视图，这种视图是由很多section组成的，每个section又包含了很多row。我们只需要在使用时配置 NSFetchedResultsController对象：entity是什么，如何排序（必须配置），预筛选项（可选）。NSFetchedResultsController就会自动帮你处理好每个section都应该显示哪些数据。
    
    
    UISearchBar *searchBar;//搜索
    //NSFetchedResultsController *__search_fetchedResultsController;
    NSMutableArray *searchResultArray;
}

@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
//@property(nonatomic,strong)NSFetchedResultsController *search_fetchedResultsController;
@end

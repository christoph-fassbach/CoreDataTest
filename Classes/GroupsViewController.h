//
//  GroupsViewController.h
//  CoreDataContactsAndGroups
//
//  Created by Christoph Fassbach on 29.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactsViewController;

@interface GroupsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *tableView;
	NSFetchedResultsController *fetchedResultsController;
	
	NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSFetchedResultsController *fetchedResultsController;

-(void) fetchData;

@end

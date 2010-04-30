//
//  ContactsViewController.h
//  CoreDataContactsAndGroups
//
//  Created by Christoph Fassbach on 29.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContactsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSString *groupName;
	UITableView *table;
	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchedResultsController;
}

@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, retain) IBOutlet UITableView *table;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSFetchedResultsController *fetchedResultsController;

-(void) fetchData;

@end

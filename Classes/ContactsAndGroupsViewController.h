//
//  ContactsAndGroupsViewController.h
//  CoreDataContactsAndGroups
//
//  Created by Christoph Fassbach on 29.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContactsAndGroupsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *table;
	NSManagedObjectContext *moc;
	NSFetchedResultsController *fetchedResultsController;
}

- (void)fetch;

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSManagedObjectContext *moc;
@property (nonatomic, retain, readonly) NSFetchedResultsController *fetchedResultsController;

@end

/*
@interface SongsViewController : UIViewController {
@private
    SongDetailsController *detailController;
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    UITableView *tableView;
    UISegmentedControl *fetchSectioningControl;
}

@property (nonatomic, retain, readonly) SongDetailsController *detailController;
@property (nonatomic, retain, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *fetchSectioningControl;

- (IBAction)changeFetchSectioning:(id)sender;

- (void)fetch;
*/
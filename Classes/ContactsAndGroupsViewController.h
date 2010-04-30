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
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSManagedObjectContext *moc;

@end

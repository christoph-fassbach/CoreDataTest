//
//  ContactsViewController.m
//  CoreDataContactsAndGroups
//
//  Created by Christoph Fassbach on 29.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ContactsViewController.h"

#import "Group.h"
#import "Contact.h"

@implementation ContactsViewController

@synthesize table;
@synthesize managedObjectContext;
@synthesize groupName;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self fetchData];
}

-(void) fetchData {
	NSError *error = nil;
    BOOL success = [self.fetchedResultsController performFetch:&error];
	if ( !success ) {
		exit( -1 );
	}
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	
	[table release];
	[managedObjectContext release];
	[fetchedResultsController release];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Contact" inManagedObjectContext:managedObjectContext]];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY groups.groupName like %@", self.groupName ];
//		NSLog( [predicate predicateFormat]);
		[fetchRequest setPredicate:predicate];
        NSArray *sortDescriptors = nil;
        NSString *sectionNameKeyPath = nil;
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [fetchRequest setSortDescriptors:sortDescriptors];
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																	   managedObjectContext:managedObjectContext
																		 sectionNameKeyPath:sectionNameKeyPath
																				  cacheName:@"ContactsCache"];
		
		[fetchRequest release];
		[sortDescriptor release];
    }    
    return fetchedResultsController;
}

#pragma mark -
#pragma mark From UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return [[fetchedResultsController sections] count];
}

- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	int count = [sectionInfo numberOfObjects];
	return count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellId = @"com.contact.cell";
	
	UITableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if (contactCell == nil) {
		contactCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellId] autorelease];
	}
	
	Contact* contact = [fetchedResultsController objectAtIndexPath:indexPath];
	contactCell.textLabel.text = contact.firstName;
	contactCell.detailTextLabel.text = contact.lastName;
	
	return contactCell;
}

#pragma mark -

@end

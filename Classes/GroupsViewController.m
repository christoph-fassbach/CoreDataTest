//
//  GroupsViewController.m
//  CoreDataContactsAndGroups
//
//  Created by Christoph Fassbach on 29.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GroupsViewController.h"
#import "ContactsViewController.h"
#import "Group.h"
#import "CoreDataContactsAndGroupsAppDelegate.h"

@implementation GroupsViewController

@synthesize tableView;
@synthesize managedObjectContext;


- (void)dealloc {	
	[tableView release];
	[fetchedResultsController release];
	[managedObjectContext release];
	
    [super dealloc];
}

// This one will never be called, IF the instance is brought up by the Interface Builder Connections!
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
	if (self == [super initWithNibName:nibName bundle:nibBundle]) {
		self.managedObjectContext = [(CoreDataContactsAndGroupsAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	}

	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	[self fetchData];
}

-(void) fetchData {
	NSError *error = nil;
	// This is necessary because the init... is only called if this is instantiated by source code.
	if ( !self.managedObjectContext ) {
		self.managedObjectContext = [(CoreDataContactsAndGroupsAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	}
    BOOL success = [self.fetchedResultsController performFetch:&error];
	if ( !success ) {
		exit( -1 );
	}
    [self.tableView reloadData];
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
	self.tableView = nil;
	self.managedObjectContext = nil;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Group" inManagedObjectContext:self.managedObjectContext]];
        NSArray *sortDescriptors = nil;
        NSString *sectionNameKeyPath = nil;
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"groupName" ascending:YES];
        sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [fetchRequest setSortDescriptors:sortDescriptors];
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																	   managedObjectContext:self.managedObjectContext
																		 sectionNameKeyPath:sectionNameKeyPath
																				  cacheName:@"GroupsCache"];
		[sortDescriptor release];
		[fetchRequest release];
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

- (UITableViewCell *) tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellId = @"com.contact.cell";
	
	UITableViewCell *contactCell = [table dequeueReusableCellWithIdentifier:cellId];
	if (contactCell == nil) {
		contactCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellId] autorelease];
	}
	
	Group *group = [fetchedResultsController objectAtIndexPath:indexPath];
	contactCell.textLabel.text = group.groupName;
	
	return contactCell;
}

#pragma mark -
#pragma mark From UITableDelegate

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
	//TODO: is there a memory leak in the next line?
	ContactsViewController *contactsViewController = [[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil];
	contactsViewController.managedObjectContext = self.managedObjectContext;
	Group *group = [fetchedResultsController objectAtIndexPath:indexPath];
	contactsViewController.groupName = group.groupName;
	[self.navigationController pushViewController:contactsViewController animated:YES];
	[contactsViewController release];
}

#pragma mark -


@end

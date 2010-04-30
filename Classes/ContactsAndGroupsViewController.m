//
//  ContactsAndGroupsViewController.m
//  CoreDataContactsAndGroups
//
//  Created by Christoph Fassbach on 29.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ContactsAndGroupsViewController.h"
#import "Group.h"
#import "Contact.h"

@implementation ContactsAndGroupsViewController

@synthesize table;
@synthesize moc;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetch];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.table = nil;
}


- (void)dealloc {
	[table release];
    [super dealloc];
}


- (void)fetch {
    NSError *error = nil;
    BOOL success = [self.fetchedResultsController performFetch:&error];
    [self.table reloadData];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (fetchedResultsController == nil) {
		
        NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Contact" inManagedObjectContext:self.moc]];
		NSArray *sortDescriptors = sortDescriptors = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES] autorelease]];
        [fetchRequest setSortDescriptors:sortDescriptors];
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.moc sectionNameKeyPath:nil cacheName:@"ContactCache"];
    }    
    return fetchedResultsController;
}    

#pragma mark From UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	
	return [[fetchedResultsController sections] count];
}

- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	NSFetchRequest* requestGroups = [ [ NSFetchRequest alloc ] init ];
	NSEntityDescription* descriptionGroups = [ NSEntityDescription entityForName:@"Group" 
														  inManagedObjectContext:self.moc ];
	[requestGroups setEntity:descriptionGroups];
	NSError* errorGroups;
	NSArray* groups = [ self.moc executeFetchRequest:requestGroups error:&errorGroups ];
	
	NSMutableArray* names = [[NSMutableArray alloc] init];
	for (Group* group in groups) {
		[names addObject:group.groupName];
	}
	return names;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo name];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellId = @"com.contact.cell";
	
	UITableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if (contactCell == nil) {
		contactCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellId];
	}
	
	Contact *contact = [fetchedResultsController objectAtIndexPath:indexPath];
	
	contactCell.textLabel.text = contact.firstName;
	contactCell.detailTextLabel.text = contact.lastName;	
	
	return contactCell;
}

#pragma mark -

@end

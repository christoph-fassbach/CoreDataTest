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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
	[moc release];
	[table release];
    [super dealloc];
}


#pragma mark From UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	
	NSFetchRequest* requestGroups = [ [ NSFetchRequest alloc ] init ];
	NSEntityDescription* descriptionGroups = [ NSEntityDescription entityForName:@"Group" 
														   inManagedObjectContext:self.moc ];
	[requestGroups setEntity:descriptionGroups];
	NSError* errorGroups;
	NSArray* groups = [ self.moc executeFetchRequest:requestGroups error:&errorGroups ];
	[ requestGroups release ];

	if ( groups ) {
		return groups.count;
	}
	return 0;
	/**
	 if alloc/init -> release;
	 if create/copy -> release;
	 otherwise it's autorelease'd and we do nothing.
	 */
}

- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	
	NSFetchRequest* requestGroups = [ [ NSFetchRequest alloc ] init ];
	NSEntityDescription* descriptionGroups = [ NSEntityDescription entityForName:@"Group" 
														  inManagedObjectContext:self.moc ];
	[requestGroups setEntity:descriptionGroups];
	NSError* errorGroups;
	NSArray* groups = [ self.moc executeFetchRequest:requestGroups error:&errorGroups ];

	Group* group = [ groups objectAtIndex:section ];
	int count = [ group.contacts count ];
	[ requestGroups release ];
	
	return count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	NSFetchRequest* requestGroups = [ [ NSFetchRequest alloc ] init ];
	NSEntityDescription* descriptionGroups = [ NSEntityDescription entityForName:@"Group" 
														  inManagedObjectContext:self.moc ];
	[requestGroups setEntity:descriptionGroups];
	NSError* errorGroups;
	NSArray* groups = [ self.moc executeFetchRequest:requestGroups error:&errorGroups ];
	
	NSMutableArray* names = [[[NSMutableArray alloc] init] autorelease];
	for (Group* group in groups) {
		[names addObject:group.groupName];
	}
	[requestGroups release];
	return names;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSFetchRequest* requestGroups = [ [ NSFetchRequest alloc ] init ];
	NSEntityDescription* descriptionGroups = [ NSEntityDescription entityForName:@"Group" 
														  inManagedObjectContext:self.moc ];
	[requestGroups setEntity:descriptionGroups];
	NSError* errorGroups;
	NSArray* groups = [ self.moc executeFetchRequest:requestGroups error:&errorGroups ];
	
	Group* group = [ groups objectAtIndex:section ];
	[requestGroups release];

	return group.groupName;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellId = @"com.contact.cell";
	
	UITableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if (contactCell == nil) {
		contactCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellId] autorelease];
	}
	
	NSFetchRequest* requestGroups = [ [ NSFetchRequest alloc ] init ];
	NSEntityDescription* descriptionGroups = [ NSEntityDescription entityForName:@"Group" 
														  inManagedObjectContext:self.moc ];
	[requestGroups setEntity:descriptionGroups];
	NSError* errorGroups;
	NSArray* groups = [ self.moc executeFetchRequest:requestGroups error:&errorGroups ];
	
	Group* group = [ groups objectAtIndex:indexPath.section ];
	NSSet* contacts = group.contacts;
	NSEnumerator* contactIt = [contacts objectEnumerator];
	Contact* contact = [contactIt nextObject];
	for (int i = 0; i < indexPath.row; ++i) {
		contact = [contactIt nextObject];
	}

	contactCell.textLabel.text = contact.firstName;
	contactCell.detailTextLabel.text = contact.lastName;

	[ requestGroups release ];
	
	return contactCell;
}

#pragma mark -

@end

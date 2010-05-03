//
//  CoreDataContactsAndGroupsAppDelegate.m
//  CoreDataContactsAndGroups
//
//  Created by Christoph Fassbach on 29.04.10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "CoreDataContactsAndGroupsAppDelegate.h"
#import "ContactsAndGroupsViewController.h"
#import "GroupsViewController.h"
#import "ContactsViewController.h"

@implementation CoreDataContactsAndGroupsAppDelegate

static NSString* testDbFilename = @"Test.sqlite";
static NSString* dbFilename = @"CoreDataContactsAndGroups.sqlite";

@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[window release];
	[navigationController release];
	[super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch
	NSMutableData* data = [[NSMutableData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/persistence", [self applicationDocumentsDirectory]]];
	if ( data ) {
		NSKeyedUnarchiver* archiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		if ( ![archiver decodeBoolForKey:@"isGroup"] ) {
			NSString* groupName = [archiver decodeObjectForKey:@"groupName"];
			ContactsViewController* contactsViewController = [[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil];
			contactsViewController.managedObjectContext = self.managedObjectContext;
			contactsViewController.groupName = groupName;
			[self.navigationController pushViewController:contactsViewController animated:NO];
			[contactsViewController release];
		}
		[archiver release];
		[data release];
		NSLog(@"Persistence read");
	}
	
	[window addSubview: navigationController.view];
	[window makeKeyAndVisible];
	
	return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[NSFetchedResultsController deleteCacheWithName:@"ContactsCache"];
	[NSFetchedResultsController deleteCacheWithName:@"GroupsCache"];
	// save DB if needed
	[self applicationWillTerminate:application];
	
	// save view state
	NSMutableData* data = [[NSMutableData alloc] init];
	NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
	UIViewController* currentView = self.navigationController.visibleViewController;
	if ( [currentView isKindOfClass:[GroupsViewController class]] ) {
		[archiver encodeBool:YES forKey:@"isGroup"];
		[archiver encodeObject:@"" forKey:@"groupName"];		
	} else {
		[archiver encodeBool:NO forKey:@"isGroup"];
		[archiver encodeObject:((ContactsViewController*)currentView).groupName forKey:@"groupName"];		
	}
	[archiver finishEncoding];
	[archiver release];
	BOOL success = [data writeToFile:[NSString stringWithFormat:@"%@/persistence", [self applicationDocumentsDirectory]] atomically:YES];
	[data release];
	NSLog(@"Persistence written %d", success);
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
	// Use NSKeyedArchiver to save app state?
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	[self prepareCoreDataStore:testDbFilename];
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: dbFilename]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (BOOL) prepareCoreDataStore:(NSString*) fileName {
	BOOL success = [self prepareCoreDataStore:fileName forceOverwrite:NO];
	return success;
}

- (BOOL) prepareCoreDataStore:(NSString*) fileName forceOverwrite:(BOOL) overwrite {
	NSBundle* appBundle = [NSBundle mainBundle];
	NSString* sourceDbPath = [appBundle pathForResource:fileName ofType:nil];
	NSMutableString* destDbPath = [[NSMutableString alloc] initWithString:[self applicationDocumentsDirectory]];
	[destDbPath appendString:@"/"];
	[destDbPath appendString:dbFilename];
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* error = nil;
		
	if ( overwrite ) {
		[fileManager removeItemAtPath:destDbPath error:&error];
		NSLog( @"File %@ removed, error %@", destDbPath, error );
	}
	
	BOOL success = [fileManager copyItemAtPath:sourceDbPath toPath:destDbPath error:&error];
	NSLog( @"Copies %d %@", success, error );
	
	return success;
}

@end


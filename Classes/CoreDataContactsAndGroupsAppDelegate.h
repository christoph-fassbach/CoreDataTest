//
//  CoreDataContactsAndGroupsAppDelegate.h
//  CoreDataContactsAndGroups
//
//  Created by Christoph Fassbach on 29.04.10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class ContactsAndGroupsViewController;
@class GroupsViewController;
@class ContactsViewController;

@interface CoreDataContactsAndGroupsAppDelegate : NSObject <UIApplicationDelegate> {
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;	    
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	UIWindow *window;
	UINavigationController *navigationController;
}

- (NSString *)applicationDocumentsDirectory;
- (BOOL) prepareCoreDataStore:(NSString*) fileName;
- (BOOL) prepareCoreDataStore:(NSString*) fileName forceOverwrite:(BOOL) overwrite;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end


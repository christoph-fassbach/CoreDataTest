//
//  Contact.h
//  CoreDataContactsAndGroups
//
//  Created by Christoph Fassbach on 29.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Contact :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet* groups;

@end


@interface Contact (CoreDataGeneratedAccessors)
- (void)addGroupsObject:(NSManagedObject *)value;
- (void)removeGroupsObject:(NSManagedObject *)value;
- (void)addGroups:(NSSet *)value;
- (void)removeGroups:(NSSet *)value;

@end


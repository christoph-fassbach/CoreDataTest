//
//  Group.h
//  CoreDataContactsAndGroups
//
//  Created by Christoph Fassbach on 29.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Contact;

@interface Group :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSSet* contacts;

@end


@interface Group (CoreDataGeneratedAccessors)
- (void)addContactsObject:(Contact *)value;
- (void)removeContactsObject:(Contact *)value;
- (void)addContacts:(NSSet *)value;
- (void)removeContacts:(NSSet *)value;

@end


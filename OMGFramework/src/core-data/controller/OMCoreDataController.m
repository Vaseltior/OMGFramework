//
//  SGCoreDataController.m
//
//  Created by Samuel Grau on 26/11/11.
//  Copyright (c) 2011 Samuel Grau. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "OMCoreDataController.h"
#import "OMCoreHeader.h"

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@implementation OMCoreDataController


@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize resourceFileName = _resourceFileName;
@synthesize resourceFileExtension = _resourceFileExtension;
@synthesize persistentStoreType = _persistentStoreType;
@synthesize persistentStoreName = _persistentStoreName;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Initialization
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (id)initWithResourceFileName:(NSString *)fileName 
                  andExtension:(NSString *)extension
                     storeType:(NSString *)storeType
                     storeName:(NSString *)storeName {
    
    self = [super init];
    if (self) {
        self.resourceFileName = fileName;
        self.resourceFileExtension = extension;
        self.persistentStoreType = storeType;
        self.persistentStoreName = storeName;
    }
    return self;
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (id)init {
    self = [super init];
    if (self) {
        _resourceFileName = [@"dicoreves" retain];
        _resourceFileExtension = [@"momd" retain];
        _persistentStoreType = [NSSQLiteStoreType retain];
        _persistentStoreName = [@"dicoreves-2.0.sqlite" retain];
    }
    return self;
}


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Memory Management
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)dealloc {
    OMReleaseSafely(_persistentStoreName);
    OMReleaseSafely(_persistentStoreType);
    OMReleaseSafely(_resourceFileName);
    OMReleaseSafely(_resourceFileExtension);
    
    OMReleaseSafely(__managedObjectContext);
    OMReleaseSafely(__managedObjectModel);
    OMReleaseSafely(__persistentStoreCoordinator);
    
    [super dealloc];
}


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Core Data Operations
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)saveContext {
    NSError * error = nil;
    NSManagedObjectContext * managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. 
             You should not use this function in a shipping application, 
             although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        } 
    }
}


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Core Data stack
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store 
 coordinator for the application.
 */
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSManagedObjectModel *)managedObjectModel {
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_resourceFileName 
                                              withExtension:_resourceFileExtension];
    
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    @synchronized(self) {
        // No need to create a new persistent store if that one already exist
        if (__persistentStoreCoordinator != nil) {
            return __persistentStoreCoordinator;
        }
        
        NSURL *appDir = [self applicationDocumentsDirectory];
        NSURL *storeURL = [appDir URLByAppendingPathComponent:_persistentStoreName];
        
        NSError *error = nil;
        NSManagedObjectModel *mom = [self managedObjectModel];
        __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
        
        NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
        [options addEntriesFromDictionary:[self lightweightDefaultMigrationOptionsDictionary]];
        
        // Getting SQLite Store options dictionary if the current store is an SQLite store
        if ([_persistentStoreType isEqualToString:NSSQLiteStoreType]) {
            [options addEntriesFromDictionary:[self sqliteStoreOptionsDictionary]];
        }
        
        NSPersistentStore * ps = nil;
        ps = [__persistentStoreCoordinator addPersistentStoreWithType:_persistentStoreType 
                                                        configuration:nil 
                                                                  URL:storeURL 
                                                              options:options 
                                                                error:&error];
        if (!ps) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. 
             You should not use this function in a shipping application, although it may 
             be useful during development. 
             
             Typical reasons for an error here include:
             * The persistent store is not accessible;
             * The schema for the persistent store is incompatible with current managed object model.
             Check the error message to determine what the actual problem was.
             
             
             If the persistent store is not accessible, there is typically something wrong 
             with the file path. Often, a file URL is pointing into the application's 
             resources directory instead of a writeable directory.
             
             If you encounter schema incompatibility errors during development, 
             you can reduce their frequency by:
             * Simply deleting the existing store:
             
             * Performing automatic lightweight migration by passing the following 
             dictionary as the options parameter: 
             [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], 
             NSMigratePersistentStoresAutomaticallyOption, 
             [NSNumber numberWithBool:YES], 
             NSInferMappingModelAutomaticallyOption, nil];
             
             Lightweight migration will only work for a limited set of schema changes; 
             consult "Core Data Model Versioning and Data Migration Programming Guide" 
             for details.
             
             */
            OMReleaseSafely(options);
            NSLog(@"============\nUnresolved error %@, %@\n============", error, [error userInfo]);
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
            return [self persistentStoreCoordinator];
            //abort();
        }    
        
        OMReleaseSafely(options);
        
        return __persistentStoreCoordinator;
    }
}


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Application's Documents directory
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/**
 Returns the URL to the application's Documents directory.
 */
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSURL *)applicationDocumentsDirectory {
    NSFileManager *fm = [NSFileManager defaultManager];
    return [[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Helper methods
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSDictionary *)lightweightDefaultMigrationOptionsDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
            [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, 
            nil];
}


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSDictionary *)sqliteStoreOptionsDictionary {
    NSMutableDictionary *pragmaOptions = [NSMutableDictionary dictionary];
    [pragmaOptions setObject:@"NORMAL" forKey:@"synchronous"];
    [pragmaOptions setObject:@"1" forKey:@"fullfsync"];
    
    return [NSDictionary dictionaryWithObject:pragmaOptions forKey:NSSQLitePragmasOption];
}

@end

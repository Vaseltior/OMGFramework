//
//  ANCoreDataGrandCentralController.h
//
//  Created by Samuel Grau on 26/11/11.
//  Copyright (c) 2011 Samuel Grau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OMCoreDataController;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@interface OMCoreDataGrandCentralController : NSObject {
    NSMutableDictionary * _coreDataControllers;
    NSMutableDictionary * _threadedManagedObjectContexts;
}

+ (OMCoreDataGrandCentralController *)instance;
- (OMCoreDataController *)controllerWithName:(NSString *)name;
- (BOOL)addController:(OMCoreDataController *)controller withName:(NSString *)name;
- (void)saveContexts;
- (void)releaseControllers;

- (void)removeObserveForManagedObjectContext:(NSManagedObjectContext *)moc withKey:(NSString *)key;
- (NSManagedObjectContext *)managedObjectContextForKey:(NSString *)key forMainThread:(BOOL)forMainThread;

@end

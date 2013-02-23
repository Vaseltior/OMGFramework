//
//  OMCoreDataGrandCentralController.m
//
//  Created by Samuel Grau on 26/11/11.
//  Copyright (c) 2011 Samuel Grau. All rights reserved.
//

#import "OMCoreDataGrandCentralController.h"
#import "OMCoreDataController.h"
#import "OMCoreHeader.h"

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@implementation OMCoreDataGrandCentralController


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Singleton definition
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

static OMCoreDataGrandCentralController * instance = nil;

+ (instancetype)instance {
    @synchronized(self) {                                
        static dispatch_once_t pred;                       
        if (instance == nil) {                 
            dispatch_once(&pred, ^{                          
                instance = [[OMCoreDataGrandCentralController alloc] init];               
            });                                          
        }                                              
    }                                                
    return instance;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {                            
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }                                              
    }                                                
    
    /* We can't return the shared instance, because it's been init'd */ 
    NSAssert(NO, @"use the singleton API, not alloc+init");        
    return nil;                                      
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (id)retain {
    return self;                                     
}                                                  

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSUInteger)retainCount {
    return NSUIntegerMax;                            
}                                                  

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (oneway void)release {
}                                                  

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (id)autorelease {
    return self;                                     
}                                                  

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (id)copyWithZone:(NSZone *)zone {
    return self;                                     
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Initialization
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (id)init {
    self = [super init];
    if (self) {
        _coreDataControllers = [[NSMutableDictionary alloc] init];
        _threadedManagedObjectContexts = [[NSMutableDictionary alloc] init];
    }
    return self;
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Memory Management
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)dealloc {
    // This object lives for the entire life of the application. Getting it to support being 
    // deallocated would be quite tricky (particularly from a threading perspective), so we 
    // don't even try.
    
    [super dealloc];
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Setters / Getters
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (OMCoreDataController *)controllerWithName:(NSString *)name {
    NSAssert(name, @"Missing parameter name", nil);
    OMCoreDataController * result = nil;
    result = [NSDictionary vfk:name 
                            wd:_coreDataControllers 
                            et:[OMCoreDataController class] 
                            dv:nil];
    return result;
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (BOOL)addController:(OMCoreDataController *)controller withName:(NSString *)name {
    NSAssert(name, @"Missing parameter name", nil);
    NSAssert(controller, @"Missing parameter controller", nil);

    [_coreDataControllers setObject:controller forKey:name];

    return !![_coreDataControllers objectForKey:name];
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)saveContexts {
    for (OMCoreDataController * controller in _coreDataControllers) {
        [controller saveContext];
    }
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)releaseControllers {
    [_coreDataControllers removeAllObjects];
}


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)createMutableDictionaryForKey:(id)key {
    NSMutableDictionary * d = [[NSMutableDictionary alloc] init];
    [_threadedManagedObjectContexts setObject:d forKey:key];
    OMReleaseSafely(d);
} /* createMutableDictionaryForKey */


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSMutableDictionary *)mocsDictionaryForKey:(id)key {
    @synchronized(self) {
        if ( [_threadedManagedObjectContexts objectForKey:key] == nil ) {
            [self createMutableDictionaryForKey:key];
        }
        
        NSMutableDictionary *vv = [_threadedManagedObjectContexts objectForKey:key];
        
        if ( ![vv isKindOfClass:[NSMutableDictionary class]] ) {
            return nil;
        }
        
        return vv;
    }
} /* usableImageForURL */

#pragma GCC diagnostic ignored "-Wselector"

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)removeObserveForManagedObjectContext:(NSManagedObjectContext *)moc withKey:(NSString *)key {
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    NSMutableDictionary * mocs = [self mocsDictionaryForKey:key];
    if (mocs) {
        NSNumber * n = [NSNumber numberWithUnsignedInteger:[moc hash]];
        id object = [mocs objectForKey:n];
        if (object) {
            [nc removeObserver:object name:NSManagedObjectContextDidSaveNotification object:moc];
            
            //NSLog(@"============\nObserver Removed %@, %@\n============", moc, key);
        }
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSManagedObjectContext *)managedObjectContextForKey:(NSString *)key forMainThread:(BOOL)forMainThread {
    
    // Get a blank managed object context
    OMCoreDataGrandCentralController * cdgcc = [OMCoreDataGrandCentralController instance];
    OMCoreDataController * cdc = [cdgcc controllerWithName:key];
    
    if (forMainThread) {
        return [cdc managedObjectContext];
    }
    
    // Here it is not for the main thread
    NSManagedObjectContext * moc = [[NSManagedObjectContext alloc] init];
    [moc setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
    [moc setPersistentStoreCoordinator:[cdc persistentStoreCoordinator]];
    [moc setUndoManager:nil];
    
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    id object = [nc addObserverForName:NSManagedObjectContextDidSaveNotification 
                                object:moc 
                                 queue:[NSOperationQueue mainQueue] 
                            usingBlock:^(NSNotification * note) {
                                
                                OMCoreDataGrandCentralController * gcc = [OMCoreDataGrandCentralController instance];
                                OMCoreDataController * c = [gcc controllerWithName:key];
                                NSManagedObjectContext * mainContext = [c managedObjectContext];
                                
                                @try {
                                    // Merge changes into the main context on the main thread
                                    SEL mergeSelector = @selector(mergeChangesFromContextDidSaveNotification:);
                                    [mainContext performSelectorOnMainThread:mergeSelector withObject:note waitUntilDone:YES];
                                }
                                @catch (NSException * e) {
                                    NSLog(@"Stopping on exception: %@", [e description]);
                                }
                                @finally {
                                    //NSLog(@"============\nNSManagedObjectContextDidSaveNotification %@ \n============", mainContext);
                                }
                            }];
    
    
    // We get a reference to the 
    if (object) {
        NSMutableDictionary * mocs = [self mocsDictionaryForKey:key];
        NSNumber * n = [NSNumber numberWithUnsignedInteger:[moc hash]];
        [mocs setObject:object forKey:n];
        
        //NSLog(@"============\nObserver created %@, %@\n============", moc, key);
    }    
    
    return [moc autorelease];
}
#pragma GCC diagnostic warning "-Wselector"

@end

//
//  OMLogManager.m
//  
//
//  Created by Nathalie Lalaut on 02/09/11.
//  Copyright (c) 2011   All rights reserved.
//
#import "OMLogManager.h"

@interface OMLogManager ()
{
	NSMutableString		*_msg;
	NSMutableString		*_level;
    BOOL                _applyFilterToAllLogs;
}

@property (nonatomic,retain) NSMutableString    *_msg;
@property (nonatomic,retain) NSMutableString    *_level;

/*
 * \attention this method must only be called for precise short time debug purpose cause FATAL and ERROR log will not be output : potential bugs !
 */
@property (nonatomic,readwrite) BOOL            _applyFilterToAllLogs;

- (void)initialization;

@end

@implementation OMLogManager

@synthesize _msg;
@synthesize _level;
@synthesize classesIncluded = _classesIncluded;
@synthesize classesExcluded = _classesExcluded;
@synthesize _applyFilterToAllLogs;

OM_OBJECT_SINGLETON_BOILERPLATE(OMLogManager, sharedLogManager);

- (id)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    _msg = [[NSMutableString alloc] init]; 
    _level = [[NSMutableString alloc] init]; 
    self.classesIncluded = nil;
    self.classesExcluded = nil;
    self._applyFilterToAllLogs = NO;
}

-(void)dealloc {
    OMReleaseSafely(_level);
    OMReleaseSafely(_msg);
	[ super dealloc ];
}

- (void)log:(NSString*)message objectParam:(id)object logLevelParam:(OM_LOG_LEVEL)logLevel exceptionParam:(NSException*)ex errorParam:(NSError*)err
{
#ifndef DEBUG	
    switch (logLevel)
    {
        case OM_LOG_LEVEL_DEBUG:
        case OM_LOG_LEVEL_WARNING:
        case OM_LOG_LEVEL_ERROR:
            return;
        case OM_LOG_LEVEL_INFO:
        case OM_LOG_LEVEL_FATAL:
            break;
    }
    // ERROR adn FATAL log to Crittercism
#endif
    
    //Apply ignore policy only for log DEBUG, INFO and WARNING
    if (logLevel<=OM_LOG_LEVEL_WARNING || _applyFilterToAllLogs) 
    {
        //Ignore log of object of classes present in _classesExcluded
        for (Class class in _classesExcluded) 
        {
            if ([object isKindOfClass:class]) 
            {
                return;
            }
        }
        
        //Ignore log of object of classes not present in _classesIncluded only if _classesIncluded != nil
        if (_classesIncluded) 
        {
            BOOL mustLog = NO;
            
            for (Class class in _classesIncluded) 
            {
                if ([object isKindOfClass:class]) 
                {
                    mustLog = YES;
                    break;
                }
            }
            
            if (!mustLog) 
            {
                return;
            }
        }
    }
   
    @synchronized(self)
    {
        switch (logLevel) {
            case OM_LOG_LEVEL_DEBUG:
                [_level setString:@"[DEBUG] : "];
                break;
            case OM_LOG_LEVEL_INFO:
                [_level setString:@"[INFO] : "];
                break;
            case OM_LOG_LEVEL_WARNING:
                [_level setString:@"[WARNING] : "];
                break;
            case OM_LOG_LEVEL_ERROR:
                [_level setString:@"[ERROR] : "];
                break;
            case OM_LOG_LEVEL_FATAL:
                [_level setString:@"[FATAL] : "];
                break;
        }
        
        [_msg setString:@""];
        [_msg appendFormat:@"%@ %@\n", _level, message];
        
        if(ex != nil)
        {
            [_msg appendFormat:@"%@\n", ex.reason];
        }
        
        if(err != nil)
        {
            [_msg appendFormat:@"%@\n", err.localizedDescription];
            [_msg appendFormat:@"%@\n", err.localizedFailureReason];
        }
        
        NSLog(@"%@\n",_msg);
        
        if (logLevel == OM_LOG_LEVEL_FATAL) // Force user to make correction of his code
        {
            NSString * format = (NSString *)_msg;
            [NSException raise:libName format:format, nil];
        }
    }
}

- (void)log:(NSString*)message logLevelParam:(OM_LOG_LEVEL)logLevel exceptionParam:(NSException*)ex errorParam:(NSError*)err
{
    [self log:message objectParam:self logLevelParam:logLevel exceptionParam:ex errorParam:err];
}


@end

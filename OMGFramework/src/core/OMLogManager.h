//
//  
//  
//
//  Created by Nathalie Lalaut on 02/09/11.
//  Copyright (c) 2011   All rights reserved.
//

#import <Foundation/Foundation.h>

#define libName @"OMGFramework"

#define DESC_(desc) \
[NSString stringWithFormat:@"%s - line %d => %@", __PRETTY_FUNCTION__, __LINE__, desc]

#define EXCEPTION_(desc) \
[NSException exceptionWithName:[NSString stringWithFormat:@"%@ - %@",libName, desc] reason:DESC_(desc) userInfo:nil] 

#define OM_LOG_(desc,level,exception,error) \
[[LogManager sharedLogManager] log:DESC_(desc) logLevelParam:level exceptionParam:exception errorParam:error];

#define OM_LOG_DEBUG_(fmt,...) \
[[LogManager sharedLogManager] log:[NSString stringWithFormat:@"%@%@", DESC_(@""), [NSString stringWithFormat:(fmt), ##__VA_ARGS__]] logLevelParam:OM_LOG_LEVEL_DEBUG exceptionParam:nil errorParam:nil];

#define OM_LOG_WARNING_(fmt,...) \
[[LogManager sharedLogManager] log:[NSString stringWithFormat:@"%@%@", DESC_(@""), [NSString stringWithFormat:(fmt), ##__VA_ARGS__]] logLevelParam:OM_LOG_LEVEL_WARNING exceptionParam:nil errorParam:nil];

#define OM_LOG_INFO_(fmt,...) \
[[LogManager sharedLogManager] log:[NSString stringWithFormat:@"%@%@", DESC_(@""), [NSString stringWithFormat:(fmt), ##__VA_ARGS__]] logLevelParam:OM_LOG_LEVEL_INFO exceptionParam:nil errorParam:nil];

#define OM_LOG_CLASS_DEBUG_(object,fmt,...) \
[[LogManager sharedLogManager] log:[NSString stringWithFormat:@"%@%@", DESC_(@""), [NSString stringWithFormat:(fmt), ##__VA_ARGS__]] objectParam:object logLevelParam:OM_LOG_LEVEL_DEBUG exceptionParam:nil errorParam:nil];

typedef enum 
{
	OM_LOG_LEVEL_DEBUG,        // Only for debug purpose
	OM_LOG_LEVEL_INFO,         // Permanent info , exemple trackier starting log...
	OM_LOG_LEVEL_WARNING,      // Potential error but causing no damage to the user interface, Exemple : missing attribute parsed in json but causing no damage for the application
	OM_LOG_LEVEL_ERROR,        // Technical error, do handle that error in order the app stay stable and no artefacts appear for user. Exemple : bad server response, retry...
	OM_LOG_LEVEL_FATAL         // Technical algorithmic error, app unstable, potential crash. This MUST NOT APPEAR WHEN SUBMITTING TO APPLE STORE
}OM_LOG_LEVEL;


/**
 * Use this sungleton class instead of all other log 
 * Rather use OM_LOG_DEBUG_, OM_LOG_WARNING_, OM_LOG_INFO_, OM_LOG_CLASS_DEBUG_ above for shortness in your code
 * Do use log:(NSString*)message... function for OM_LOG_LEVEL_ERROR and OM_LOG_LEVEL_FATAL logs as you may pass NSException and/or NSError for those types of logs
 */
@interface OMLogManager : NSObject {
    NSArray             *_classesIncluded;
    NSArray             *_classesExcluded;
}


/**
 * Way of tracking only debug messages on the classes you are working on without viewing logs of classes from other developpers (except those one in OM_LOG_LEVEL_ERROR, OM_LOG_LEVEL_FATAL)
 * Exemple : You are working on in-app purchases YMStoreInAppProduct and YMStore classes, put this in AppDelegate.m - you rarely commit - 
 * [LogManager sharedLogManager].classesIncluded =  [NSArray arrayWithObjects:[YMStoreInAppProduct class], [YMStore class], nil];
 * Then use OM_LOG_CLASS_DEBUG_(self,@"%@...",self.myattribute, ...)
 */

/*
 * Ignore log of object of classes not present in _classesIncluded only if _classesIncluded != nil
 */
@property (nonatomic,retain) NSArray            *classesIncluded;

/*
 * Ignore log of object of classes present in _classesExcluded
 */
@property (nonatomic,retain) NSArray            *classesExcluded;


/**
 * Log a message with a level and optionnal exception and error
 * @attention ERROR and FATAL logs will ever being output for debug safety reason
 */
- (void)log:(NSString*)message logLevelParam:(OM_LOG_LEVEL)logLevel exceptionParam:(NSException*)ex errorParam:(NSError*)err;

/**
 * Log a message with a level and optionnal exception and error
 * @attention the object parameter allow you to use the filter of excluded or included object class from output, ERROR and FATAL logs will ever being output for debug safety reason
 */
- (void)log:(NSString*)message objectParam:(id)object logLevelParam:(OM_LOG_LEVEL)logLevel exceptionParam:(NSException*)ex errorParam:(NSError*)err;


/**
 * [[LogManager sharedLogManager] ...]
 */
+ (OMLogManager *)sharedLogManager;

@end

//
//  OMAssertionHandler.m
//  OMGFramework
//
//  Created by Samuel Grau on 3/31/13.
//  Copyright (c) 2013 Samuel Grau. All rights reserved.
//

#import "OMAssertionHandler.h"

///-----------------------------------------------------------------------------
/// DDLog
///-----------------------------------------------------------------------------

#import "DDTTYLogger.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation OMAssertionHandler

- (void)handleFailureInFunction:(NSString *)functionName file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...
{
    DDLogError(@"[%@] Assertion failure: FUNCTION = (%@) in file = (%@) lineNumber = %i", [self class], functionName, fileName, line);
}

- (void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...
{
    DDLogError(@"[%@] Assertion failure: METHOD = (%@) for object = (%@) in file = (%@) lineNumber = %i", [self class], NSStringFromSelector(selector), object, fileName, line);
}

@end

//
//  NSException+OMConvenience.m
//  DicoReves
//
//  Created by Samuel Grau on 3/31/13.
//  Copyright (c) 2013 Samuel Grau. All rights reserved.
//

#import "NSException+OMConvenience.h"

@implementation NSException (OMConvenience)

+ (void)raiseGenericException:(NSString *)format, ... {
    va_list args;
	if (format) {
		va_start(args, format);
		NSString *logMsg = [[NSString alloc] initWithFormat:format arguments:args];
        [NSException raise:NSGenericException format:logMsg arguments:nil];
		va_end(args);
	}
}

@end

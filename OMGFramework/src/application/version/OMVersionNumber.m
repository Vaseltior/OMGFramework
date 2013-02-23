//
//  OMVersionNumber.m
//  OMGFramework
//
//  Created by Samuel Grau on 9/30/12.
//  Copyright (c) 2012 Samuel Grau. All rights reserved.
//

#import "OMVersionNumber.h"
#import "OMCoreHeader.h"

@interface OMVersionNumber ()
@property (nonatomic, retain) NSString * version;
@end

@implementation OMVersionNumber

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark -
#pragma mark Initialization
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (id)initWithString:(NSString *)version {
    self = [super init];
    if (self) {
        if (version == nil) {
            [NSException raise:NSInvalidArgumentException format:@"Version can not be nil"];
        } else {
            NSString * pattern = @"[0-9]+(\\.[0-9]+)*";
            NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
            NSTextCheckingResult *match = [regex firstMatchInString:version options:0 range:NSMakeRange(0, [version length])];
            
            if (!match) {
                [NSException raise:NSInvalidArgumentException format:@"Invalid version format"];
            } else {
                self.version = version;
            }
        }
        
    }
    return self;
}


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSString *)description {
    return _version;
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark -
#pragma mark Memory Management
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)dealloc {
    OMReleaseSafely(_version);
    [super dealloc];
}



// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark -
#pragma mark Public Methods
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSComparisonResult)compare:(OMVersionNumber *)version {
    if (version == nil) {
        [NSException raise:NSInvalidArgumentException format:@"version cannot be nil"];
    }
    
    NSArray * thisParts = [_version componentsSeparatedByString:@"."];
    NSArray * thatParts = [[version description] componentsSeparatedByString:@"."];
    
    NSUInteger length = MAX([thisParts count], [thatParts count]);
    for (NSUInteger i=0; i<length; i++) {
        NSUInteger thisPart = (i < [thisParts count]) ? (NSUInteger)[[thisParts objectAtIndex:i] integerValue] : 0;
        NSUInteger thatPart = (i < [thatParts count]) ? (NSUInteger)[[thatParts objectAtIndex:i] integerValue] : 0;
        
        if (thisPart < thatPart) {
            return NSOrderedAscending;
        }
        
        if (thisPart > thatPart) {
            return NSOrderedDescending;
        }
    }
    
    return NSOrderedSame;
    
}


@end

//
//  NSArray+OMG.m
//  OMGFramework
//
//  Created by Samuel Grau on 10/4/12.
//  Copyright (c) 2012 Samuel Grau. All rights reserved.
//

#import "NSArray+OMG.h"

@implementation NSArray (OMG)


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark -
#pragma mark Boundaries
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (BOOL)omgIndexOutOfBounds:(NSUInteger)index {
    return ((NSInteger)index < 0) || (index >= [self count]);
}


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark -
#pragma mark Selector invocations
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)omgPerform:(SEL)selector withObject:(id)p1 {
    NSArray *copy = [[NSArray alloc] initWithArray:self];
    NSEnumerator* e = [copy objectEnumerator];
    for (id delegate; (delegate = [e nextObject]); ) {
        if ([delegate respondsToSelector:selector]) {
            [delegate performSelector:selector withObject:p1];
        }
    }
    [copy release];
}


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)omgPerform:(SEL)selector withObject:(id)p1 withObject:(id)p2 {
    NSArray *copy = [[NSArray alloc] initWithArray:self];
    NSEnumerator* e = [copy objectEnumerator];
    for (id delegate; (delegate = [e nextObject]); ) {
        if ([delegate respondsToSelector:selector]) {
            [delegate performSelector:selector withObject:p1 withObject:p2];
        }
    }
    [copy release];
}

@end

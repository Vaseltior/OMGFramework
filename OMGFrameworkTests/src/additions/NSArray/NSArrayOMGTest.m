//
//  NSArrayOMGTest.m
//  OMGFramework
//
//  Created by Samuel Grau on 10/4/12.
//  Copyright (c) 2012 Samuel Grau. All rights reserved.
//

#import "NSArrayOMGTest.h"
#import "OMGFramework.h"

@implementation NSArrayOMGTest

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)testOMGIndexOutOfBounds {
    NSArray * a = @[@"1", @(2)];
    STAssertTrue([a omgIndexOutOfBounds:2], nil);
    STAssertFalse([a omgIndexOutOfBounds:1], nil);
    STAssertFalse([a omgIndexOutOfBounds:0], nil);
    
    STAssertTrue([a omgIndexOutOfBounds:(NSUInteger)-1], nil);

    a = @[];
    STAssertTrue([a omgIndexOutOfBounds:0], @"We should be out of bound for index 0 on an empty array");
}

@end

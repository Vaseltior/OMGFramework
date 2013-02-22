//
//  OMVersionNumberTest.m
//  OMGFramework
//
//  Created by Samuel Grau on 9/30/12.
//  Copyright (c) 2012 Samuel Grau. All rights reserved.
//

#import "OMVersionNumberTest.h"
#import "OMGFramework.h"

@implementation OMVersionNumberTest

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark -
#pragma mark Public
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)setUp {
    [super setUp];
    
    // Set-up code here.
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)testSimpleComparison {
    OMVersionNumber * om1 = nil;
    OMVersionNumber * om2 = nil;
    
    om1 = [[OMVersionNumber alloc] initWithString:@"1.0"];
    om2 = [[OMVersionNumber alloc] initWithString:@"1.1"];
    
    STAssertTrue([om1 compare:om2] == NSOrderedAscending, nil);
    STAssertTrue([om2 compare:om1] == NSOrderedDescending, nil);
    STAssertFalse([om1 compare:om2] == NSOrderedSame, nil);
    OMReleaseSafely(om1); OMReleaseSafely(om2);
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)testComplexComparison {
    OMVersionNumber * om1 = nil;
    OMVersionNumber * om2 = nil;
    om1 = [[OMVersionNumber alloc] initWithString:@"1.0.1"];
    om2 = [[OMVersionNumber alloc] initWithString:@"1.1"];
    STAssertTrue([om1 compare:om2] == NSOrderedAscending, nil);
    STAssertTrue([om2 compare:om1] == NSOrderedDescending, nil);
    STAssertFalse([om1 compare:om2] == NSOrderedSame, nil);
    OMReleaseSafely(om1); OMReleaseSafely(om2);    
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)testCreation {
    STAssertThrows([[OMVersionNumber alloc] initWithString:@""], nil);
    STAssertThrows([[OMVersionNumber alloc] initWithString:@"az'"], nil);
    STAssertNoThrow([[OMVersionNumber alloc] initWithString:@"2"], nil);
    STAssertNoThrow([[OMVersionNumber alloc] initWithString:@"2.5"], nil);
    STAssertNoThrow([[OMVersionNumber alloc] initWithString:@"2.4567.4.6.4.3"], nil);
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)testNilComparison {
    OMVersionNumber * om1 = nil;
    om1 = [[OMVersionNumber alloc] initWithString:@"1.0"];
    STAssertThrows([om1 compare:nil], nil);
    OMReleaseSafely(om1);
}

@end

//
//  OMControlTest.m
//  OMGFramework
//
//  Created by Samuel Grau on 10/4/12.
//  Copyright (c) 2012 Samuel Grau. All rights reserved.
//

#import "OMControlTest.h"
#import "OMGFramework.h"
#import <UIKit/UIKit.h>

@implementation OMControlTest

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
- (void)testTitleForState {
    
    OMControl * om = nil;
    
    om = [[OMControl alloc] initWithFrame:CGRectZero];
    STAssertTrue([om titleForState:UIControlStateDisabled] == nil, nil);
    STAssertTrue([om titleForState:UIControlStateHighlighted] == nil, nil);
    STAssertTrue([om titleForState:UIControlStateNormal] == nil, nil);
    STAssertTrue([om titleForState:UIControlStateReserved] == nil, nil);
    STAssertTrue([om titleForState:UIControlStateSelected] == nil, nil);
    STAssertTrue([om titleForState:UIControlStateApplication] == nil, nil);

    STAssertFalse([om isHighlightedOrSelected], @"OMControl should not be selected when initialized");
    
    [om setTitle:@"a title" forState:UIControlStateNormal];
    STAssertTrue([[om titleForState:UIControlStateNormal] isEqualToString:@"a title"], nil);
    
    /*STAssertTrue([om1 compare:om2] == NSOrderedAscending, nil);
    STAssertTrue([om2 compare:om1] == NSOrderedDescending, nil);
    STAssertFalse([om1 compare:om2] == NSOrderedSame, nil);
    OMReleaseSafely(om1); OMReleaseSafely(om2);*/
    OMReleaseSafely(om);
}


@end

//
//  OMControlContent.m
//  OMGFramework
//
//  Created by Samuel Grau on 10/3/11.
//  Copyright 2011 OMGFramework. All rights reserved.
//

#import "OMControlContent.h"
#import "OMControl.h"
#import "OMGFramework.h"

@interface OMControlContent()

@property (nonatomic, strong) OMControl * control;

@end
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@implementation OMControlContent


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Initialization
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (id)initWithControl:(OMControl *)control {
    self = [super init];

    if ( self ) {
        self.control = control;
    }

    return self;
} /* initWithControl */


@end

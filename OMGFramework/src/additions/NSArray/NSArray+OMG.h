//
//  NSArray+OMG.h
//  OMGFramework
//
//  Created by Samuel Grau on 10/4/12.
//  Copyright (c) 2012 Samuel Grau. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @brief Category over the NSArray class.
 */
@interface NSArray (OMG)

/*! @name Boundaries */

/*!
 @brief Tell if the given index is out of the bounds of the current array.
 @param index The index to test boundaries
 @return YES if the index is in bounds, otherwise, NO
 */
- (BOOL)omgIndexOutOfBounds:(NSUInteger)index;

/*! @name Selector invocations */

/*!
 @brief Perform the selector on every object in the array that respond to that selector, using the _p1_ parameter.
 @param selector The selector to invoke
 @param p1 The parameter
 */
- (void)omgPerform:(SEL)selector withObject:(id)p1;

/*!
 @brief Perform the selector on every object in the array that respond to that selector, using the _p1_ and _p2_ parameters.
 @param selector The selector to invoke
 @param p1 The first parameter
 @param p2 The second parameter
 */
- (void)omgPerform:(SEL)selector withObject:(id)p1 withObject:(id)p2;

@end

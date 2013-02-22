//
//  OMVersionNumber.h
//  OMGFramework
//
//  Created by Samuel Grau on 9/30/12.
//  Copyright (c) 2012 Samuel Grau. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @brief Encapsulate the notion of version in a system. Like 2.0.13
 */
@interface OMVersionNumber : NSObject

/*!
 @brief Initialize the version number with a string representation of that version 
 @param version The version number string (eg : 1.4.0)
 @return OMVersionNumber
 */
- (id)initWithString:(NSString *)version;


/*!
 @brief Returns an NSComparisonResult value that indicates the lexical ordering within the receiver and a given string.
 @param version The string with which to compare the version of the receiver.
 This value must not be nil. If this value is nil, an exception is thrown.
 @return NSOrderedAscending if the version of the receiver precedes _version_ in lexical ordering, 
 NSOrderedSame if the version of the receiver and _version_ are equivalent in lexical value, 
 and NSOrderedDescending if the version of the receiver follows _version_.
 
 @warning *Important:* The value of _version_ must not be nil. If this value is nil, an exception is thrown.
 
 */
- (NSComparisonResult)compare:(OMVersionNumber *)version;

@end

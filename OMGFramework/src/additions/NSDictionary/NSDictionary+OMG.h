//
//  NSDictionary+AboundingNest.h
//  OMGFramework
//
//  Created by Samuel Grau on 04/12/11.
//  Copyright (c) 2011 Samuel Grau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (OMG)

/**
 * This method is an helper class and simple addition to NSDictionary
 * That will do this :
 * 1. prevent crashes when trying to insert nil value in a dictionary
 * 2. checking class mismatch
 * 3. returning a default value if no object is found for the key
 *
 * @param key
 * @param aDict
 * @param aClass
 * @param defaultValue
 *
 * @return The value of the key in the dictionary aDict with the expected type aClass
 * if it exist, else return the defaultValue
 */
+ (id)vfk:(id)key wd:(NSDictionary *)aDict et:(Class)aClass dv:(id)defaultValue;

@end

//
//  NSObject+OMKVOConvenience.h
//  OMGFramework
//
//  Created by Samuel Grau on 3/30/13.
//  Copyright (c) 2013 Samuel Grau. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @brief Category that gives helper functions on KVO
 */
@interface NSObject (OMKVOConvenience)

/*!
 * @brief Loop over the array of keypaths returned by the omObservableKeyPaths
 * method
 */
- (void)omRegisterKeyPathsForKVO;

/*!
 * @brief Loop over the array of keypaths returned by the omObservableKeyPaths
 * method
 * @note This method could be called in `- (void)dealloc`
 */
- (void)omUnregisterKeyPathsFromKVO;

/*!
 * @brief Define the array of values that will be registered for KVO
 * @return An array of keypathes to register for KVO
 */
- (NSArray *)omObservableKeyPaths;

@end
